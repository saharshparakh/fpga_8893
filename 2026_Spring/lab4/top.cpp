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
// User requested 1024-bit AXI bus to reduce cycle floor
typedef ap_uint<1024> wide_t;
typedef ap_fixed<12, 2, AP_RND, AP_SAT> dsp_coeff_t;
typedef ap_fixed<12, 6, AP_RND, AP_SAT> internal_dct_t;

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

static void read_input(const pixel_t* in, hls::stream<wide_t>& out_stream) {
    int total_words = (NUM_IMAGES * IMG_W * IMG_H * 3) / 128;
    const wide_t* wide_in = (const wide_t*)in;
    for (int i = 0; i < total_words; i++) {
        #pragma HLS pipeline II=1
        out_stream.write(wide_in[i]);
    }
}

static void kernel1_read_sw(hls::stream<wide_t>& in_stream, pixel_t local_band[768]) {
    for (int w = 0; w < 6; w++) {
        #pragma HLS pipeline II=1
        wide_t word = in_stream.read();
        for (int b = 0; b < 128; b++) {
            #pragma HLS unroll
            local_band[w * 128 + b] = word(b * 8 + 7, b * 8);
        }
    }
}

static void kernel1_compute_sw(pixel_t local_band[768], hls::stream<dct_vec8_t>& out_stream) {
    dct_t w_r = dct_t(0.299 / 255.0);
    dct_t w_g = dct_t(0.587 / 255.0);
    dct_t w_b = dct_t(0.114 / 255.0);
    for (int chunk = 0; chunk < 2; chunk++) {
        #pragma HLS pipeline II=1
        dct_vec8_t out_vec;
        for (int v = 0; v < 8; v++) {
            #pragma HLS unroll
            int c = chunk * 8 + v;
            dct_t sum = 0;
            
            for (int r = 0; r < 4; r++) {
                #pragma HLS unroll
                for (int px = 0; px < 4; px++) {
                    #pragma HLS unroll
                    int pixel_col = c * 4 + px;
                    int idx = r * 192 + pixel_col * 3;
                    
                    dct_t r_val = dct_t(local_band[idx + 0]) * w_r;
                    dct_t g_val = dct_t(local_band[idx + 1]) * w_g;
                    dct_t b_val = dct_t(local_band[idx + 2]) * w_b;
                    sum += (r_val + g_val + b_val);
                }
            }
            out_vec.p[v] = internal_dct_t(sum / dct_t(16));
        }
        out_stream.write(out_vec);
    }
}

static void kernel1_preprocess(hls::stream<wide_t>& in_stream, hls::stream<dct_vec8_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        for (int br_row = 0; br_row < N_DCT; br_row++) { 
            #pragma HLS dataflow
            pixel_t local_band[768];
            #pragma HLS array_partition variable=local_band complete dim=0
            kernel1_read_sw(in_stream, local_band);
            kernel1_compute_sw(local_band, out_stream);
        }
    }
}

static void kernel2_rowdct(hls::stream<dct_vec8_t>& in_stream, hls::stream<dct_vec8_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_gray[N_DCT][N_DCT];
        #pragma HLS array_partition variable=local_gray complete dim=2
        
        for (int i = 0; i < 32; i++) {
            #pragma HLS pipeline II=1
            int r = i >> 1;
            int chunk = i & 1;
            dct_vec8_t in_vec = in_stream.read();
            for (int v = 0; v < 8; v++) {
                #pragma HLS unroll
                local_gray[r][chunk * 8 + v] = in_vec.p[v];
            }
        }
        
        for (int i = 0; i < 32; i++) {
            #pragma HLS pipeline II=1
            int r = i >> 1;
            int chunk = i & 1;
            dct_vec8_t out_vec;
            for (int v = 0; v < 8; v++) {
                #pragma HLS unroll
                int u = chunk * 8 + v;
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

static void kernel3_coldct(hls::stream<dct_vec8_t>& in_stream, hls::stream<dct_vec8_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_rowdct[N_DCT][N_DCT];
        #pragma HLS array_partition variable=local_rowdct complete dim=0
        
        for (int i = 0; i < 32; i++) {
            #pragma HLS pipeline II=1
            int r = i >> 1;
            int chunk = i & 1;
            dct_vec8_t in_vec = in_stream.read();
            for (int v = 0; v < 8; v++) {
                #pragma HLS unroll
                local_rowdct[r][chunk * 8 + v] = in_vec.p[v];
            }
        }
        
        for (int i = 0; i < 32; i++) {
            #pragma HLS pipeline II=1
            int c = i >> 1;     
            int v_blk = i & 1;  
            
            dct_vec8_t out_vec;
            for (int j = 0; j < 8; j++) {
                #pragma HLS unroll
                int v = v_blk * 8 + j;
                dct_t sum_col = 0; 
                for (int r = 0; r < N_DCT; r++) {
                    #pragma HLS unroll
                    sum_col += local_rowdct[r][c] * cos_lut_f[r][v];
                }
                out_vec.p[j] = internal_dct_t(sum_col);
            }
            out_stream.write(out_vec);
        }
    }
}

static void kernel4_hash(hls::stream<dct_vec8_t>& in_stream, hls::stream<hash_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_coldct[N_DCT][N_DCT];
        #pragma HLS array_partition variable=local_coldct complete dim=0
        
        for (int i = 0; i < 32; i++) {
            #pragma HLS pipeline II=1
            int c = i >> 1;
            int v_blk = i & 1;
            dct_vec8_t in_vec = in_stream.read();
            for (int j = 0; j < 8; j++) {
                #pragma HLS unroll
                local_coldct[v_blk * 8 + j][c] = in_vec.p[j];
            }
        }
        
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
                if (local_coldct[r][c] > (hash_sum / dct_t(64))) {
                    hash_val |= ((hash_t)1 << (r * 8 + c));
                }
            }
        }
        out_stream.write(hash_val);
    }
}

