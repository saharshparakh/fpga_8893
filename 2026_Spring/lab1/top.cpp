#include "dcl.h"
#include <hls_stream.h>

/* #########################################################################
    sparakh7: Custom functions to evetually pipeline the entire flow
######################################################################### */

// Reads 64 elements 16 at a time
void mem_read(ap_uint<512> *A_wide, data_t A[N_ROWS][N_COLS]) {
    const int TOTAL = N_ROWS * N_COLS;   // 16384
    const int WORDS = TOTAL / 16;        // 1024
    for (int w = 0; w < WORDS; w++) {
        #pragma HLS PIPELINE II=1
        ap_uint<512> wide = A_wide[w];
        for (int k = 0; k < 16; k++) {
            #pragma HLS UNROLL
            int idx = w * 16 + k;
            int r = idx / N_COLS;
            int c = idx % N_COLS;
            ap_uint<32> bits = wide.range((k+1)*32 - 1, k*32);
            data_t val;
            val.range() = bits.range(23, 0); // Explicitly map the 24 bits of your type
            A[r][c] = val;
        }
    }
}


// Writes back to the memory using scaled row data from a stream. 16 elemts at a time.
void mem_write(data_t C[N_ROWS][N_COLS], ap_uint<512> *C_wide) {
    const int TOTAL = N_ROWS * N_COLS;   // 16384
    const int WORDS = TOTAL / 16;        // 1024

    for (int w = 0; w < WORDS; w++) {
        #pragma HLS PIPELINE II=1
        ap_uint<512> wide;
        
        for (int k = 0; k < 16; k++) {
            #pragma HLS UNROLL
            int idx = w * 16 + k;
            int r = idx / N_COLS;
            int c = idx % N_COLS;
            
            // Extract the internal bits of the fixed-point value
            // We initialize a 32-bit container to ensure AXI alignment
            ap_uint<32> bits = 0;
            bits.range(23, 0) = C[r][c].range();
            
            // Pack into the 512-bit wide word
            wide.range((k + 1) * 32 - 1, k * 32) = bits;
        }
        // Single 512-bit burst write
        C_wide[w] = wide;
    }
}

// Used for row normalization. Limits dividers to 8.
void row_divider(data_t row_in[N_COLS], data_t row_out[N_COLS], data_t denom) {
    #pragma HLS INLINE off
    for (int j = 0; j < N_COLS; j++) {
        #pragma HLS PIPELINE II=1
        row_out[j] = row_in[j] / denom;
        // We limit the number of dividers inside this specific function
        #pragma HLS allocation limit=12 operation instances=sdiv

    }
}

// Handle entire row normailization so it can be pipelined
void row_normalization(data_t A[N_ROWS][N_COLS], data_t tmp[N_ROWS][N_COLS]) {
    for (int i = 0; i < N_ROWS; i++) {
        #pragma HLS PIPELINE II = 1
        data_t row_sum = 0.0;

        // Compute row sum
        for (int j = 0; j < N_COLS; j++) {
            //#pragma HLS UNROLL
            #pragma HLS BIND_OP variable=row_sum op=add impl=dsp latency=2
            row_sum += A[i][j];
        }

        // Avoid division by zero, add small bias
        data_t denom;
        #pragma HLS BIND_OP variable=denom op=add impl=dsp
        denom = row_sum + (data_t)1.0;

        row_divider(A[i], tmp[i], denom);
    }
}

// Used to accumulate the sum of each element in a column
void col_accumulator(data_t tmp_buffer[N_ROWS][N_COLS], data_t col_sums[N_COLS]) {
    #pragma HLS INLINE
    // Calling it times the number of rows
    for (int row_index = 0; row_index < N_ROWS; row_index++) {
        #pragma HLS PIPELINE II=1
        for (int j = 0; j < N_COLS; j++) {
            #pragma HLS UNROLL factor = 16
            // Proceed with normal accumulation
            #pragma HLS BIND_OP variable=col_sums op=add impl=dsp
            if (row_index == 0) {
                // Initialize correctly
                col_sums[j] = tmp_buffer[row_index][j]; 
            } else {
                col_sums[j] += tmp_buffer[row_index][j];
            }
        }
    }
}

// Used to calculate column scales to multiply each element by
void col_scale_calc(data_t col_sums[N_COLS], data_t scales[N_COLS]) {
    // Divide after rows accumulate
    for (int j = 0; j < N_COLS; j++) {
        #pragma HLS PIPELINE II=1
        scales[j] = col_sums[j] / (data_t)N_ROWS;
        #pragma HLS allocation limit=6 operation instances=fdiv
    }
}

// Once the col math is done, scale by rows for efficient writeback.
void scale_rows(data_t tmp[N_ROWS][N_COLS], data_t scales[N_COLS], data_t C[N_ROWS][N_COLS]) {
    data_t val;
    for (int i = 0; i < N_ROWS; i++) {
        #pragma HLS PIPELINE II=1 
        // Scale 1 row each cycle
        for (int j = 0; j < N_COLS; j++) {
            // 64 DSPs fire simultaneously
            #pragma HLS_UNROLL factor = 16
            #pragma HLS BIND_OP variable=val op=mul impl=dsp
            val = tmp[i][j] * scales[j];
            C[i][j] = val;
        }
    }
}

// Entire col scaling method
void col_scaling(data_t tmp[N_ROWS][N_COLS], data_t C[N_ROWS][N_COLS]) {
    data_t scales[N_COLS];
    data_t col_sums[N_COLS];
    #pragma HLS array_partition variable=scales complete
    #pragma HLS array_partition variable=col_sums complete

    // These MUST be sequential because scales depend on col_sums
    col_accumulator(tmp, col_sums); // store the running sum of each column and eventual scale
    col_scale_calc(col_sums, scales); // Calculate the scales  
    scale_rows(tmp, scales, C);  // Scale rows 1 at a time
}

/* #########################################################################
    sparakh7: Custom functions end
######################################################################### */


// Baseline implementation for HLS.
// Students will optimize this (loops, memory access, etc.).
void top_kernel(data_t A_DRAM[N_ROWS][N_COLS],
                data_t C_DRAM[N_ROWS][N_COLS]) {
    #pragma HLS INTERFACE m_axi port=A_DRAM bundle=gmem0 max_read_burst_length=64 num_read_outstanding=4
    #pragma HLS INTERFACE m_axi port=C_DRAM bundle=gmem1 max_write_burst_length=64 num_read_outstanding=4
    #pragma HLS INTERFACE s_axilite port=return

    // On-chip buffers for A_DRAM and C_DRAM
    data_t C[N_ROWS][N_COLS];
    data_t A[N_ROWS][N_COLS];
    data_t tmp[N_ROWS][N_COLS];
    
    #pragma HLS array_partition variable=A complete dim=2
    // #pragma HLS array_partition variable=C complete dim=2
    #pragma HLS array_partition variable=tmp complete dim=2

    #pragma HLS array_partition variable=A cyclic factor=16 dim=2
    #pragma HLS array_partition variable=tmp cyclic factor=16 dim=2
    #pragma HLS array_partition variable=C cyclic factor=16 dim=2

    // Create a dataflow to pipeline each function
    #pragma HLS dataflow

    // Read from DRAM
    mem_read((ap_uint<512> *)A_DRAM, A);

    // Phase 1: Row-wise normalization
    row_normalization(A, tmp);

    // Phase 2: Column-wise scaling
    col_scaling(tmp, C);

    // Write to DRAM
    mem_write(C, (ap_uint<512> *)C_DRAM);

}