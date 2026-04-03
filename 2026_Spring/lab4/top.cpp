#include "dcl.h"
#include <ap_int.h>
#include <hls_stream.h>

#ifndef __SYNTHESIS__
#include <cmath>
#else
#include "hls_math.h"
#endif

// ==========================================
// Custom Types for 1024-bit AXI
// ==========================================
typedef ap_uint<1024> wide_t;

// ==========================================
// Sub-Kernel Declarations
// ==========================================
static void read_input(const wide_t* in, hls::stream<wide_t>& out_stream) {
    // 1024 bits = 128 bytes (pixels)
    // Total pixels = NUM_IMAGES * 64 * 64 * 3 = 196608
    // Total 1024-bit words = 196608 / 128 = 1536
    int total_words = (NUM_IMAGES * IMG_W * IMG_H * 3) / 128;
    
    for (int i = 0; i < total_words; i++) {
        #pragma HLS pipeline II=1
        out_stream.write(in[i]);
    }
}

static void kernel1_preprocess(hls::stream<wide_t>& in_stream, hls::stream<dct_t>& out_stream) {
    dct_t w_r = dct_t(0.299 / 255.0);
    dct_t w_g = dct_t(0.587 / 255.0);
    dct_t w_b = dct_t(0.114 / 255.0);
    dct_t box_area = dct_t(BOX_SIZE * BOX_SIZE);

    for (int img = 0; img < NUM_IMAGES; img++) {
        // Local BRAM buffer to hold exactly 1 image
        pixel_t local_img[IMG_H * IMG_W * 3];
        #pragma HLS bind_storage variable=local_img type=RAM_1P impl=BRAM
        
        // Load 1 image from the wide stream (96 words per image)
        for (int w = 0; w < (IMG_H * IMG_W * 3) / 128; w++) {
            #pragma HLS pipeline II=1
            wide_t word = in_stream.read();
            for (int p = 0; p < 128; p++) {
                local_img[w * 128 + p] = word(8 * p + 7, 8 * p);
            }
        }
        
        // Baseline processing from local BRAM instead of DDR
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                dct_t sum = 0;
                for (int br = 0; br < BOX_SIZE; br++) {
                    for (int bc = 0; bc < BOX_SIZE; bc++) {
                        int idx = ((r * BOX_SIZE + br) * IMG_W + (c * BOX_SIZE + bc)) * 3;
                        dct_t r_val = dct_t(local_img[idx + 0]) * w_r;
                        dct_t g_val = dct_t(local_img[idx + 1]) * w_g;
                        dct_t b_val = dct_t(local_img[idx + 2]) * w_b;
                        sum += (r_val + g_val + b_val);
                    }
                }
                out_stream.write(sum / box_area); 
            }
        }
    }
}

static void kernel2_rowdct(hls::stream<dct_t>& in_stream, hls::stream<dct_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        // Buffer the 16x16 frame locally
        dct_t local_gray[N_DCT][N_DCT];
        
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                #pragma HLS pipeline II=1
                local_gray[r][c] = in_stream.read();
            }
        }
        
        for (int r = 0; r < N_DCT; r++) {
            for (int u = 0; u < N_DCT; u++) {
                dct_t sum = 0;
                for (int c = 0; c < N_DCT; c++) {
                    float math_val = 3.14159265358979323846 * (2.0 * c + 1.0) * u / (2.0 * N_DCT);
#ifndef __SYNTHESIS__
                    dct_t dynamic_cos = dct_t(std::cos(math_val));
#else
                    dct_t dynamic_cos = dct_t(hls::cos(math_val));
#endif
                    sum += local_gray[r][c] * dynamic_cos;
                }
                dct_t alpha = (u == 0) ? dct_t(0.70710678) : dct_t(1.0);
                out_stream.write(sum * alpha);
            }
        }
    }
}

