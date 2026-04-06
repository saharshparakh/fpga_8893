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
 * By streaming 1024-bit ultra-wide words, we saturate the DDR memory bandwidth.
 */
static void read_input(const wide_t* in, hls::stream<wide_t>& out_stream) {
    int total_words = (NUM_IMAGES * IMG_W * IMG_H * 3) / 128;
    
    // [ARCHITECTURE] AXI Burst Reader
    // This loop consumes AXI data continuously, generating a clean internal 
    // FIFO stream so downstream kernels aren't blocked by memory latency.
    for (int i = 0; i < total_words; i++) {
        #pragma HLS pipeline II=1
        out_stream.write(in[i]);
    }
}

/*
 * Kernel 1: Grayscale Conversion & Spatial Downsampling
 * Theory: High-frequency spatial data is not robust for perceptual hashing. 
 * We downsample the image into a 16x16 grid by averaging 4x4 bounding boxes 
 * and convert RGB to grayscale (Y = 0.299R + 0.587G + 0.114B).
 */
static void kernel1_preprocess(hls::stream<wide_t>& in_stream, hls::stream<internal_dct_t>& out_stream) {
    dct_t w_r = dct_t(0.299 / 255.0);
    dct_t w_g = dct_t(0.587 / 255.0);
    dct_t w_b = dct_t(0.114 / 255.0);
    
    for (int img = 0; img < NUM_IMAGES; img++) {
        pixel_t local_img[IMG_H * IMG_W * 3];
        #pragma HLS bind_storage variable=local_img type=RAM_1P impl=BRAM
        
        // [ARCHITECTURE] Wide-Stream Unpacker
        // 1024-bit words arrive from DDR. This loop slices the wide word 
        // into 128 individual 8-bit pixels and stores them in local BRAM.
        for (int w = 0; w < (IMG_H * IMG_W * 3) / 128; w++) {
            #pragma HLS pipeline II=1
            wide_t word = in_stream.read();
            for (int p = 0; p < 128; p++) {
                int p8 = 8 * p;
                local_img[w * 128 + p] = word(p8 + 7, p8);
            }
        }
        
        // [ALGORITHM] 4x4 Spatial Downsampling & Grayscale
        // Iterates over the 16x16 target grid, mapping each grid point to a 4x4 
        // block in the original image to compute the spatial average.
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                dct_t sum = 0; 
                
                // [MATH] Index Hoisting
                // Pre-calculates static base offsets outside the deepest loops 
                // to eliminate redundant multiplications in hardware.
                int base_row = r * BOX_SIZE;
                int base_col = c * BOX_SIZE;                
                
                for (int br = 0; br < BOX_SIZE; br++) {
                    int row_offset = (base_row + br) * IMG_W;
                    int base_idx = (row_offset + base_col) * 3;

                    for (int bc = 0; bc < BOX_SIZE; bc++) {
                        int idx = base_idx + (bc * 3);
                        
                        dct_t r_val = dct_t(local_img[idx + 0]) * w_r;
                        dct_t g_val = dct_t(local_img[idx + 1]) * w_g;
                        dct_t b_val = dct_t(local_img[idx + 2]) * w_b;
                        sum += (r_val + g_val + b_val);
                    }
                }
                
                // [MATH] Zero-Cost Hardware Division
                // We must divide the sum by 16 (the 4x4 box area) to find the average.
                // Shifting right by 4 (>> 4) accomplishes this with 0 logic gates.
                out_stream.write(internal_dct_t(sum >> 4));
            }
        }
    }
}

/*
 * Kernel 2: 1D Discrete Cosine Transform (Rows)
 * Theory: The 2D-DCT is mathematically separable. We first apply the 1D-DCT 
 * across the columns of each row.
 */
