#include "dcl.h"
#include <ap_int.h>
#include <hls_stream.h>

// Reduced internal type (18-bit) for DSP optimization
typedef ap_fixed<18, 6, AP_RND, AP_SAT> short_data_t;
typedef ap_fixed<27, 9, AP_RND, AP_SAT> short_acc_t;
typedef ap_uint<576> wide_short_t; // 32 * 18 bits
typedef ap_uint<1024> wide_t;

// --- Sub-Kernel Functions (Required for Canonical Dataflow) ---

static void read_input(const wide_t* in, hls::stream<wide_t>& to_k0) {
    for (int i = 0; i < N / 32; i++) {
        #pragma HLS pipeline II=1
        // Point-to-point move from M_AXI to local FIFO
        to_k0.write(in[i]);
    }
}

static void proc_K0(hls::stream<wide_t>& from_input, 
                    hls::stream<wide_short_t>& to_k1, 
                    hls::stream<wide_short_t>& to_k2) {
    const short_data_t alpha = 0.875;
    const short_data_t beta  = 0.125;
    for (int i = 0; i < N / 32; i++) {
        #pragma HLS pipeline II=1
        // Reading from a local stream is MUCH faster than reading from a bus
        wide_t temp = from_input.read(); 
        wide_short_t out_v;
        for (int j = 0; j < 32; j++) {
            #pragma HLS unroll
            data_t val; val.range() = temp.range(j*32+31, j*32);
            short_data_t s_val = (short_data_t)val;
            // Native 18-bit DSP path with M and P registers
            short_data_t res = (short_data_t)(alpha * s_val + beta);
            #pragma HLS BIND_OP variable=res op=mul impl=dsp latency=3
            out_v.range(j*18+17, j*18) = res.range();
        }
        to_k1.write(out_v);
        to_k2.write(out_v);
    }
}

static void proc_K1(hls::stream<wide_short_t>& from_k0, hls::stream<wide_short_t>& to_k3) {
    const short_data_t w0 = 0.50, w1 = -0.25, w2 = 0.125;
    short_data_t p1 = 0, p2 = 0;
    for (int i = 0; i < N / 32; i++) {
        #pragma HLS pipeline II=1
        wide_short_t in_v = from_k0.read();
        wide_short_t out_v;
        short_data_t curr[32];
        #pragma HLS array_partition variable=curr complete

        for (int j = 0; j < 32; j++) {
            #pragma HLS unroll
            curr[j].range() = in_v.range(j*18+17, j*18);
        }

        for (int j = 0; j < 32; j++) {
            #pragma HLS unroll
            short_data_t x0 = curr[j];
            short_data_t x1 = (j >= 1) ? curr[j-1] : p1;
            short_data_t x2 = (j >= 2) ? curr[j-2] : ((j == 1) ? p1 : p2);

            // Use DSP cascade: m0+m1 in one DSP, then +m2
            short_data_t m0 = x0 * w0;
            #pragma HLS BIND_OP variable=m0 op=mul impl=dsp latency=2
            short_data_t m1 = x1 * w1;
            #pragma HLS BIND_OP variable=m1 op=mul impl=dsp latency=2
            short_data_t m2 = x2 * w2;
            #pragma HLS BIND_OP variable=m2 op=mul impl=dsp latency=2

            // Two-input add only (not three)
            short_data_t sum01 = m0 + m1;
            short_data_t acc = sum01 + m2;

            // Simplified clamp: single comparison using unsigned abs
            ap_uint<18> abs_val = acc.range();
            if (acc < 0) abs_val = (-acc).range();
            short_data_t y;
            const short_data_t limit = 7.5;
            if (acc < 0) {
                y = (-acc > limit) ? limit : (short_data_t)(-acc);
            } else {
                y = (acc > limit) ? limit : acc;
            }
        
            out_v.range(j*18+17, j*18) = y.range();
        }
        p1 = curr[31]; p2 = curr[30];
        to_k3.write(out_v);
    }
}

