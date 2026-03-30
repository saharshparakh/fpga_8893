#include "dcl.h"
#include <hls_stream.h>
#include <ap_int.h> // FIXED: Required for HW-synthesizable popcount

#ifndef __SYNTHESIS__
#include <cmath>
#else
#include "hls_math.h"
#endif

// ==========================================
// OPTIMIZED INTERNAL TYPES
// ==========================================
typedef ap_fixed<24, 12, AP_RND, AP_SAT> opt_t;

// ==========================================
// KERNEL 1: Preprocess (RGB to Gray)
// ==========================================
void k1_preprocess(const pixel_t input_rgb[], hls::stream<opt_t> &stream_out) {
    opt_t w_r = opt_t(0.299 / 255.0);
    opt_t w_g = opt_t(0.587 / 255.0);
    opt_t w_b = opt_t(0.114 / 255.0);
    opt_t inv_box = opt_t(1.0 / (BOX_SIZE * BOX_SIZE)); 

    for (int img = 0; img < NUM_IMAGES; img++) {
        int off_in = img * IMG_H * IMG_W * 3;
        
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                opt_t sum = 0;
                
                for (int b = 0; b < BOX_SIZE * BOX_SIZE; b++) {
#pragma HLS pipeline II=1
                    int br = b / BOX_SIZE;
                    int bc = b % BOX_SIZE;
                    int pr = r * BOX_SIZE + br;
                    int pc = c * BOX_SIZE + bc;
                    int idx = off_in + (pr * IMG_W + pc) * 3;
                    
                    sum += (opt_t(input_rgb[idx]) * w_r) + 
                           (opt_t(input_rgb[idx+1]) * w_g) + 
                           (opt_t(input_rgb[idx+2]) * w_b);
                }
                stream_out.write(sum * inv_box); 
            }
        }
    }
}

// ==========================================
// KERNEL 2: Row-DCT
// ==========================================
void k2_row_dct(hls::stream<opt_t> &stream_in, hls::stream<opt_t> &stream_out, const opt_t cos_lut[N_DCT][N_DCT]) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        opt_t local_gray[N_DCT][N_DCT];
#pragma HLS array_partition variable=local_gray complete dim=2 

        for (int i = 0; i < N_DCT * N_DCT; i++) {
#pragma HLS pipeline II=1
            local_gray[i / N_DCT][i % N_DCT] = stream_in.read();
        }

        for (int r = 0; r < N_DCT; r++) {
            for (int u = 0; u < N_DCT; u++) {
#pragma HLS pipeline II=1
                opt_t sum = 0;
                for (int c = 0; c < N_DCT; c++) {
                    sum += local_gray[r][c] * cos_lut[c][u];
                }
                opt_t alpha = (u == 0) ? opt_t(0.70710678) : opt_t(1.0);
                stream_out.write(sum * alpha);
            }
        }
    }
}

// ==========================================
// KERNEL 3: Col-DCT
// ==========================================
void k3_col_dct(hls::stream<opt_t> &stream_in, hls::stream<opt_t> &stream_out, const opt_t cos_lut[N_DCT][N_DCT]) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        opt_t local_row_dct[N_DCT][N_DCT];
#pragma HLS array_partition variable=local_row_dct complete dim=1 

        for (int i = 0; i < N_DCT * N_DCT; i++) {
#pragma HLS pipeline II=1
            local_row_dct[i / N_DCT][i % N_DCT] = stream_in.read();
        }

        for (int v = 0; v < N_DCT; v++) {
            for (int c = 0; c < N_DCT; c++) {
#pragma HLS pipeline II=1
                opt_t sum = 0;
                for (int r = 0; r < N_DCT; r++) {
                    sum += local_row_dct[r][c] * cos_lut[r][v];
                }
                opt_t alpha = (v == 0) ? opt_t(0.70710678) : opt_t(1.0);
                stream_out.write(sum * alpha);
            }
        }
    }
}

// ==========================================
// KERNEL 4: Hash Generation
// ==========================================
void k4_hash(hls::stream<opt_t> &stream_in, hls::stream<hash_t> &stream_out) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        opt_t top_corner[8][8];
#pragma HLS array_partition variable=top_corner complete dim=0 
        opt_t hash_sum = 0;

        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
