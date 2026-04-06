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
typedef ap_fixed<12, 2, AP_RND, AP_SAT> dsp_coeff_t;

// 18-bit internal pipeline type (8 integer bits, 10 fractional bits)
typedef ap_fixed<12, 6, AP_RND, AP_SAT> internal_dct_t;

// ==========================================
// TIGHT MATH: Pre-computed Cosine LUT
// NOTE: Column 0 (u=0 / v=0) is pre-scaled by alpha (0.707107)
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
 * Theory: Downsample to a 16x16 grid by averaging 4x4 bounding boxes and converting RGB to grayscale.
 */
static void kernel1_preprocess(hls::stream<wide_t>& in_stream, hls::stream<internal_dct_t>& out_stream) {
    dct_t w_r = dct_t(0.299 / 255.0);
    dct_t w_g = dct_t(0.587 / 255.0);
    dct_t w_b = dct_t(0.114 / 255.0);
    
    for (int img = 0; img < NUM_IMAGES; img++) {
        pixel_t local_img[IMG_H * IMG_W * 3];
        
        // [ARCHITECTURE] Cyclic Array Partitioning
        // We must calculate a 4x4 box (16 pixels * 3 channels = 48 values) in 1 clock cycle.
        // A standard BRAM has 2 ports. By partitioning cyclically by 48, HLS creates 48 
        // parallel BRAM banks, guaranteeing 48 separate physical read ports.
        #pragma HLS bind_storage variable=local_img type=RAM_1P impl=BRAM
        #pragma HLS array_partition variable=local_img cyclic factor=48 dim=1
        
        // Unpack 1024-bit words into BRAM.
        for (int w = 0; w < (IMG_H * IMG_W * 3) / 128; w++) {
            #pragma HLS pipeline II=1
            wide_t word = in_stream.read();
            for (int p = 0; p < 128; p++) {
                int p8 = 8 * p;
                local_img[w * 128 + p] = word(p8 + 7, p8);
            }
        }
        
        // [ALGORITHM] 4x4 Spatial Downsampling & Grayscale
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                // [ARCHITECTURE] Pipelined Compute
                // Pipelining the outer loop with II=1 forces the compiler to unroll 
                // the inner 'br' and 'bc' loops completely. This builds exactly 48 multipliers
                // and an adder tree to process a full 4x4 box every single clock cycle.
                #pragma HLS pipeline II=1
                
                dct_t sum = 0; 
                int base_row = r * BOX_SIZE;
                int base_col = c * BOX_SIZE;                
                
                for (int br = 0; br < BOX_SIZE; br++) {
                    #pragma HLS unroll
                    int row_offset = (base_row + br) * IMG_W;
                    int base_idx = (row_offset + base_col) * 3;

                    for (int bc = 0; bc < BOX_SIZE; bc++) {
                        #pragma HLS unroll
                        int idx = base_idx + (bc * 3);
                        
                        // Because of cyclic partitioning, these 48 reads happen simultaneously.
                        dct_t r_val = dct_t(local_img[idx + 0]) * w_r;
                        dct_t g_val = dct_t(local_img[idx + 1]) * w_g;
                        dct_t b_val = dct_t(local_img[idx + 2]) * w_b;
                        sum += (r_val + g_val + b_val);
                    }
                }
                out_stream.write(internal_dct_t(sum >> 4));
            }
        }
    }
}

/*
 * Kernel 2: 1D Discrete Cosine Transform (Rows)
 * Theory: The 2D-DCT is mathematically separable. We apply the 1D-DCT across the rows.
 */
static void kernel2_rowdct(hls::stream<internal_dct_t>& in_stream, hls::stream<internal_dct_t>& out_stream) {
#ifndef __SYNTHESIS__
    static float max_hw_row = 0.0f; 
#endif 

    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_gray[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Complete Array Partitioning (Columns)
        // To compute 1 frequency bin per cycle, we need all 16 pixels from a row simultaneously.
        // We completely partition the 2nd dimension (columns) into 16 independent registers.
        #pragma HLS array_partition variable=local_gray complete dim=2
        
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                #pragma HLS pipeline II=1
                local_gray[r][c] = in_stream.read();
            }
        }
        
        // [MATH] 1D Row DCT Matrix Multiplication
        for (int r = 0; r < N_DCT; r++) {
            for (int u = 0; u < N_DCT; u++) {
                // [ARCHITECTURE] Pipelined DSP Compute Engine
                // By pipelining 'u', we force the 'c' loop to unroll, instantiating 16 DSP 
                // slices to perform a full row inner-product in 1 clock cycle.
                #pragma HLS pipeline II=1
                dct_t sum = 0; 
                
                for (int c = 0; c < N_DCT; c++) {
                    #pragma HLS unroll
                    sum += local_gray[r][c] * cos_lut_f[c][u];
                }
                out_stream.write(internal_dct_t(sum));

#ifndef __SYNTHESIS__ 
                float val = std::abs((float)sum); 
                if (val > max_hw_row) max_hw_row = val; 
                if (img == NUM_IMAGES - 1 && r == N_DCT - 1 && u == N_DCT - 1) 
                    std::cout << ">> [HW SIM] Max Row Value: " << max_hw_row << std::endl; 
#endif 
            }
        }
    }
}

