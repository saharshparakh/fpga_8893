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

// [ARCHITECTURE] Stream Widening Vector
// Packs 8 values into a single struct. This allows the FIFOs to pass 
// 8 pixels per clock cycle, halving the minimum stream latency to 32 cycles/image.
struct dct_vec8_t {
    internal_dct_t p[8];
};

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
 * [ARCHITECTURE] AXI Burst Reader: Isolates the AXI memory-mapped interface from the compute logic.
 * Continuously streams 1024-bit words to saturate DDR bandwidth.
 */
static void read_input(const pixel_t* in, hls::stream<wide_t>& out_stream) {
    int total_words = (NUM_IMAGES * IMG_W * IMG_H * 3) / 128;
    const wide_t* wide_in = (const wide_t*)in;
    for (int i = 0; i < total_words; i++) {
        #pragma HLS pipeline II=1
        out_stream.write(wide_in[i]);
    }
}

/*
 * Kernel 1.A: Ping-Pong Buffer Write Stage
 * [ARCHITECTURE] Local Band Unpacker: Reads 6 wide-words to buffer exactly 
 * enough pixel rows required to compute the next block of 4x4 spatial averages.
 */
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

/*
 * Kernel 1.B: Ping-Pong Buffer Compute Stage
 * [ALGORITHM] 4x4 Spatial Downsampling & Grayscale Conversion.
 * Computes 8 blocks in parallel. Completely unrolled loops generate 192 MAC operations.
 */
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
                    
                    // [MATH] Grayscale Luminosity
                    dct_t r_val = dct_t(local_band[idx + 0]) * w_r;
                    dct_t g_val = dct_t(local_band[idx + 1]) * w_g;
                    dct_t b_val = dct_t(local_band[idx + 2]) * w_b;
                    sum += (r_val + g_val + b_val);
                }
            }
            // [MATH] Division by 16 replaced natively by C++ scaling fixed-point types
            out_vec.p[v] = internal_dct_t(sum / dct_t(16));
        }
        out_stream.write(out_vec);
    }
}

/*
 * Kernel 1 Top: Grayscale Conversion & Spatial Downsampling
 * [ARCHITECTURE] Sub-Kernel Dataflow Ping-Pong
 * By instantiating read and compute inside a dataflow region, Vivado automatically 
 * synthesizes a Double-Buffer (Ping-Pong RAM). Reading and computing happen simultaneously.
 */
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

/*
 * Kernel 2: 1D Discrete Cosine Transform (Rows)
 */
static void kernel2_rowdct(hls::stream<dct_vec8_t>& in_stream, hls::stream<dct_vec8_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_gray[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Complete Array Partitioning (Columns)
        // Shatters columns into registers so an entire row can be read simultaneously.
        #pragma HLS array_partition variable=local_gray complete dim=2
        
        // [TIMING FIX] Manual Loop Flattening for Vector Read
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
        
        // [MATH] 1D Row DCT Matrix Multiplication
        // [OPTIMIZATION] Balanced 4-level adder tree replaces 16-element chain,
        // reducing pipeline depth and critical path without using DSP pragmas.
        for (int i = 0; i < 32; i++) {
            #pragma HLS pipeline II=1
            int r = i >> 1;
            int chunk = i & 1;
            dct_vec8_t out_vec;
            for (int v = 0; v < 8; v++) {
                #pragma HLS unroll
                int u = chunk * 8 + v;
                // Level 0: 16 parallel multiplies
                dct_t p0  = local_gray[r][0]  * cos_lut_f[0][u];
                dct_t p1  = local_gray[r][1]  * cos_lut_f[1][u];
                dct_t p2  = local_gray[r][2]  * cos_lut_f[2][u];
                dct_t p3  = local_gray[r][3]  * cos_lut_f[3][u];
                dct_t p4  = local_gray[r][4]  * cos_lut_f[4][u];
                dct_t p5  = local_gray[r][5]  * cos_lut_f[5][u];
                dct_t p6  = local_gray[r][6]  * cos_lut_f[6][u];
                dct_t p7  = local_gray[r][7]  * cos_lut_f[7][u];
                dct_t p8  = local_gray[r][8]  * cos_lut_f[8][u];
                dct_t p9  = local_gray[r][9]  * cos_lut_f[9][u];
                dct_t p10 = local_gray[r][10] * cos_lut_f[10][u];
                dct_t p11 = local_gray[r][11] * cos_lut_f[11][u];
                dct_t p12 = local_gray[r][12] * cos_lut_f[12][u];
                dct_t p13 = local_gray[r][13] * cos_lut_f[13][u];
                dct_t p14 = local_gray[r][14] * cos_lut_f[14][u];
                dct_t p15 = local_gray[r][15] * cos_lut_f[15][u];
                // Level 1: 8 pair-wise additions (depth 1)
                dct_t s1_0 = p0  + p1;   dct_t s1_1 = p2  + p3;
                dct_t s1_2 = p4  + p5;   dct_t s1_3 = p6  + p7;
                dct_t s1_4 = p8  + p9;   dct_t s1_5 = p10 + p11;
                dct_t s1_6 = p12 + p13;  dct_t s1_7 = p14 + p15;
                // Level 2: 4 additions (depth 2)
                dct_t s2_0 = s1_0 + s1_1;  dct_t s2_1 = s1_2 + s1_3;
                dct_t s2_2 = s1_4 + s1_5;  dct_t s2_3 = s1_6 + s1_7;
                // Level 3: 2 additions (depth 3)
                dct_t s3_0 = s2_0 + s2_1;  dct_t s3_1 = s2_2 + s2_3;
                // Level 4: final sum (depth 4)
                dct_t sum = s3_0 + s3_1;
                out_vec.p[v] = internal_dct_t(sum);
            }
            out_stream.write(out_vec);
        }
    }
}

