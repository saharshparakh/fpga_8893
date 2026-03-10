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
            
            short_acc_t abs_v[32];
            #pragma HLS array_partition variable=abs_v complete
            for (int j = 0; j < 32; j++) {
                #pragma HLS unroll
                short_data_t v; v.range() = in_v.range(j*18+17, j*18);
                short_acc_t a = (v < 0) ? (short_acc_t)(-v) : (short_acc_t)v;
                // STAGE 1 FENCE
                #pragma HLS BIND_OP variable=a op=add impl=dsp latency=1
                abs_v[j] = a;
            }

            // STAGE 2 FENCE: Tree Levels 1 & 2 combined
            short_acc_t s2[8];
            #pragma HLS array_partition variable=s2 complete
            for(int j=0; j<8; j++) {
                #pragma HLS unroll
                short_acc_t sum_l2 = (abs_v[j*4] + abs_v[j*4+1]) + (abs_v[j*4+2] + abs_v[j*4+3]);
                #pragma HLS BIND_OP variable=sum_l2 op=add impl=dsp latency=1
                s2[j] = sum_l2;
            }

            // STAGE 3: Final reduction (The path is short enough for fabric here)
            short_acc_t s3_0 = s2[0] + s2[1];
            short_acc_t s3_1 = s2[2] + s2[3];
            short_acc_t s3_2 = s2[4] + s2[5];
            short_acc_t s3_3 = s2[6] + s2[7];

            short_acc_t s4_0 = s3_0 + s3_1;
            short_acc_t s4_1 = s3_2 + s3_3;

            // Final reduction: Force to DSP to break the connection to the final accumulator
            short_acc_t block_sum = s4_0 + s4_1;
            #pragma HLS BIND_OP variable=block_sum op=add impl=dsp latency=1
            total_sum += block_sum;
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
            #pragma HLS BIND_OP variable=z op=mul impl=dsp latency=2
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