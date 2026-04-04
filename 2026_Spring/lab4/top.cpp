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

// 18-bit precision type to force 1 DSP slice per multiplier
typedef ap_fixed<18, 2, AP_RND, AP_SAT> dsp_coeff_t;

// 18-bit internal pipeline type (8 integer bits, 10 fractional bits)
typedef ap_fixed<18, 8, AP_RND, AP_SAT> internal_dct_t;

// ==========================================
// TIGHT MATH: Pre-computed Cosine LUT
// NOTE: Column 0 (u=0 / v=0) is pre-scaled by alpha (0.707107)
// ==========================================
const float cos_lut_f[16][16] = {
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

static void kernel1_preprocess(hls::stream<wide_t>& in_stream, hls::stream<internal_dct_t>& out_stream) {
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
                out_stream.write(internal_dct_t(sum / box_area)); 
            }
        }
    }
}

static void kernel2_rowdct(hls::stream<internal_dct_t>& in_stream, hls::stream<internal_dct_t>& out_stream) {
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#ifndef __SYNTHESIS__ // TESTING CODE, PLEASE REMOVE!!!!!
    static float max_hw_row = 0.0f; // TESTING CODE, PLEASE REMOVE!!!!!
#endif // TESTING CODE, PLEASE REMOVE!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    for (int img = 0; img < NUM_IMAGES; img++) {
        // Buffer the 16x16 frame locally
        internal_dct_t local_gray[N_DCT][N_DCT];
        
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                local_gray[r][c] = in_stream.read();
            }
        }
        
        for (int r = 0; r < N_DCT; r++) {
            for (int u = 0; u < N_DCT; u++) {
                dct_t sum = 0; // 24-bit accumulator
                for (int c = 0; c < N_DCT; c++) {
                    // TIGHT MATH: Pre-scaled LUT handles the alpha constant natively
                    sum += local_gray[r][c] * dsp_coeff_t(cos_lut_f[c][u]);
                }
                
                // Truncate from 24-bit to 18-bit internal type on write.
                out_stream.write(internal_dct_t(sum));

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#ifndef __SYNTHESIS__ // TESTING CODE, PLEASE REMOVE!!!!!
                float val = std::abs((float)sum); // TESTING CODE, PLEASE REMOVE!!!!!
                if (val > max_hw_row) max_hw_row = val; // TESTING CODE, PLEASE REMOVE!!!!!
                if (img == NUM_IMAGES - 1 && r == N_DCT - 1 && u == N_DCT - 1) // TESTING CODE, PLEASE REMOVE!!!!!
                    std::cout << ">> [HW SIM] Max Row Value: " << max_hw_row << std::endl; // TESTING CODE, PLEASE REMOVE!!!!!
#endif // TESTING CODE, PLEASE REMOVE!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            }
        }
    }
}

static void kernel3_coldct(hls::stream<internal_dct_t>& in_stream, hls::stream<internal_dct_t>& out_stream) {
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#ifndef __SYNTHESIS__ // TESTING CODE, PLEASE REMOVE!!!!!
    static float max_hw_col = 0.0f; // TESTING CODE, PLEASE REMOVE!!!!!
#endif // TESTING CODE, PLEASE REMOVE!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_rowdct[N_DCT][N_DCT];
        
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                local_rowdct[r][c] = in_stream.read();
            }
        }
        
        // Perform Col-DCT math 
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                dct_t sum_col = 0; // 24-bit accumulator
                for (int r = 0; r < N_DCT; r++) {
                    // TIGHT MATH: Pre-scaled LUT handles the alpha constant natively
                    sum_col += local_rowdct[r][c] * dsp_coeff_t(cos_lut_f[r][v]);
                }
                
                // Truncate from 24-bit to 18-bit internal type on write.
                out_stream.write(internal_dct_t(sum_col));

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#ifndef __SYNTHESIS__ // TESTING CODE, PLEASE REMOVE!!!!!
                float val_c = std::abs((float)sum_col); // TESTING CODE, PLEASE REMOVE!!!!!
                if (val_c > max_hw_col) max_hw_col = val_c; // TESTING CODE, PLEASE REMOVE!!!!!
                if (img == NUM_IMAGES - 1 && c == N_DCT - 1 && v == N_DCT - 1) // TESTING CODE, PLEASE REMOVE!!!!!
                    std::cout << ">> [HW SIM] Max Col Value: " << max_hw_col << std::endl; // TESTING CODE, PLEASE REMOVE!!!!!
#endif // TESTING CODE, PLEASE REMOVE!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            }
        }
    }
}

static void kernel4_hash(hls::stream<internal_dct_t>& in_stream, hls::stream<hash_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_coldct[N_DCT][N_DCT];
        
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
        
        // TIGHT MATH: Bitwise XOR finds all differences. 
        hash_t diff = cur_hash ^ target_hash;
        int current_dist = 0;

        // TIGHT MATH: Kernighan's Algorithm for PopCount.
        // Loops only as many times as there are differences, skipping all matching bits.
        while (diff > 0) {
            diff = diff & (diff - 1);
            current_dist++;
        }
        
        // Ranking Logic
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
    // We only attach AXI to the data we actually use
#pragma HLS interface m_axi port=input_rgb offset=slave bundle=gmem0 max_read_burst_length=32 num_read_outstanding=32 latency=64 max_widen_bitwidth=1024
#pragma HLS interface m_axi port=out_topk offset=slave bundle=gmem1
#pragma HLS interface s_axilite port=target_hash
#pragma HLS interface s_axilite port=return

    // Enable Canonical Dataflow for assembly-line execution
    #pragma HLS dataflow

    // Internal streams sized effectively for ping-pong buffering
    hls::stream<wide_t> raw_in("raw_in");
    hls::stream<internal_dct_t> s_gray("s_gray");
    hls::stream<internal_dct_t> s_rowdct("s_rowdct");
    hls::stream<internal_dct_t> s_coldct("s_coldct");
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