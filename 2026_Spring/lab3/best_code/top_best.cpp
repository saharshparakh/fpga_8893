#include "dcl.h"
#include <ap_int.h>
#include <hls_stream.h>

// Reduced internal type (18-bit) for DSP optimization
typedef ap_fixed<18, 6, AP_RND, AP_SAT> short_data_t;
typedef ap_fixed<27, 9, AP_RND, AP_SAT> short_acc_t;
typedef ap_uint<576> wide_short_t; // 32 * 18 bits
typedef ap_uint<1024> wide_t;

// --- Sub-Kernel Functions (Required for Canonical Dataflow) ---

static void proc_K0(const wide_t* in, hls::stream<wide_short_t>& to_k1, hls::stream<wide_short_t>& to_k2) {
    const short_data_t alpha = 0.875;
    const short_data_t beta  = 0.125;
    for (int i = 0; i < N / 32; i++) {
        #pragma HLS pipeline II=1
        wide_t temp = in[i];
        wide_short_t out_v;
        for (int j = 0; j < 32; j++) {
            #pragma HLS unroll
            data_t val; val.range() = temp.range(j*32+31, j*32);
            // Internal DSP pipeline stage
            short_data_t res = (short_data_t)(alpha * (short_data_t)val + beta);
            #pragma HLS BIND_OP variable=res op=mul impl=dsp latency=1
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
            
            // Forcing DSP internal registers to hit 1.44ns
            short_data_t m0 = x0 * w0;
            #pragma HLS BIND_OP variable=m0 op=mul impl=dsp latency=2
            short_data_t m1 = x1 * w1;
            #pragma HLS BIND_OP variable=m1 op=mul impl=dsp latency=2
            short_data_t m2 = x2 * w2;
            #pragma HLS BIND_OP variable=m2 op=mul impl=dsp latency=2

            short_acc_t acc = m0 + m1 + m2;
            short_data_t y = (short_data_t)acc;

            if (y < 0) y = -y;
            if (y > 7.5) y = 7.5;
            out_v.range(j*18+17, j*18) = y.range();
        }
        p1 = curr[31]; p2 = curr[30];
        to_k3.write(out_v);
    }
}

static void proc_K2(hls::stream<wide_short_t>& from_k0, hls::stream<stat_t>& to_k3) {
    for (int b = 0; b < N / BLOCK; b++) {
        short_acc_t total_sum = 0;
        for (int i = 0; i < BLOCK / 32; i++) {
            #pragma HLS pipeline II=1
            wide_short_t in_v = from_k0.read();
            short_data_t vals[32];
            #pragma HLS array_partition variable=vals complete
            
            for (int j = 0; j < 32; j++) {
                #pragma HLS unroll
                short_data_t v; v.range() = in_v.range(j*18+17, j*18);
                vals[j] = (v < 0) ? (short_data_t)(-v) : v;
            }

            // Pipelined Adder Tree: Logic Depth 5 instead of 32
            short_acc_t s1[16];
            #pragma HLS array_partition variable=s1 complete
            for(int j=0; j<16; j++) {
                #pragma HLS unroll
                s1[j] = vals[j*2] + vals[j*2+1];
            }

            short_acc_t s2[8];
            #pragma HLS array_partition variable=s2 complete
            for(int j=0; j<8; j++) {
                #pragma HLS unroll
                s2[j] = s1[j*2] + s1[j*2+1];
            }

            short_acc_t s3[4];
            #pragma HLS array_partition variable=s3 complete
            for(int j=0; j<4; j++) {
                #pragma HLS unroll
                s3[j] = s2[j*2] + s2[j*2+1];
            }

            short_acc_t s4[2];
            #pragma HLS array_partition variable=s4 complete
            for(int j=0; j<2; j++) {
                #pragma HLS unroll
                s4[j] = s3[j*2] + s3[j*2+1];
            }

            total_sum += (s4[0] + s4[1]);
        }
        to_k3.write((stat_t)(total_sum / BLOCK) + (stat_t)0.5);
    }
}

static void proc_K3(hls::stream<wide_short_t>& from_k1, hls::stream<stat_t>& from_k2, hls::stream<wide_short_t>& to_k4) {
    for (int b = 0; b < N / BLOCK; b++) {
        stat_t inv_st = (stat_t)((stat_t)1.0 / from_k2.read());
        for (int i = 0; i < BLOCK / 32; i++) {
            #pragma HLS pipeline II=1
            wide_short_t in_v = from_k1.read();
            wide_short_t out_v;
            for (int j = 0; j < 32; j++) {
                #pragma HLS unroll
                short_data_t v; v.range() = in_v.range(j*18+17, j*18);
                short_data_t res = v * (short_data_t)inv_st;
                // Deeper latency for the normalization mult
                #pragma HLS BIND_OP variable=res op=mul impl=dsp latency=2
                out_v.range(j*18+17, j*18) = res.range();
            }
            to_k4.write(out_v);
        }
    }
}

static void proc_K4(hls::stream<wide_short_t>& from_k3, wide_t* out) {
    const short_data_t gamma = 1.25, delta = 0.05;
    for (int i = 0; i < N / 32; i++) {
        #pragma HLS pipeline II=1
        wide_short_t in_v = from_k3.read();
        wide_t out_v;
        for (int j = 0; j < 32; j++) {
            #pragma HLS unroll
            short_data_t v; v.range() = in_v.range(j*18+17, j*18);
            short_data_t z = (short_data_t)(gamma * v + delta);
            #pragma HLS BIND_OP variable=z op=mul impl=dsp latency=1
            if (z < 0) z = 0; if (z > 7.9) z = 7.9;
            data_t f_z = (data_t)z;
            out_v.range(j*32+31, j*32) = f_z.range();
        }
        out[i] = out_v;
    }
}

// --- Top Level ---

void top_kernel(const data_t in[N], data_t out[N]) {
#pragma HLS interface m_axi port=in offset=slave bundle=in
#pragma HLS interface m_axi port=out offset=slave bundle=out
#pragma HLS interface s_axilite port=return

    hls::stream<wide_short_t> s0_k1, s0_k2, s1_k3, s3_k4;
    hls::stream<stat_t> stats;
    
    // Increased depths to prevent deadlock during K2's block-averaging latency
    #pragma HLS stream variable=s0_k1 depth=16
    #pragma HLS stream variable=s0_k2 depth=16
    #pragma HLS stream variable=s1_k3 depth=512 // Essential: must hold elements while K2 finishes block
    #pragma HLS stream variable=stats depth=4
    #pragma HLS stream variable=s3_k4 depth=16

    #pragma HLS dataflow
    proc_K0((const wide_t*)in, s0_k1, s0_k2);
    proc_K1(s0_k1, s1_k3);
    proc_K2(s0_k2, stats);
    proc_K3(s1_k3, stats, s3_k4);
    proc_K4(s3_k4, (wide_t*)out);
}