/*
 * Kernel 3: 1D Discrete Cosine Transform (Columns)
 */
static void kernel3_coldct(hls::stream<dct_vec8_t>& in_stream, hls::stream<dct_vec8_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_rowdct[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Complete Array Partitioning (Full Matrix)
        // Required for simultaneous cross-directional ingestion and column mathematics.
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
        
        // [MATH] 1D Column DCT Matrix Multiplication
        // [OPTIMIZATION] Balanced 4-level adder tree replaces 16-element chain.
        for (int i = 0; i < 32; i++) {
            #pragma HLS pipeline II=1
            int c = i >> 1;     
            int v_blk = i & 1;  
            
            dct_vec8_t out_vec;
            for (int j = 0; j < 8; j++) {
                #pragma HLS unroll
                int v = v_blk * 8 + j;
                // Level 0: 16 parallel multiplies
                dct_t p0  = local_rowdct[0][c]  * cos_lut_f[0][v];
                dct_t p1  = local_rowdct[1][c]  * cos_lut_f[1][v];
                dct_t p2  = local_rowdct[2][c]  * cos_lut_f[2][v];
                dct_t p3  = local_rowdct[3][c]  * cos_lut_f[3][v];
                dct_t p4  = local_rowdct[4][c]  * cos_lut_f[4][v];
                dct_t p5  = local_rowdct[5][c]  * cos_lut_f[5][v];
                dct_t p6  = local_rowdct[6][c]  * cos_lut_f[6][v];
                dct_t p7  = local_rowdct[7][c]  * cos_lut_f[7][v];
                dct_t p8  = local_rowdct[8][c]  * cos_lut_f[8][v];
                dct_t p9  = local_rowdct[9][c]  * cos_lut_f[9][v];
                dct_t p10 = local_rowdct[10][c] * cos_lut_f[10][v];
                dct_t p11 = local_rowdct[11][c] * cos_lut_f[11][v];
                dct_t p12 = local_rowdct[12][c] * cos_lut_f[12][v];
                dct_t p13 = local_rowdct[13][c] * cos_lut_f[13][v];
                dct_t p14 = local_rowdct[14][c] * cos_lut_f[14][v];
                dct_t p15 = local_rowdct[15][c] * cos_lut_f[15][v];
                // Level 1: 8 pair-wise additions
                dct_t s1_0 = p0  + p1;   dct_t s1_1 = p2  + p3;
                dct_t s1_2 = p4  + p5;   dct_t s1_3 = p6  + p7;
                dct_t s1_4 = p8  + p9;   dct_t s1_5 = p10 + p11;
                dct_t s1_6 = p12 + p13;  dct_t s1_7 = p14 + p15;
                // Level 2: 4 additions
                dct_t s2_0 = s1_0 + s1_1;  dct_t s2_1 = s1_2 + s1_3;
                dct_t s2_2 = s1_4 + s1_5;  dct_t s2_3 = s1_6 + s1_7;
                // Level 3: 2 additions
                dct_t s3_0 = s2_0 + s2_1;  dct_t s3_1 = s2_2 + s2_3;
                // Level 4: final sum
                dct_t sum_col = s3_0 + s3_1;
                out_vec.p[j] = internal_dct_t(sum_col);
            }
            out_stream.write(out_vec);
        }
    }
}

/*
 * Kernel 4: Frequency Thresholding & Fingerprint Hash
 */