static void kernel5_ranker(hls::stream<hash_t>& in_stream, hash_t target_hash, TopKResult out_topk[TOP_K]) {
    TopKResult local_topk[TOP_K];
    #pragma HLS array_partition variable=local_topk complete
    
    for (int i = 0; i < TOP_K; i++) {
        #pragma HLS unroll
        local_topk[i].id = -1;
        local_topk[i].distance = 9999;
    }

    for (int img = 0; img < NUM_IMAGES; img++) {
        #pragma HLS pipeline II=1
        hash_t cur_hash = in_stream.read();
        hash_t diff = cur_hash ^ target_hash;
        
        int current_dist = 0;
        for (int b = 0; b < 64; b++) {
            #pragma HLS unroll
            current_dist += (diff >> b) & 1;
        }
        
        bool is_better[TOP_K];
        #pragma HLS array_partition variable=is_better complete
        
        for (int i = 0; i < TOP_K; i++) {
            #pragma HLS unroll
            is_better[i] = (current_dist < local_topk[i].distance) || 
                           (current_dist == local_topk[i].distance && img < local_topk[i].id);
        }
        
        TopKResult next_topk[TOP_K];
        #pragma HLS array_partition variable=next_topk complete
        
        for (int i = 0; i < TOP_K; i++) {
            #pragma HLS unroll
            if (is_better[i]) {
                if (i == 0 || !is_better[i-1]) {
                    next_topk[i].id = img;
                    next_topk[i].distance = current_dist;
                } else {
                    next_topk[i] = local_topk[i-1];
                }
            } else {
                next_topk[i] = local_topk[i];
            }
        }
        
        for (int i = 0; i < TOP_K; i++) {
            #pragma HLS unroll
            local_topk[i] = next_topk[i];
        }
    }
    
    for (int i = 0; i < TOP_K; i++) {
        #pragma HLS pipeline II=1
        out_topk[i] = local_topk[i];
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
#pragma HLS interface m_axi port=input_rgb offset=slave bundle=gmem0 num_read_outstanding=32 latency=64 max_widen_bitwidth=1024
#pragma HLS interface m_axi port=out_topk offset=slave bundle=gmem1
#pragma HLS interface s_axilite port=target_hash
#pragma HLS interface s_axilite port=return

    #pragma HLS dataflow

    hls::stream<wide_t> raw_in("raw_in");
    hls::stream<dct_vec8_t> s_gray("s_gray");
    hls::stream<dct_vec8_t> s_rowdct("s_rowdct");
    hls::stream<dct_vec8_t> s_coldct("s_coldct");
    hls::stream<hash_t> s_hash("s_hash");

    #pragma HLS stream variable=raw_in depth=128
    #pragma HLS stream variable=s_gray depth=32
    #pragma HLS stream variable=s_rowdct depth=32
    #pragma HLS stream variable=s_coldct depth=32
    #pragma HLS stream variable=s_hash depth=16

    read_input(input_rgb, raw_in);
    kernel1_preprocess(raw_in, s_gray);
    kernel2_rowdct(s_gray, s_rowdct);
    kernel3_coldct(s_rowdct, s_coldct);
    kernel4_hash(s_coldct, s_hash);
    kernel5_ranker(s_hash, target_hash, out_topk);
}