static void proc_K2(hls::stream<wide_short_t>& from_k0, hls::stream<stat_t>& to_k3) {
    for (int b = 0; b < N / BLOCK; b++) {
        ap_fixed<27, 9> total_sum = 0;
        for (int i = 0; i < BLOCK / 32; i++) {
            #pragma HLS pipeline II=1
            wide_short_t in_v = from_k0.read();

            ap_uint<18> abs_v[32];
            #pragma HLS array_partition variable=abs_v complete
            for (int j = 0; j < 32; j++) {
                #pragma HLS unroll
                short_data_t v;
                v.range() = in_v.range(j*18+17, j*18);
                abs_v[j] = (v < 0) ? ap_uint<18>((-v).range()) : ap_uint<18>(v.range());
            }

            ap_uint<20> s1[8];
            #pragma HLS array_partition variable=s1 complete
            for (int j = 0; j < 8; j++) {
                #pragma HLS unroll
                s1[j] = (abs_v[4*j] + abs_v[4*j+1]) +
                         (abs_v[4*j+2] + abs_v[4*j+3]);
            }

            ap_uint<22> q0 = s1[0] + s1[1];
            ap_uint<22> q1 = s1[2] + s1[3];
            ap_uint<22> q2 = s1[4] + s1[5];
            ap_uint<22> q3 = s1[6] + s1[7];
            ap_uint<23> h0 = q0 + q1;
            ap_uint<23> h1 = q2 + q3;
            ap_uint<23> block_sum = h0 + h1;

            total_sum += block_sum;
        }
        // FIX 2: Compute reciprocal here instead of in K3
        stat_t avg = (stat_t)(total_sum / BLOCK) + (stat_t)0.5;
        stat_t inv = (stat_t)((stat_t)1.0 / avg);
        to_k3.write(inv);
    }
}

// FIX 3: K3 no longer divides — just reads the reciprocal directly
static void proc_K3(hls::stream<wide_short_t>& from_k1,
                     hls::stream<stat_t>& from_k2,
                     hls::stream<wide_short_t>& to_k4) {
    for (int b = 0; b < N / BLOCK; b++) {
        stat_t inv_st = from_k2.read(); // already reciprocal
        for (int i = 0; i < BLOCK / 32; i++) {
            #pragma HLS pipeline II=1
            wide_short_t in_v = from_k1.read();
            wide_short_t out_v;
            for (int j = 0; j < 32; j++) {
                #pragma HLS unroll
                short_data_t v;
                v.range() = in_v.range(j*18+17, j*18);
                short_data_t res = v * (short_data_t)inv_st;
                #pragma HLS BIND_OP variable=res op=mul impl=dsp latency=3
                out_v.range(j*18+17, j*18) = res.range();
            }
            to_k4.write(out_v);
        }
    }
}

// --- Output Decoupler ---
static void write_output(hls::stream<wide_t>& from_k4, wide_t* out) {
    for (int i = 0; i < N / 32; i++) {
        #pragma HLS pipeline II=1
        out[i] = from_k4.read();
    }
}

static void proc_K4(hls::stream<wide_short_t>& from_k3, hls::stream<wide_t>& to_output) {
    const short_data_t gamma = 1.25, delta = 0.05;
    for (int i = 0; i < N / 32; i++) {
        #pragma HLS pipeline II=1
        wide_short_t in_v = from_k3.read();
        wide_t out_v;
        for (int j = 0; j < 32; j++) {
            #pragma HLS unroll
            short_data_t v; v.range() = in_v.range(j*18+17, j*18);
            short_data_t z = (short_data_t)(gamma * v + delta);
            #pragma HLS BIND_OP variable=z op=mul impl=dsp latency=3

            // Single-level clamp using ternary
            const short_data_t lo = 0, hi = 7.9;
            short_data_t clamped = (z < lo) ? lo : ((z > hi) ? hi : z);

            data_t f_z = (data_t)clamped;
            out_v.range(j*32+31, j*32) = f_z.range();
        }
        to_output.write(out_v);
    }
}

// --- Top Level ---

void top_kernel(const data_t in[N], data_t out[N]) {
#pragma HLS interface m_axi port=in offset=slave bundle=in
#pragma HLS interface m_axi port=out offset=slave bundle=out
#pragma HLS interface s_axilite port=return

    // Internal streams for decoupling
    hls::stream<wide_t> raw_in, raw_out;
    hls::stream<wide_short_t> s0_k1, s0_k2, s1_k3, s3_k4;
    hls::stream<stat_t> stats;
    #pragma HLS stream variable=raw_in  depth=32 type=fifo
    #pragma HLS stream variable=raw_out depth=32 type=fifo
    #pragma HLS stream variable=s0_k1   depth=32 type=fifo
    #pragma HLS stream variable=s0_k2   depth=32 type=fifo
    #pragma HLS stream variable=s1_k3   depth=512 type=fifo
    #pragma HLS stream variable=s3_k4   depth=32 type=fifo
    #pragma HLS stream variable=stats   depth=4 type=fifo   

    #pragma HLS dataflow
    read_input((const wide_t*)in, raw_in);
    proc_K0(raw_in, s0_k1, s0_k2);
    proc_K1(s0_k1, s1_k3);
    proc_K2(s0_k2, stats);
    proc_K3(s1_k3, stats, s3_k4);
    proc_K4(s3_k4, raw_out);
    write_output(raw_out, (wide_t*)out);
}