/*
 * Kernel 3: 1D Discrete Cosine Transform (Columns)
 * Theory: Completes the 2D-DCT down the rows of each column. 
 */
static void kernel3_coldct(hls::stream<internal_dct_t>& in_stream, hls::stream<internal_dct_t>& out_stream) {
#ifndef __SYNTHESIS__
    static float max_hw_col = 0.0f; 
#endif 

    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_rowdct[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Complete Array Partitioning (Rows)
        // To compute down a column in 1 cycle, we need all 16 rows simultaneously.
        // We completely partition the 1st dimension (rows) into 16 independent registers.
        #pragma HLS array_partition variable=local_rowdct complete dim=1
        
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                #pragma HLS pipeline II=1
                local_rowdct[r][c] = in_stream.read();
            }
        }
        
        // [MATH] 1D Column DCT Matrix Multiplication
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                // [ARCHITECTURE] Pipelined DSP Compute Engine
                // Instantiates 16 DSP slices to multiply a column by the cosine basis in 1 cycle.
                #pragma HLS pipeline II=1
                dct_t sum_col = 0; 
                
                for (int r = 0; r < N_DCT; r++) {
                    #pragma HLS unroll
                    sum_col += local_rowdct[r][c] * cos_lut_f[r][v];
                }
                out_stream.write(internal_dct_t(sum_col));

#ifndef __SYNTHESIS__
                float val_c = std::abs((float)sum_col); 
                if (val_c > max_hw_col) max_hw_col = val_c;
                if (img == NUM_IMAGES - 1 && c == N_DCT - 1 && v == N_DCT - 1) 
                    std::cout << ">> [HW SIM] Max Col Value: " << max_hw_col << std::endl; 
#endif 
            }
        }
    }
}

/*
 * Kernel 4: Frequency Thresholding & Fingerprint Hash
 * Theory: Extracts top-left 8x8 matrix, averages bins, thresholds to build 64-bit fingerprint.
 */
static void kernel4_hash(hls::stream<internal_dct_t>& in_stream, hls::stream<hash_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_coldct[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Complete Array Partitioning (Columns)
        // Required so we can unroll the column accumulation in the next steps.
        #pragma HLS array_partition variable=local_coldct complete dim=2
        
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                #pragma HLS pipeline II=1
                local_coldct[v][c] = in_stream.read();
            }
        }
        
        // [ALGORITHM] Low-Frequency DC/AC Averaging
        dct_t hash_sum = 0;
        for (int r = 0; r < 8; r++) {
            // [ARCHITECTURE] Pipelined Accumulation
            // Takes 8 clock cycles to sum 64 items by unrolling the column reads.
            #pragma HLS pipeline II=1
            for (int c = 0; c < 8; c++) {
                #pragma HLS unroll
                hash_sum += local_coldct[r][c];
            }
        }
        
        // [MATH] Thresholding and Fingerprint Construction
        hash_t hash_val = 0;
        int bit_pos = 0;
        for (int r = 0; r < 8; r++) {
            // [ARCHITECTURE] Pipelined Thresholding
            // Evaluates 8 comparisons per clock cycle. Completes fingerprint in 8 cycles.
            #pragma HLS pipeline II=1
            for (int c = 0; c < 8; c++) {
                #pragma HLS unroll
                if (local_coldct[r][c] > (hash_sum >> 6)) {
                    hash_val |= ((hash_t)1 << bit_pos);
                }
                bit_pos++;
            }
        }
        out_stream.write(hash_val);
    }
}

/*
 * Kernel 5: Distance Ranking & Top-K Sorter
 * Theory: Computes the Hamming distance and maintains a sorted array of the closest matches.
 */
static void kernel5_ranker(hls::stream<hash_t>& in_stream, hash_t target_hash, TopKResult out_topk[TOP_K]) {
    for (int i = 0; i < TOP_K; i++) {
        #pragma HLS unroll
        out_topk[i].id = -1;
        out_topk[i].distance = 9999;
    }

    // Because this loop relies on highly variable data-dependent logic (Kernighan's while loop) 
    // we intentionally do NOT apply II=1 pipelining here to avoid DRC failures. 
    // The algorithmic math optimizations already reduced the latency of this kernel below the upstream bottlenecks.
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
    hls::stream<internal_dct_t> s_gray("s_gray");
    hls::stream<internal_dct_t> s_rowdct("s_rowdct");
    hls::stream<internal_dct_t> s_coldct("s_coldct");
    hls::stream<hash_t> s_hash("s_hash");

    #pragma HLS stream variable=raw_in depth=32
    #pragma HLS stream variable=s_gray depth=256
    #pragma HLS stream variable=s_rowdct depth=256
    #pragma HLS stream variable=s_coldct depth=256
    #pragma HLS stream variable=s_hash depth=16

    read_input((const wide_t*)input_rgb, raw_in);
    kernel1_preprocess(raw_in, s_gray);
    kernel2_rowdct(s_gray, s_rowdct);
    kernel3_coldct(s_rowdct, s_coldct);
    kernel4_hash(s_coldct, s_hash);
    kernel5_ranker(s_hash, target_hash, out_topk);
}