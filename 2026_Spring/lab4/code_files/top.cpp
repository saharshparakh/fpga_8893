#include "dcl.h"
#include <ap_int.h>

#ifndef __SYNTHESIS__
#include <cmath>
#else
#include "hls_math.h"
#endif

// The top-level synthesizable function containing all fully sequential code
void top_kernel(
    const pixel_t input_rgb[NUM_IMAGES * IMG_W * IMG_H * 3],
    dct_t inter1_gray[NUM_IMAGES * N_DCT * N_DCT],       // FIXED: Matched to dcl.h
    dct_t inter2_rowdct[NUM_IMAGES * N_DCT * N_DCT],     // FIXED: Matched to dcl.h
    dct_t inter3_coldct[NUM_IMAGES * N_DCT * N_DCT],     // FIXED: Matched to dcl.h
    hash_t inter4_hash[NUM_IMAGES],
    hash_t target_hash,
    TopKResult out_topk[TOP_K] 
) {
#pragma HLS interface m_axi port=input_rgb offset=slave bundle=gmem
#pragma HLS interface m_axi port=inter1_gray offset=slave bundle=gmem
#pragma HLS interface m_axi port=inter2_rowdct offset=slave bundle=gmem
#pragma HLS interface m_axi port=inter3_coldct offset=slave bundle=gmem
#pragma HLS interface m_axi port=inter4_hash offset=slave bundle=gmem
#pragma HLS interface m_axi port=out_topk offset=slave bundle=gmem
#pragma HLS interface s_axilite port=target_hash
#pragma HLS interface s_axilite port=return

    // Initialize the TopK output
    for (int i = 0; i < TOP_K; i++) {
        out_topk[i].id = -1;
        out_topk[i].distance = 9999;
    }

    // Process all images sequentially within a single method
    for (int img = 0; img < NUM_IMAGES; img++) {
        
        // ==========================================
        // KERNEL 1: Preprocess (RGB to Grayscale)
        // ==========================================
        // Recalculating weights inside the loop forces redundant memory loads
        dct_t w_r = dct_t(0.299 / 255.0);
        dct_t w_g = dct_t(0.587 / 255.0);
        dct_t w_b = dct_t(0.114 / 255.0);

        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                dct_t sum = 0;
                
                for (int br = 0; br < BOX_SIZE; br++) {
                    for (int bc = 0; bc < BOX_SIZE; bc++) {
                        // Recomputing complex indices in the innermost loop
                        int idx = (img * IMG_H * IMG_W * 3) + 
                                  ((r * BOX_SIZE + br) * IMG_W + (c * BOX_SIZE + bc)) * 3;
                        
                        dct_t r_val = dct_t(input_rgb[idx + 0]) * w_r;
                        dct_t g_val = dct_t(input_rgb[idx + 1]) * w_g;
                        dct_t b_val = dct_t(input_rgb[idx + 2]) * w_b;
                        
                        sum += (r_val + g_val + b_val);
                    }
                }
                
                // Using hardware division instead of multiplying by an inverse fraction
                dct_t box_area = dct_t(BOX_SIZE * BOX_SIZE);
                int out_idx = (img * N_DCT * N_DCT) + (r * N_DCT + c);
                inter1_gray[out_idx] = sum / box_area; 
            }
        }
        
        // ==========================================
        // KERNEL 2: Row-DCT 
        // ==========================================
        for (int r = 0; r < N_DCT; r++) {
            for (int u = 0; u < N_DCT; u++) {
                dct_t sum = 0;
                
                for (int c = 0; c < N_DCT; c++) {
                    int in_idx = (img * N_DCT * N_DCT) + (r * N_DCT + c);
                    dct_t pixel_val = inter1_gray[in_idx];
                    
                    // LEGALLY SLOW: Compute Trigonometry dynamically on the fly
                    float math_val = 3.14159265358979323846 * (2.0 * c + 1.0) * u / (2.0 * N_DCT);
#ifndef __SYNTHESIS__
                    dct_t dynamic_cos = dct_t(std::cos(math_val));
#else
                    dct_t dynamic_cos = dct_t(hls::cos(math_val));
#endif
                    sum += pixel_val * dynamic_cos;
                }
                
                dct_t alpha = (u == 0) ? dct_t(0.70710678) : dct_t(1.0);
                int out_idx = (img * N_DCT * N_DCT) + (r * N_DCT + u);
                inter2_rowdct[out_idx] = sum * alpha;
            }
        }

        // ==========================================
        // KERNEL 3: Col-DCT
        // ==========================================
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                dct_t sum_col = 0;
                
                for (int r = 0; r < N_DCT; r++) {
                    int in_idx = (img * N_DCT * N_DCT) + (r * N_DCT + c);
                    dct_t pixel_val = inter2_rowdct[in_idx];
                    
                    // LEGALLY SLOW: Compute Trigonometry dynamically on the fly
                    float math_val = 3.14159265358979323846 * (2.0 * r + 1.0) * v / (2.0 * N_DCT);
#ifndef __SYNTHESIS__
                    dct_t dynamic_cos = dct_t(std::cos(math_val));
#else
                    dct_t dynamic_cos = dct_t(hls::cos(math_val));
#endif
                    sum_col += pixel_val * dynamic_cos;
                }
                
                dct_t alpha_col = (v == 0) ? dct_t(0.70710678) : dct_t(1.0);
                int out_idx = (img * N_DCT * N_DCT) + (v * N_DCT + c);
                inter3_coldct[out_idx] = sum_col * alpha_col;
            }
        }

        // ==========================================
        // KERNEL 4: Hash Generation
        // ==========================================
        dct_t hash_sum = 0;
        
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                int idx = (img * N_DCT * N_DCT) + (r * N_DCT + c);
                hash_sum += inter3_coldct[idx];
            }
        }
        
        hash_t hash_val = 0;
        int bit_pos = 0;
        
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                int idx = (img * N_DCT * N_DCT) + (r * N_DCT + c);
                dct_t val = inter3_coldct[idx];
                
                // Matched cross-multiplication logic to guarantee 0% error vs optimized
                if (val * dct_t(64.0) > hash_sum) {
                    hash_val |= ((hash_t)1 << bit_pos);
                }
                bit_pos++;
            }
        }
        
        inter4_hash[img] = hash_val;

        // ==========================================
        // KERNEL 5: Ranker 
        // ==========================================
        hash_t cur_hash = inter4_hash[img];
        hash_t tgt_hash = target_hash;
        
        // LEGALLY SLOW: Sequential Modulo and Division bit counter
        int current_dist = 0;
        for (int b = 0; b < 64; b++) {
            // FPGAs hate large integer modulo logic
            if ((cur_hash % 2) != (tgt_hash % 2)) {
                current_dist++;
            }
            cur_hash = cur_hash / 2;
            tgt_hash = tgt_hash / 2;
        }
        
        int last_idx = TOP_K - 1;
        
        // Exact matching Tie-Breaker
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