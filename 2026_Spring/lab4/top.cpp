#include "dcl.h"
#include <ap_int.h>
#include <hls_stream.h>

#ifndef __SYNTHESIS__
#include <cmath>
#else
#include "hls_math.h"
#endif

// ==========================================
// Custom Types 
// ==========================================
typedef ap_uint<1024> wide_t;
typedef ap_fixed<12, 2, AP_RND, AP_SAT> dsp_coeff_t;
typedef ap_fixed<12, 6, AP_RND, AP_SAT> internal_dct_t;

// [ARCHITECTURE] Stream Widening (Vector-8)
// Packs 8 values into a single struct. This guarantees we utilize 256 DSPs 
// in the compute kernels (leaving ~100 for safety) and drops the stream latency 
// to 32 cycles per image.
struct dct_vec8_t {
    internal_dct_t p[8];
};

// ==========================================
// TIGHT MATH: Pre-computed Cosine LUT
// ==========================================
const dsp_coeff_t cos_lut_f[16][16] = {
    { 0.707107f,  0.995185f,  0.980785f,  0.956940f,  0.923880f,  0.881921f,  0.831470f,  0.773010f,  0.707107f,  0.634393f,  0.555570f,  0.471397f,  0.382683f,  0.290285f,  0.195090f,  0.098017f},
    { 0.707107f,  0.956940f,  0.831470f,  0.634393f,  0.382683f,  0.098017f, -0.195090f, -0.471397f, -0.707107f, -0.881921f, -0.980785f, -0.995185f, -0.923880f, -0.773010f, -0.555570f, -0.290285f},
    { 0.707107f,  0.881921f,  0.555570f,  0.098017f, -0.382683f, -0.773010f, -0.980785f, -0.956940f, -0.707107f, -0.290285f,  0.195090f,  0.634393f,  0.923880f,  0.995185f,  0.831470f,  0.471397f},
    { 0.707107f,  0.773010f,  0.195090f, -0.471397f, -0.923880f, -0.956940f, -0.555570f,  0.098017f,  0.707107f,  0.995185f,  0.831470f,  0.290285f, -0.382683f, -0.881921f, -0.980785f, -0.634393f},
    { 0.707107f,  0.634393f, -0.195090f, -0.881921f, -0.923880f, -0.290285f,  0.555570f,  0.995185f,  0.707107f, -0.098017f, -0.831470f, -0.956940f, -0.382683f,  0.471397f,  0.980785f,  0.773010f},
    { 0.707107f,  0.471397f, -0.555570f, -0.995185f, -0.382683f,  0.634393f,  0.980785f,  0.290285f, -0.707107f, -0.956940f, -0.195090f,  0.773010f,  0.923880f,  0.098017f, -0.831470f, -0.881921f},
    { 0.707107f,  0.290285f, -0.831470f, -0.773010f,  0.382683f,  0.995185f,  0.195090f, -0.881921f, -0.707107f,  0.471397f,  0.980785f,  0.098017f, -0.923880f, -0.634393f,  0.555570f,  0.956940f},
    { 0.707107f,  0.098017f, -0.980785f, -0.290285f,  0.923880f,  0.471397f, -0.831470f, -0.634393f,  0.707107f,  0.773010f, -0.555570f, -0.881921f,  0.382683f,  0.956940f, -0.195090f, -0.995185f},
    { 0.707107f, -0.098017f, -0.980785f,  0.290285f,  0.923880f, -0.471397f, -0.831470f,  0.634393f,  0.707107f, -0.773010f, -0.555570f,  0.881921f,  0.382683f, -0.956940f, -0.195090f,  0.995185f},
    { 0.707107f, -0.290285f, -0.831470f,  0.773010f,  0.382683f, -0.995185f,  0.195090f,  0.881921f, -0.707107f, -0.471397f,  0.980785f, -0.098017f, -0.923880f,  0.634393f,  0.555570f, -0.956940f},
    { 0.707107f, -0.471397f, -0.555570f,  0.995185f, -0.382683f, -0.634393f,  0.980785f, -0.290285f, -0.707107f,  0.956940f, -0.195090f, -0.773010f,  0.923880f, -0.098017f, -0.831470f,  0.881921f},
    { 0.707107f, -0.634393f, -0.195090f,  0.881921f, -0.923880f,  0.290285f,  0.555570f, -0.995185f,  0.707107f,  0.098017f, -0.831470f,  0.956940f, -0.382683f, -0.471397f,  0.980785f, -0.773010f},
    { 0.707107f, -0.773010f,  0.195090f,  0.471397f, -0.923880f,  0.956940f, -0.555570f, -0.098017f,  0.707107f, -0.995185f,  0.831470f, -0.290285f, -0.382683f,  0.881921f, -0.980785f,  0.634393f},
    { 0.707107f, -0.881921f,  0.555570f, -0.098017f, -0.382683f,  0.773010f, -0.980785f,  0.956940f, -0.707107f,  0.290285f,  0.195090f, -0.634393f,  0.923880f, -0.995185f,  0.831470f, -0.471397f},
    { 0.707107f, -0.956940f,  0.831470f, -0.634393f,  0.382683f, -0.098017f, -0.195090f,  0.471397f, -0.707107f,  0.881921f, -0.980785f,  0.995185f, -0.923880f,  0.773010f, -0.555570f,  0.290285f},
    { 0.707107f, -0.995185f,  0.980785f, -0.956940f,  0.923880f, -0.881921f,  0.831470f, -0.773010f,  0.707107f, -0.634393f,  0.555570f, -0.471397f,  0.382683f, -0.290285f,  0.195090f, -0.098017f}
};