static void kernel2_rowdct(hls::stream<internal_dct_t>& in_stream, hls::stream<internal_dct_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_gray[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Local Data Caching
        // Reads the 16x16 downsampled grayscale image from the stream into BRAM
        // to allow for multi-pass data access required by matrix multiplication.
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                local_gray[r][c] = in_stream.read();
            }
        }
        
        // [MATH] 1D Row DCT Matrix Multiplication
        // For every row (r) and every frequency bin (u), compute the inner product
        // of the spatial pixels (c) and the corresponding cosine wave basis.
        for (int r = 0; r < N_DCT; r++) {
            for (int u = 0; u < N_DCT; u++) {
                dct_t sum = 0; 
                for (int c = 0; c < N_DCT; c++) {
                    // Pre-scaled LUT handles the alpha constant (0.707) natively
                    sum += local_gray[r][c] * cos_lut_f[c][u];
                }
                out_stream.write(internal_dct_t(sum));
            }
        }
    }
}

/*
 * Kernel 3: 1D Discrete Cosine Transform (Columns)
 * Theory: Completes the 2D-DCT by performing the identical 1D transform down 
 * the rows of each column. 
 */
static void kernel3_coldct(hls::stream<internal_dct_t>& in_stream, hls::stream<internal_dct_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_rowdct[N_DCT][N_DCT];
        
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                local_rowdct[r][c] = in_stream.read();
            }
        }
        
        // [MATH] 1D Column DCT Matrix Multiplication
        // Symmetrical to K2, but computes down the rows (r) for each spatial column (c)
        // and frequency bin (v) to finalize the 2D transformation.
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                dct_t sum_col = 0; 
                for (int r = 0; r < N_DCT; r++) {
                    sum_col += local_rowdct[r][c] * cos_lut_f[r][v];
                }
                out_stream.write(internal_dct_t(sum_col));
            }
        }
    }
}

/*
 * Kernel 4: Frequency Thresholding & Fingerprint Hash
 * Theory: Extracts the top-left 8x8 matrix (low-frequency structural data). 
 * Averages these 64 bins, and thresholds them to build a 64-bit fingerprint.
 */
static void kernel4_hash(hls::stream<internal_dct_t>& in_stream, hls::stream<hash_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_coldct[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Sequential Stream Ingestion
        // Must read sequentially in Column-Major order precisely as K3 wrote it.
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                #pragma HLS pipeline II=1
                local_coldct[v][c] = in_stream.read();
            }
        }
        
        // [ALGORITHM] Low-Frequency DC/AC Averaging
        // Sums only the top-left 8x8 block (lowest frequency components).
        dct_t hash_sum = 0;
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                hash_sum += local_coldct[r][c];
            }
        }
        
        // [MATH] Thresholding and Fingerprint Construction
        // If a frequency magnitude is greater than the average, flip its bit to 1.
        // Division by 64 is replaced by a right shift of 6 (>> 6).
        hash_t hash_val = 0;
        int bit_pos = 0;
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
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
 * Theory: Computes the Hamming distance (number of differing bits) between the
 * current fingerprint and target fingerprint. Maintains a sorted array of the closest.
 */
static void kernel5_ranker(hls::stream<hash_t>& in_stream, hash_t target_hash, TopKResult out_topk[TOP_K]) {
    // Initialize the Top-K array with worst-case distance
    for (int i = 0; i < TOP_K; i++) {
        #pragma HLS unroll
        out_topk[i].id = -1;
        out_topk[i].distance = 9999;
    }

    for (int img = 0; img < NUM_IMAGES; img++) {
        hash_t cur_hash = in_stream.read();
        
        // [MATH] Bitwise Difference
        // XOR isolates the differing bits between the two 64-bit hashes in 1 cycle.
        hash_t diff = cur_hash ^ target_hash;
        int current_dist = 0;

        // [ALGORITHM] Kernighan's Bit Counting (PopCount)
        // Mathematically snuffs out the rightmost '1' on every iteration.
        // Bypasses the need to check '0' bits, drastically reducing loop cycles.
        while (diff > 0) {
            diff = diff & (diff - 1);
            current_dist++;
        }
        
        // [ALGORITHM] Insertion Sort 
        // Checks if the new image distance qualifies for the Top-K list.
        // If so, shifts worse elements down and inserts the new winner.
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