static void kernel3_coldct(hls::stream<dct_t>& in_stream, hls::stream<dct_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        dct_t local_rowdct[N_DCT][N_DCT];
        
        // FIXED: Must read sequentially exactly how Kernel 2 wrote it (Row-Major)
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                #pragma HLS pipeline II=1
                local_rowdct[r][c] = in_stream.read();
            }
        }
        
        // Perform Col-DCT math 
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                dct_t sum_col = 0;
                for (int r = 0; r < N_DCT; r++) {
                    float math_val = 3.14159265358979323846 * (2.0 * r + 1.0) * v / (2.0 * N_DCT);
#ifndef __SYNTHESIS__
                    dct_t dynamic_cos = dct_t(std::cos(math_val));
#else
                    dct_t dynamic_cos = dct_t(hls::cos(math_val));
#endif
                    sum_col += local_rowdct[r][c] * dynamic_cos;
                }
                dct_t alpha_col = (v == 0) ? dct_t(0.70710678) : dct_t(1.0);
                
                // Writes Column-Major (c outer, v inner)
                out_stream.write(sum_col * alpha_col);
            }
        }
    }
}

static void kernel4_hash(hls::stream<dct_t>& in_stream, hls::stream<hash_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        dct_t local_coldct[N_DCT][N_DCT];
        
        // FIXED: Must read sequentially exactly how Kernel 3 wrote it (Column-Major)
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                #pragma HLS pipeline II=1
                local_coldct[v][c] = in_stream.read();
            }
        }
        
        dct_t hash_sum = 0;
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                hash_sum += local_coldct[r][c];
            }
        }
        
        hash_t hash_val = 0;
        int bit_pos = 0;
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                if (local_coldct[r][c] * dct_t(64.0) > hash_sum) {
                    hash_val |= ((hash_t)1 << bit_pos);
                }
                bit_pos++;
            }
        }
        out_stream.write(hash_val);
    }
}

static void kernel5_ranker(hls::stream<hash_t>& in_stream, hash_t target_hash, TopKResult out_topk[TOP_K]) {
    for (int i = 0; i < TOP_K; i++) {
        #pragma HLS unroll
        out_topk[i].id = -1;
        out_topk[i].distance = 9999;
    }

    for (int img = 0; img < NUM_IMAGES; img++) {
        hash_t cur_hash = in_stream.read();
        hash_t tgt_hash = target_hash;
        
        int current_dist = 0;
        for (int b = 0; b < 64; b++) {
            if ((cur_hash % 2) != (tgt_hash % 2)) {
                current_dist++;
            }
            cur_hash = cur_hash / 2;
            tgt_hash = tgt_hash / 2;
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
    dct_t inter1_gray[NUM_IMAGES * N_DCT * N_DCT],       // Kept in signature, decoupled in logic
    dct_t inter2_rowdct[NUM_IMAGES * N_DCT * N_DCT],     // Kept in signature, decoupled in logic
    dct_t inter3_coldct[NUM_IMAGES * N_DCT * N_DCT],     // Kept in signature, decoupled in logic
    hash_t inter4_hash[NUM_IMAGES],                      // Kept in signature, decoupled in logic
    hash_t target_hash,
    TopKResult out_topk[TOP_K] 
) {
    // We only attach AXI to the data we actually use
#pragma HLS interface m_axi port=input_rgb offset=slave bundle=gmem0 max_read_burst_length=32 num_read_outstanding=32 latency=64 max_widen_bitwidth=1024
#pragma HLS interface m_axi port=out_topk offset=slave bundle=gmem1
#pragma HLS interface s_axilite port=target_hash
#pragma HLS interface s_axilite port=return

    // Enable Canonical Dataflow for assembly-line execution
    #pragma HLS dataflow

    // Internal streams sized effectively for ping-pong buffering
    hls::stream<wide_t> raw_in("raw_in");
    hls::stream<dct_t> s_gray("s_gray");
    hls::stream<dct_t> s_rowdct("s_rowdct");
    hls::stream<dct_t> s_coldct("s_coldct");
    hls::stream<hash_t> s_hash("s_hash");

    #pragma HLS stream variable=raw_in depth=32
    #pragma HLS stream variable=s_gray depth=256
    #pragma HLS stream variable=s_rowdct depth=256
    #pragma HLS stream variable=s_coldct depth=256
    #pragma HLS stream variable=s_hash depth=16

    // Connect the sub-kernels
    read_input((const wide_t*)input_rgb, raw_in);
    kernel1_preprocess(raw_in, s_gray);
    kernel2_rowdct(s_gray, s_rowdct);
    kernel3_coldct(s_rowdct, s_coldct);
    kernel4_hash(s_coldct, s_hash);
    kernel5_ranker(s_hash, target_hash, out_topk);
}