// ==========================================
// Sub-Kernel Declarations
// ==========================================

/*
 * Kernel 0: Data Ingestion
 * Theory: Isolates the AXI memory-mapped interface from the compute logic.
 */
static void read_input(const wide_t* in, hls::stream<wide_t>& out_stream) {
    int total_words = (NUM_IMAGES * IMG_W * IMG_H * 3) / 128;
    
    // [ARCHITECTURE] AXI Burst Reader
    for (int i = 0; i < total_words; i++) {
        #pragma HLS pipeline II=1
        out_stream.write(in[i]);
    }
}

/*
 * Kernel 1: Grayscale Conversion & Spatial Downsampling
 */
static void kernel1_preprocess(hls::stream<wide_t>& in_stream, hls::stream<dct_vec8_t>& out_stream) {
    dct_t w_r = dct_t(0.299 / 255.0);
    dct_t w_g = dct_t(0.587 / 255.0);
    dct_t w_b = dct_t(0.114 / 255.0);
    
    for (int img = 0; img < NUM_IMAGES; img++) {
        pixel_t local_img[IMG_H * IMG_W * 3];
        
        // [ARCHITECTURE] Cyclic Array Partitioning (Factor 512)
        // Eliminates BRAM port collisions by scattering the image across 512 banks.
        // Provides the 384 parallel reads necessary to compute 8 blocks per cycle.
        #pragma HLS bind_storage variable=local_img type=RAM_1P impl=BRAM
        #pragma HLS array_partition variable=local_img cyclic factor=512 dim=1
        
        for (int w = 0; w < (IMG_H * IMG_W * 3) / 128; w++) {
            #pragma HLS pipeline II=1
            wide_t word = in_stream.read();
            for (int p = 0; p < 128; p++) {
                int p8 = 8 * p;
                local_img[w * 128 + p] = word(p8 + 7, p8);
            }
        }
        
        // [ALGORITHM] 4x4 Spatial Downsampling (Vector-8)
        for (int r = 0; r < N_DCT; r++) {
            for (int c_blk = 0; c_blk < 2; c_blk++) {
                #pragma HLS pipeline II=1
                dct_vec8_t out_vec;
                int base_row = r * BOX_SIZE;
                
                for (int v = 0; v < 8; v++) {
                    #pragma HLS unroll
                    int c = c_blk * 8 + v;
                    dct_t sum = 0; 
                    int base_col = c * BOX_SIZE;                
                    
                    for (int br = 0; br < BOX_SIZE; br++) {
                        #pragma HLS unroll
                        int row_offset = (base_row + br) * IMG_W;
                        int base_idx = (row_offset + base_col) * 3;

                        for (int bc = 0; bc < BOX_SIZE; bc++) {
                            #pragma HLS unroll
                            int idx = base_idx + (bc * 3);
                            
                            dct_t r_val = dct_t(local_img[idx + 0]) * w_r;
                            dct_t g_val = dct_t(local_img[idx + 1]) * w_g;
                            dct_t b_val = dct_t(local_img[idx + 2]) * w_b;
                            sum += (r_val + g_val + b_val);
                        }
                    }
                    out_vec.p[v] = internal_dct_t(sum >> 4);
                }
                out_stream.write(out_vec);
            }
        }
    }
}

/*
 * Kernel 2: 1D Discrete Cosine Transform (Rows)
 */