static void kernel4_hash(hls::stream<dct_vec8_t>& in_stream, hls::stream<hash_t>& out_stream) {
    for (int img = 0; img < NUM_IMAGES; img++) {
        internal_dct_t local_coldct[N_DCT][N_DCT];
        
        // [ARCHITECTURE] Complete Array Partitioning 
        // Eliminates all memory accesses allowing instant mathematical reductions.
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
        
        // [ALGORITHM] Low-Frequency DC/AC Averaging
        // [OPTIMIZATION] Balanced 3-stage adder tree for 64-element hash_sum.
        // Replaces 81-state sequential FSM with parallel reduction.
        
        // Stage A: Row-wise balanced sums (8 rows x 8 elements each)
        dct_t row_sum[8];
        #pragma HLS array_partition variable=row_sum complete
        for (int r = 0; r < 8; r++) {
            #pragma HLS unroll
            dct_t a01 = dct_t(local_coldct[r][0]) + dct_t(local_coldct[r][1]);
            dct_t a23 = dct_t(local_coldct[r][2]) + dct_t(local_coldct[r][3]);
            dct_t a45 = dct_t(local_coldct[r][4]) + dct_t(local_coldct[r][5]);
            dct_t a67 = dct_t(local_coldct[r][6]) + dct_t(local_coldct[r][7]);
            dct_t b0 = a01 + a23;
            dct_t b1 = a45 + a67;
            row_sum[r] = b0 + b1;
        }
        
        // Stage B: Cross-row balanced reduction
        dct_t q0 = row_sum[0] + row_sum[1];
        dct_t q1 = row_sum[2] + row_sum[3];
        dct_t q2 = row_sum[4] + row_sum[5];
        dct_t q3 = row_sum[6] + row_sum[7];
        dct_t h0 = q0 + q1;
        dct_t h1 = q2 + q3;
        dct_t hash_sum = h0 + h1;
        
        // [MATH] Pre-compute mean threshold once (single division shared by 64 compares)
        dct_t mean = hash_sum / dct_t(64);
        
        // [MATH] Parallel Thresholding and Fingerprint Construction
        // [OPTIMIZATION] Bit-level assignment eliminates |= dependency chain.
        // Each bit is computed independently — no read-modify-write on hash_val.
        hash_t hash_val = 0;
        for (int r = 0; r < 8; r++) {
            #pragma HLS unroll
            for (int c = 0; c < 8; c++) {
                #pragma HLS unroll
                if (dct_t(local_coldct[r][c]) > mean) {
                    hash_val[r * 8 + c] = 1;
                }
            }
        }
        out_stream.write(hash_val);
    }
}

/*
 * Kernel 5: Distance Ranking & Top-K Sorter
 * [ALGORITHM] Real-Time Parallel Sorting Network
 * Operates at II=1, consuming, evaluating, and sorting an image fingerprint every clock cycle.
 */
static void kernel5_ranker(hls::stream<hash_t>& in_stream, hash_t target_hash, TopKResult out_topk[TOP_K]) {
    TopKResult local_topk[TOP_K];
    #pragma HLS array_partition variable=local_topk complete
    
    // Initialize the Top-K array with worst-case distances
    for (int i = 0; i < TOP_K; i++) {
        #pragma HLS unroll
        local_topk[i].id = -1;
        local_topk[i].distance = 9999;
    }

    // [ARCHITECTURE] Fully Pipelined Processing Matrix
    for (int img = 0; img < NUM_IMAGES; img++) {
        #pragma HLS pipeline II=1
        hash_t cur_hash = in_stream.read();
        
        // [MATH] Bitwise Difference (XOR)
        hash_t diff = cur_hash ^ target_hash;
        
        // [ALGORITHM] Unrolled PopCount
        // Sums all 64 bits instantly via pure combinatorial adder-tree wiring,
        // avoiding sequential variable-latency while loops.
        int current_dist = 0;
        for (int b = 0; b < 64; b++) {
            #pragma HLS unroll
            current_dist += (diff >> b) & 1;
        }
        
        // [ALGORITHM] Parallel Compare
        // Simultaneously evaluates the new distance against every rank in the Top K list.
        bool is_better[TOP_K];
        #pragma HLS array_partition variable=is_better complete
        
        for (int i = 0; i < TOP_K; i++) {
            #pragma HLS unroll
            is_better[i] = (current_dist < local_topk[i].distance) || 
                           (current_dist == local_topk[i].distance && img < local_topk[i].id);
        }
        
        // [ALGORITHM] Parallel Shift and Insert (Sorting Network)
        // Cascades the results instantly based on the compare array logic.
        TopKResult next_topk[TOP_K];
        #pragma HLS array_partition variable=next_topk complete
        
        for (int i = 0; i < TOP_K; i++) {
            #pragma HLS unroll
            if (is_better[i]) {
                if (i == 0 || !is_better[i-1]) {
                    // Exact insertion point
                    next_topk[i].id = img;
                    next_topk[i].distance = current_dist;
                } else {
                    // Shift worse elements down
                    next_topk[i] = local_topk[i-1];
                }
            } else {
                // Better element, leave untouched
                next_topk[i] = local_topk[i];
            }
        }
        
        // Register update
        for (int i = 0; i < TOP_K; i++) {
            #pragma HLS unroll
            local_topk[i] = next_topk[i];
        }
    }
    
    // Drain final results
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

    // [ARCHITECTURE] Task-Level Parallelism
    // Forces Kernels 0 through 5 to execute simultaneously like an assembly line.
    #pragma HLS dataflow

    hls::stream<wide_t> raw_in("raw_in");
    hls::stream<dct_vec8_t> s_gray("s_gray");
    hls::stream<dct_vec8_t> s_rowdct("s_rowdct");
    hls::stream<dct_vec8_t> s_coldct("s_coldct");
    hls::stream<hash_t> s_hash("s_hash");

    // [ARCHITECTURE] Stream Depth Sizing
    // Prevents pipeline stalls between upstream and downstream kernels.
    // raw_in depth 128 buffers exactly 1 complete 64x64 RGB image.
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