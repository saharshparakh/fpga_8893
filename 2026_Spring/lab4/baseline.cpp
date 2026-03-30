#include "dcl.h"

#ifndef __SYNTHESIS__
#include <cmath>
#else
#include "hls_math.h"
#endif

// The top-level synthesizable function containing all fully sequential code
void top_kernel(
    const pixel_t input_rgb[NUM_IMAGES * IMG_W * IMG_H * 3],
    dct_t inter1_gray[NUM_IMAGES * N_DCT * N_DCT],
    dct_t inter2_rowdct[NUM_IMAGES * N_DCT * N_DCT],
    dct_t inter3_coldct[NUM_IMAGES * N_DCT * N_DCT],
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
        int off_in = img * IMG_H * IMG_W * 3;
        int off_n = img * N_DCT * N_DCT;
        
        // ==========================================
        // KERNEL 1: Preprocess (RGB to Grayscale)
        // ==========================================
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                dct_t sum = 0;
                
                for (int br = 0; br < BOX_SIZE; br++) {
                    for (int bc = 0; bc < BOX_SIZE; bc++) {
                        int pr = r * BOX_SIZE + br;
                        int pc = c * BOX_SIZE + bc;
                        int row_idx = pr * IMG_W;
                        int flat_idx = row_idx + pc;
                        int rgb_base = off_in + flat_idx * 3;
                        
                        pixel_t r_pix = input_rgb[rgb_base + 0];
                        pixel_t g_pix = input_rgb[rgb_base + 1];
                        pixel_t b_pix = input_rgb[rgb_base + 2];
                        
                        dct_t r_fp = (dct_t)r_pix;
                        dct_t g_fp = (dct_t)g_pix;
                        dct_t b_fp = (dct_t)b_pix;
                        
                        // Normalization weights to bound signal [0.0, 1.0]
                        dct_t w_r = dct_t(0.299 / 255.0);
                        dct_t w_g = dct_t(0.587 / 255.0);
                        dct_t w_b = dct_t(0.114 / 255.0);
                        
                        dct_t r_val = r_fp * w_r;
                        dct_t g_val = g_fp * w_g;
                        dct_t b_val = b_fp * w_b;
                        
                        dct_t gray_val = r_val + g_val + b_val;
                        sum += gray_val;
                    }
                }
                
                dct_t box_area = dct_t(BOX_SIZE * BOX_SIZE);
                dct_t avg = sum / box_area; 
                
                int out_row = r * N_DCT;
                int out_idx_local = out_row + c;
                int out_idx_global = off_n + out_idx_local;
                
                inter1_gray[out_idx_global] = avg;
            }
        }
        
        // ==========================================
        // KERNEL 2: Row-DCT (De-optimized dynamic Cosine)
        // ==========================================
        for (int r = 0; r < N_DCT; r++) {
            int in_row_offset = r * N_DCT;
            int out_row_offset = r * N_DCT;
            
            for (int u = 0; u < N_DCT; u++) {
                dct_t sum = 0;
                
                for (int c = 0; c < N_DCT; c++) {
                    int in_idx_local = in_row_offset + c;
                    int in_idx_global = off_n + in_idx_local;
                    
                    dct_t pixel_val = inter1_gray[in_idx_global];
                    
                    float math_val = 3.14159265358979323846 * (2.0 * c + 1.0) * u / (2.0 * N_DCT);
#ifndef __SYNTHESIS__
                    dct_t cos_val = dct_t(std::cos(math_val));
#else
                    dct_t cos_val = dct_t(hls::cos(math_val));
#endif
                    dct_t mult_product = pixel_val * cos_val;
                    sum += mult_product;
                }
                
                bool is_dc = (u == 0);
                dct_t alpha = is_dc ? dct_t(0.70710678) : dct_t(1.0);
                dct_t scaled_result = sum * alpha;
                
                int out_idx_local = out_row_offset + u;
                int out_idx_global = off_n + out_idx_local;
                inter2_rowdct[out_idx_global] = scaled_result;
            }
        }

        // ==========================================
        // KERNEL 3: Col-DCT (De-optimized dynamic Cosine)
        // ==========================================
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                dct_t sum_col = 0;
                
                for (int r = 0; r < N_DCT; r++) {
                    int in_row_offset = r * N_DCT;
                    int in_idx_local = in_row_offset + c;
                    int in_idx_global = off_n + in_idx_local;
                    
                    dct_t pixel_val = inter2_rowdct[in_idx_global];
                    
                    float math_val = 3.14159265358979323846 * (2.0 * r + 1.0) * v / (2.0 * N_DCT);
#ifndef __SYNTHESIS__
                    dct_t cos_val = dct_t(std::cos(math_val));
#else
                    dct_t cos_val = dct_t(hls::cos(math_val));
#endif
                    dct_t mult_product = pixel_val * cos_val;
                    sum_col += mult_product;
                }
                
                bool is_dc_col = (v == 0);
                dct_t alpha_col = is_dc_col ? dct_t(0.70710678) : dct_t(1.0);
                dct_t final_col_val = sum_col * alpha_col;
                
                int out_row_offset = v * N_DCT;
                int out_idx_local = out_row_offset + c;
                int out_idx_global = off_n + out_idx_local;
                
                inter3_coldct[out_idx_global] = final_col_val;
            }
        }

        // ==========================================
        // KERNEL 4: Hash (Mean + Binary Footprint)
        // ==========================================
        dct_t hash_sum = 0;
        dct_t hash_count = 0;
        
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                int row_offset = r * N_DCT;
                int idx_local = row_offset + c;
                int idx_global = off_n + idx_local;
                
                dct_t val = inter3_coldct[idx_global];
                hash_sum += val;
                
                dct_t increment = dct_t(1.0);
                hash_count += increment; 
            }
        }
        
        dct_t mean_val = hash_sum / hash_count; 
        
        hash_t hash_val = 0;
        int bit_pos = 0;
        
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                int row_offset = r * N_DCT;
                int idx_local = row_offset + c;
                int idx_global = off_n + idx_local;
                
                dct_t val = inter3_coldct[idx_global];
                bool is_greater = (val > mean_val);
                
                if (is_greater) {
                    hash_t bit_mask = ((hash_t)1 << bit_pos);
                    hash_val = hash_val | bit_mask;
                }
                
                int next_bit = bit_pos + 1;
                bit_pos = next_bit;
            }
        }
        
        inter4_hash[img] = hash_val;

        // ==========================================
        // KERNEL 5: Ranker (Naive CS101 Sort)
        // ==========================================
        hash_t cur_hash = inter4_hash[img];
        hash_t target = target_hash;
        
        int dist = 0;
        int max_bits = 64;
        
        // Naive modulo bit extraction (Extremely slow in hardware)
        for (int b = 0; b < max_bits; b++) {
            int bit_cur = (int)(cur_hash % 2);
            int bit_tgt = (int)(target % 2);
            
            if (bit_cur != bit_tgt) {
                dist = dist + 1;
            }
            
            cur_hash = cur_hash / 2;
            target = target / 2;
        }
        
        int current_dist = dist;
        int last_idx = TOP_K - 1;
        int max_topk_dist = out_topk[last_idx].distance;
        
        bool requires_insert = (current_dist < max_topk_dist);
        
        if (requires_insert) {
            int insert_idx = last_idx;
            
            while (insert_idx > 0) {
                int prev_idx = insert_idx - 1;
                int prev_dist = out_topk[prev_idx].distance;
                
                if (current_dist < prev_dist) {
                    insert_idx = prev_idx;
                } else {
                    break;
                }
            }
            
            for (int s = last_idx; s > 0; s--) {
                bool should_shift = (s > insert_idx);
                if (should_shift) {
                    int src_idx = s - 1;
                    TopKResult temp = out_topk[src_idx];
                    out_topk[s] = temp;
                }
            }
            
            TopKResult new_entry;
            new_entry.id = img;
            new_entry.distance = current_dist;
            
            out_topk[insert_idx] = new_entry;
        }
    }
}