static void kernel2_rowdct(hls::stream<dct_vec8_t>& in_stream, hls::stream<dct_vec8_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_gray[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Complete Array Partitioning (Columns)
        // Shatters columns into registers so an entire row can be read simultaneously.
        #pragma HLS array_partition variable=local_gray complete dim=2
        
        for (int r = 0; r < N_DCT; r++) {
            for (int c_blk = 0; c_blk < 2; c_blk++) {
                #pragma HLS pipeline II=1
                dct_vec8_t in_vec = in_stream.read();
                for (int v = 0; v < 8; v++) {
                    #pragma HLS unroll
                    local_gray[r][c_blk * 8 + v] = in_vec.p[v];
                }
            }
        }
        
        // [MATH] 1D Row DCT Matrix Multiplication (Vector-8)
        for (int r = 0; r < N_DCT; r++) {
            for (int u_blk = 0; u_blk < 2; u_blk++) {
                // [ARCHITECTURE] 128-DSP Engine
                // Processes 8 frequency bins per cycle. Uses 128 DSPs (safe within 360 limit).
                #pragma HLS pipeline II=1
                dct_vec8_t out_vec;
                
                for (int v = 0; v < 8; v++) {
                    #pragma HLS unroll
                    int u = u_blk * 8 + v;
                    dct_t sum = 0; 
                    for (int c = 0; c < N_DCT; c++) {
                        #pragma HLS unroll
                        sum += local_gray[r][c] * cos_lut_f[c][u];
                    }
                    out_vec.p[v] = internal_dct_t(sum);
                }
                out_stream.write(out_vec);
            }
        }
    }
}

/*
 * Kernel 3: 1D Discrete Cosine Transform (Columns)
 */
static void kernel3_coldct(hls::stream<dct_vec8_t>& in_stream, hls::stream<dct_vec8_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_rowdct[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Complete Array Partitioning (Rows)
        // Shatters rows into registers to compute column math simultaneously.
        #pragma HLS array_partition variable=local_rowdct complete dim=1
        
        for (int r = 0; r < N_DCT; r++) {
            for (int c_blk = 0; c_blk < 2; c_blk++) {
                #pragma HLS pipeline II=1
                dct_vec8_t in_vec = in_stream.read();
                for (int v = 0; v < 8; v++) {
                    #pragma HLS unroll
                    local_rowdct[r][c_blk * 8 + v] = in_vec.p[v];
                }
            }
        }
        
        // [MATH] 1D Column DCT Matrix Multiplication (Vector-8)
        for (int c = 0; c < N_DCT; c++) {
            for (int v_blk = 0; v_blk < 2; v_blk++) {
                // [ARCHITECTURE] 128-DSP Engine
                #pragma HLS pipeline II=1
                dct_vec8_t out_vec;
                
                for (int i = 0; i < 8; i++) {
                    #pragma HLS unroll
                    int v = v_blk * 8 + i;
                    dct_t sum_col = 0; 
                    for (int r = 0; r < N_DCT; r++) {
                        #pragma HLS unroll
                        sum_col += local_rowdct[r][c] * cos_lut_f[r][v];
                    }
                    out_vec.p[i] = internal_dct_t(sum_col);
                }
                out_stream.write(out_vec);
            }
        }
    }
}

/*
 * Kernel 4: Frequency Thresholding & Fingerprint Hash
 */
static void kernel4_hash(hls::stream<dct_vec8_t>& in_stream, hls::stream<hash_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_coldct[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Complete 2D Partitioning for K4
        // We fully partition the 8x8 region to allow instantaneous math operations
        // without routing collisions or sequential stalls.
        #pragma HLS array_partition variable=local_coldct complete dim=0
        
        for (int c = 0; c < N_DCT; c++) {
            for (int v_blk = 0; v_blk < 2; v_blk++) {
                #pragma HLS pipeline II=1
                dct_vec8_t in_vec = in_stream.read();
                for (int i = 0; i < 8; i++) {
                    #pragma HLS unroll
                    local_coldct[v_blk * 8 + i][c] = in_vec.p[i];
                }
            }
        }
        
        // [TIMING FIX]: The 30-Level Logic Violator
        // Previously, the summation was done inside a pipelined loop (hash_sum += ...), 
        // forcing a 1-cycle feedback constraint that shattered timing at 4ns.
        // We now FULLY unroll the math natively. HLS will schedule the 64-input adder tree
        // across 4-6 clock cycles safely, balancing the registers and easily hitting the 4ns timing.
        dct_t hash_sum = 0;
        for (int r = 0; r < 8; r++) {
            #pragma HLS unroll
            for (int c = 0; c < 8; c++) {
                #pragma HLS unroll
                hash_sum += local_coldct[r][c];
            }
        }
        
        hash_t hash_val = 0;
        for (int r = 0; r < 8; r++) {
            #pragma HLS unroll
            for (int c = 0; c < 8; c++) {
                #pragma HLS unroll
                if (local_coldct[r][c] > (hash_sum >> 6)) {
                    hash_val |= ((hash_t)1 << (r * 8 + c));
                }
            }
        }
        out_stream.write(hash_val);
    }
}