#pragma HLS pipeline II=1
                opt_t val = stream_in.read();
                if (r < 8 && c < 8) {
                    top_corner[r][c] = val;
                    hash_sum += val;
                }
            }
        }

        opt_t inv_64 = opt_t(0.015625); 
        opt_t mean = hash_sum * inv_64;
        
        hash_t hash_val = 0;
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
#pragma HLS pipeline II=1
                if (top_corner[r][c] > mean) {
                    hash_val |= ((hash_t)1 << (r * 8 + c));
                }
            }
        }
        stream_out.write(hash_val);
    }
}

// ==========================================
// KERNEL 5: Ranker (Systolic Sorter)
// ==========================================
void k5_ranker(hls::stream<hash_t> &stream_in, hash_t target_hash, TopKResult out_topk[TOP_K]) {
    TopKResult local_topk[TOP_K];
#pragma HLS array_partition variable=local_topk complete dim=1

    for (int i = 0; i < TOP_K; i++) {
#pragma HLS unroll
        local_topk[i].id = -1;
        local_topk[i].distance = 9999;
    }

    for (int img = 0; img < NUM_IMAGES; img++) {
#pragma HLS pipeline II=1
        hash_t cur_hash = stream_in.read();
        hash_t diff = cur_hash ^ target_hash;
        
        // FIXED: ap_uint for synthesizable bit counting
        int dist = 0;
        for(int b = 0; b < 64; b++) {
#pragma HLS unroll
            if((diff >> b) & 1) dist++;
        }
        
        // FIXED: Tie-breaker logic mirroring the software model
        bool is_better_last = (dist < local_topk[TOP_K-1].distance) || 
                              (dist == local_topk[TOP_K-1].distance && img < local_topk[TOP_K-1].id);

        if (is_better_last) {
            int insert_idx = TOP_K - 1;
            
            for (int i = TOP_K - 2; i >= 0; i--) {
                bool is_better_i = (dist < local_topk[i].distance) || 
                                   (dist == local_topk[i].distance && img < local_topk[i].id);
                if (is_better_i) insert_idx = i;
            }
            
            for (int i = TOP_K - 1; i > 0; i--) {
                if (i > insert_idx) local_topk[i] = local_topk[i-1];
            }
            local_topk[insert_idx].id = img;
            local_topk[insert_idx].distance = dist;
        }
    }

    for (int i = 0; i < TOP_K; i++) {
#pragma HLS pipeline II=1
        out_topk[i] = local_topk[i];
    }
}

// ==========================================
// TOP LEVEL WRAPPER (The Interface)
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
#pragma HLS interface m_axi port=input_rgb offset=slave bundle=gmem0
#pragma HLS interface m_axi port=inter1_gray offset=slave bundle=gmem_unused
#pragma HLS interface m_axi port=inter2_rowdct offset=slave bundle=gmem_unused
#pragma HLS interface m_axi port=inter3_coldct offset=slave bundle=gmem_unused
#pragma HLS interface m_axi port=inter4_hash offset=slave bundle=gmem_unused
#pragma HLS interface m_axi port=out_topk offset=slave bundle=gmem1
#pragma HLS interface s_axilite port=target_hash
#pragma HLS interface s_axilite port=return

    opt_t cos_lut[N_DCT][N_DCT];
#pragma HLS array_partition variable=cos_lut complete dim=0
    for (int c = 0; c < N_DCT; c++) {
        for (int u = 0; u < N_DCT; u++) {
            cos_lut[c][u] = opt_t(std::cos(3.14159265358979323846 * (2.0 * c + 1.0) * u / (2.0 * N_DCT)));
        }
    }

#pragma HLS dataflow

    hls::stream<opt_t> stream_k1_to_k2("s1");
    hls::stream<opt_t> stream_k2_to_k3("s2");
    hls::stream<opt_t> stream_k3_to_k4("s3");
    hls::stream<hash_t> stream_k4_to_k5("s4");

    k1_preprocess(input_rgb, stream_k1_to_k2);
    k2_row_dct(stream_k1_to_k2, stream_k2_to_k3, cos_lut);
    k3_col_dct(stream_k2_to_k3, stream_k3_to_k4, cos_lut);
    k4_hash(stream_k3_to_k4, stream_k4_to_k5);
    k5_ranker(stream_k4_to_k5, target_hash, out_topk);
}