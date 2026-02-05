#include "dcl.h"

void top_kernel(data_t A_DRAM[N_ROWS][N_COLS],
                data_t C_DRAM[N_ROWS][N_COLS]) {
#pragma HLS interface m_axi port=A_DRAM offset=slave bundle=A
#pragma HLS interface m_axi port=C_DRAM offset=slave bundle=C
#pragma HLS interface s_axilite port=return

    // 1. LOCAL MEMORY (Back to Factor 8!)
    data_t A[N_ROWS][N_COLS];
    data_t C[N_ROWS][N_COLS];
    data_t tmp[N_ROWS][N_COLS];

    #pragma HLS ARRAY_PARTITION variable=A   dim=2 type=cyclic factor=8
    #pragma HLS ARRAY_PARTITION variable=C   dim=2 type=cyclic factor=8
    #pragma HLS ARRAY_PARTITION variable=tmp dim=2 type=cyclic factor=8

    data_t col_sums[N_COLS];
    #pragma HLS ARRAY_PARTITION variable=col_sums dim=1 type=cyclic factor=8

    // 2. DATA LOAD
    load_row: for (int i = 0; i < N_ROWS; i++) {
        load_col: for (int j = 0; j < N_COLS; j++) {
            #pragma HLS PIPELINE II=1
            A[i][j] = A_DRAM[i][j];
        }
    }

    // 3. PHASE 1: ROW-WISE NORMALIZATION
    phase1_row: for (int i = 0; i < N_ROWS; i++) {
        data_t row_sum = 0.0;

        // Step A: Sum Loop
        phase1_sum: for (int j = 0; j < N_COLS; j++) {
            #pragma HLS PIPELINE II=1
            #pragma HLS UNROLL factor=8
            
            // FORCE DSP FOR ADDITION
            // "fadd" = Floating Point Add. "impl=dsp" = Use DSP Slices.
            #pragma HLS BIND_OP variable=row_sum op=fadd impl=dsp
            row_sum += A[i][j];
        }

        data_t denom = row_sum + (data_t)1.0;

        // Step B: Norm Loop (The Expensive One)
        phase1_norm: for (int j = 0; j < N_COLS; j++) {
            #pragma HLS PIPELINE II=1
            #pragma HLS UNROLL factor=8
            
            // FORCE DSP FOR DIVISION (This is the game changer)
            // Warning: Floating point division on DSPs is resource heavy, 
            // but you have 360 of them. Let's use them!
            // Note: If 'impl=dsp' fails for fdiv (some chips don't support it),
            // remove this specific line and just keep the fadd/fmul ones.
            tmp[i][j] = A[i][j] / denom;
        }
    }

    // 4. PHASE 2: COLUMN-WISE SCALING
    
    // Step A: Initialize
    init_sums: for(int j=0; j<N_COLS; j++) {
        #pragma HLS PIPELINE II=1
        #pragma HLS UNROLL factor=8
        col_sums[j] = 0;
    }

    // Step B: Accumulate
    phase2_acc_i: for (int i = 0; i < N_ROWS; i++) {
        phase2_acc_j: for (int j = 0; j < N_COLS; j++) {
            #pragma HLS PIPELINE II=1
            #pragma HLS UNROLL factor=8
            
            // FORCE DSP FOR ADDITION
            #pragma HLS BIND_OP variable=col_sums op=fadd impl=dsp
            col_sums[j] += tmp[i][j];
        }
    }

    // Step C: Calculate Scale
    phase2_calc: for (int j = 0; j < N_COLS; j++) {
        #pragma HLS PIPELINE II=1
        #pragma HLS UNROLL factor=8
        // Division here happens rarely (once per column), so LUTs are fine.
        col_sums[j] = col_sums[j] / (data_t)N_ROWS;
    }

    // Step D: Apply
    phase2_apply_i: for (int i = 0; i < N_ROWS; i++) {
        phase2_apply_j: for (int j = 0; j < N_COLS; j++) {
            #pragma HLS PIPELINE II=1
            #pragma HLS UNROLL factor=8
            
            // FORCE DSP FOR MULTIPLICATION
            #pragma HLS BIND_OP variable=C op=fmul impl=dsp
            C[i][j] = tmp[i][j] * col_sums[j];
        }
    }

    // 5. DATA STORE
    store_row: for (int i = 0; i < N_ROWS; i++) {
        store_col: for (int j = 0; j < N_COLS; j++) {
            #pragma HLS PIPELINE II=1
            C_DRAM[i][j] = C[i][j];
        }
    }
}