/*
 * Kernel 5: Distance Ranking & Top-K Sorter
 */
static void kernel5_ranker(hls::stream<hash_t>& in_stream, hash_t target_hash, TopKResult out_topk[TOP_K]) {
    for (int i = 0; i < TOP_K; i++) {
        #pragma HLS unroll
        out_topk[i].id = -1;
        out_topk[i].distance = 9999;
    }

    for (int img = 0; img < NUM_IMAGES; img++) {
        hash_t cur_hash = in_stream.read();
        
        hash_t diff = cur_hash ^ target_hash;
        int current_dist = 0;

        while (diff > 0) {
            diff = diff & (diff - 1);
            current_dist++;
        }
        
        int last_idx = TOP_K - 1;
        bool requires_insert = (current_dist < out_topk[last_idx].distance) || 
                               (current_dist == out_topk[last_idx].distance && img < out_topk[last_idx].id);
        
        if (requires_insert) {
            int insert_idx = last_idx;
            while (insert_idx > 0) {
                int prev_idx = insert_idx - 1;
                int prev_dist = out_topk[prev_idx].distance;
                bool is_better = (current_dist < prev_dist) || 
                                 (current_dist == prev_dist && img < out_topk[prev_idx].id);
                if (is_better) {
                    insert_idx = prev_idx;
                } else {
                    break;
                }
            }
            
            for (int s = last_idx; s > 0; s--) {
                if (s > insert_idx) {
                    out_topk[s] = out_topk[s - 1];
                }
            }
            out_topk[insert_idx].id = img;
            out_topk[insert_idx].distance = current_dist;
        }
    }
}

// ==========================================
// Top Level Function
// ==========================================
void top_kernel(
    const pixel_t input_rgb[NUM_IMAGES * IMG_W * IMG_H * 3],
    dct_t inter1_gray[NUM_IMAGES * N_DCT * N_DCT],
    dct_t inter2_rowdct[NUM_IMAGES * N_DCT * N_DCT],
    dct_t inter3_coldct[NUM_IMAGES * N_DCT * N_DCT],
    hash_t inter4_hash[NUM_IMAGES],
    hash_t target_hash,
    TopKResult out_topk[TOP_K] 
) {
#pragma HLS interface m_axi port=input_rgb offset=slave bundle=gmem0 max_read_burst_length=32 num_read_outstanding=32 latency=64 max_widen_bitwidth=1024
#pragma HLS interface m_axi port=out_topk offset=slave bundle=gmem1
#pragma HLS interface s_axilite port=target_hash
#pragma HLS interface s_axilite port=return

    #pragma HLS dataflow

    hls::stream<wide_t> raw_in("raw_in");
    hls::stream<dct_vec8_t> s_gray("s_gray");
    hls::stream<dct_vec8_t> s_rowdct("s_rowdct");
    hls::stream<dct_vec8_t> s_coldct("s_coldct");
    hls::stream<hash_t> s_hash("s_hash");

    // [TIMING FIX]: Stream Depth Expansion
    // Increasing raw_in depth to 128 guarantees we can buffer an entire image's worth of data.
    // This stops the AXI reader from stalling while K1 computes, slashing the overall cycle count.
    #pragma HLS stream variable=raw_in depth=128
    #pragma HLS stream variable=s_gray depth=32
    #pragma HLS stream variable=s_rowdct depth=32
    #pragma HLS stream variable=s_coldct depth=32
    #pragma HLS stream variable=s_hash depth=16

    read_input((const wide_t*)input_rgb, raw_in);
    kernel1_preprocess(raw_in, s_gray);
    kernel2_rowdct(s_gray, s_rowdct);
    kernel3_coldct(s_rowdct, s_coldct);
    kernel4_hash(s_coldct, s_hash);
    kernel5_ranker(s_hash, target_hash, out_topk);
}