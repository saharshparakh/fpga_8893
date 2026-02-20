#include "dcl.h"
#include <ap_int.h>

// ============================================================================
// Configuration
// ============================================================================
#define VEC         16           // columns processed per pipeline cycle
#define PE_COUNT     4           // parallel PE instances (4 × 16 × 3 muls = 192 DSPs)
#define ROWS_PER_PE  ((NX - 2 + PE_COUNT - 1) / PE_COUNT)  // ceil(254/4) = 64

// ============================================================================
// DSP-FRIENDLY TYPES
//
// The original code used:
//   data_t (ap_fixed<24,8>)  as coefficient type  → 24-bit, overflows DSP B-port (18-bit) → LUT
//   acc_t  (ap_fixed<40,12>) as sum type           → 40-bit, overflows DSP A-port (27-bit) → LUT
//   Product: 24×40 = 64-bit, cannot map to any single DSP48 → cascaded LUT multipliers
//
// DSP48E1/E2 ports:
//   A-input: 30-bit (pre-adder output to multiplier: 27-bit signed)
//   B-input: 18-bit signed
//   P-output: 48-bit accumulator
//
// Fix: size types to fit within DSP ports exactly:
//   sum_t:  ap_fixed<26,10> → 26-bit  ≤ 27-bit A-port  ✓
//   coef_t: ap_fixed<18, 2> → 18-bit == 18-bit B-port  ✓
//   Product: 26×18 = 44-bit ≤ 48-bit P-output          ✓  → single DSP48 per multiply
//
// Precision check:
//   data_t max = 2^7 - 2^-16 ≈ 127.99   (8 integer bits)
//   sum of 8 neighbors max ≈ 8 × 127.99 = 1023.9 → needs 10 integer bits → ap_fixed<26,10> ✓
//   wc=0.50, wa=0.10, wd=0.025 all fit comfortably in ap_fixed<18,2> (2 integer bits, 16 frac) ✓
// ============================================================================
typedef ap_fixed<26, 10, AP_RND, AP_SAT> sum_t;   // fits DSP A-port (27-bit signed)
typedef ap_fixed<18,  2, AP_RND, AP_SAT> coef_t;  // fits DSP B-port (18-bit signed) exactly

// ============================================================================
// READ: 512-bit AXI → partitioned on-chip BRAM
// 512 bits / 32 bits per data_t = 16 elements per beat → matches VEC=16
// ============================================================================
static void read_mem(const data_t A_in[NX][NY], data_t buf[NX][NY]) {
    const ap_uint<512>* A_wide = (const ap_uint<512>*)A_in;
    READ_I: for (int i = 0; i < NX; i++) {
        READ_J: for (int j = 0; j < NY / VEC; j++) {
            #pragma HLS pipeline II=1
            ap_uint<512> chunk = A_wide[i * (NY / VEC) + j];
            for (int k = 0; k < VEC; k++) {
                #pragma HLS unroll
                data_t pixel;
                pixel.range(23, 0) = chunk.range(k * 32 + 23, k * 32);
                buf[i][j * VEC + k] = pixel;
            }
        }
    }
}

// ============================================================================
// WRITE: partitioned on-chip BRAM → 512-bit AXI
// ============================================================================
static void write_mem(data_t A_out[NX][NY], data_t buf[NX][NY]) {
    ap_uint<512>* A_wide = (ap_uint<512>*)A_out;
    WRITE_I: for (int i = 0; i < NX; i++) {
        WRITE_J: for (int j = 0; j < NY / VEC; j++) {
            #pragma HLS pipeline II=1
            ap_uint<512> chunk = 0;
            for (int k = 0; k < VEC; k++) {
                #pragma HLS unroll
                data_t pixel = buf[i][j * VEC + k];
                chunk.range(k * 32 + 23, k * 32) = pixel.range(23, 0);
            }
            A_wide[i * (NY / VEC) + j] = chunk;
        }
    }
}

// ============================================================================
// COMPUTE PE: 9-point stencil for row band [i_start, i_end)
//
// Memory access pattern:
//   lb0/lb1/lb2 are completely partitioned → pure register arrays (no BRAM reads
//   during stencil compute, zero-latency access to any element)
//
//   Row loading from BRAM uses inner-unrolled loops: 16 elements/cycle from the
//   cyclic-16 banked BRAM → each row loads in NY/VEC = 16 cycles (not 256)
//
// DSP mapping:
//   #pragma HLS bind_op op=mul impl=dsp  forces ALL multiplications in this
//   function scope into DSP48 slices. With sum_t(26-bit) × coef_t(18-bit),
//   each multiply maps to exactly ONE DSP48 (no cascading).
//   3 multiplies × VEC(16) unrolled × PE_COUNT(4) instances = 192 DSPs total.
//
// The DSP pre-adder (A±D before multiply) is available but not explicitly used
// here; HLS may use it to merge one addition into the DSP for wc*center + ...
// ============================================================================
static void compute_pe(
    data_t cur[NX][NY],
    data_t nxt[NX][NY],
    int i_start,
    int i_end
) {
    // Force ALL multiplications in this function to DSP48 slices
    // With sum_t(26-bit) × coef_t(18-bit) each fits in a single DSP48 (27×18)
    #pragma HLS bind_op op=mul impl=dsp latency=3

    const coef_t wc = (coef_t)0.50;    // center weight    (exact in fixed-point)
    const coef_t wa = (coef_t)0.10;    // axis weight      (≈ 0.09999... in fixed-point)
    const coef_t wd = (coef_t)0.025;   // diagonal weight  (exact in fixed-point)

    // Line buffers: 3 × 256 elements, completely partitioned → pure registers
    // This eliminates ALL BRAM reads during the stencil computation phase;
    // any element lb0[j], lb1[j±1], lb2[j±1] is available in the same cycle.
    data_t lb0[NY], lb1[NY], lb2[NY];
    #pragma HLS array_partition variable=lb0 complete
    #pragma HLS array_partition variable=lb1 complete
    #pragma HLS array_partition variable=lb2 complete

    // Pre-load halo row (i_start - 1) into lb0
    // Inner unroll: 16 elements/cycle from cyclic-16 BRAM → 16 cycles total
    PRELOAD_0: for (int j = 0; j < NY / VEC; j++) {
        #pragma HLS pipeline II=1
        for (int k = 0; k < VEC; k++) {
            #pragma HLS unroll
            lb0[j * VEC + k] = cur[i_start - 1][j * VEC + k];
        }
    }

    // Pre-load first interior row into lb1
    PRELOAD_1: for (int j = 0; j < NY / VEC; j++) {
        #pragma HLS pipeline II=1
        for (int k = 0; k < VEC; k++) {
            #pragma HLS unroll
            lb1[j * VEC + k] = cur[i_start][j * VEC + k];
        }
    }

    // Slide the 3-row window down through the assigned band
    PE_ROW: for (int i = i_start; i < i_end; i++) {

        // Load the row below the current center row into lb2
        // 16 elements/cycle from 16-bank BRAM → 16 cycles
        LOAD_NEXT: for (int j = 0; j < NY / VEC; j++) {
            #pragma HLS pipeline II=1
            for (int k = 0; k < VEC; k++) {
                #pragma HLS unroll
                lb2[j * VEC + k] = cur[i + 1][j * VEC + k];
            }
        }

        // ----------------------------------------------------------------
        // Stencil computation: VEC=16 elements computed per cycle
        //
        // Boundary columns (j=0, j=NY-1) are excluded — they hold their
        // original value (written during BOUND_INIT in compute_stencil).
        // The interior is j = 1 .. NY-2 = 1 .. 254.
        //
        // With VEC=16 unrolled inside a pipelined loop:
        //   - All 16 multiplies and their adder trees are parallel hardware
        //   - lb0/lb1/lb2 are registers → zero-latency reads, no bank conflict
        //   - nxt writes go to cyclic-16 BRAM: 16 distinct banks → II=1
        //
        // Loop trip count: ceil(254 / 16) = 16 iterations
        // ----------------------------------------------------------------
        STENCIL_J: for (int jb = 0; jb < (NY + VEC - 1) / VEC; jb++) {
            #pragma HLS pipeline II=1
            for (int jv = 0; jv < VEC; jv++) {
                #pragma HLS unroll
                int j = jb * VEC + jv;
                // Guard: only update interior columns
                if (j >= 1 && j <= NY - 2) {
                    // Sum of 4 axis-aligned neighbors → fits in sum_t (26-bit)
                    sum_t sum_axis = (sum_t)lb0[j]   + (sum_t)lb2[j]   +
                                     (sum_t)lb1[j-1] + (sum_t)lb1[j+1];

                    // Sum of 4 diagonal neighbors → fits in sum_t (26-bit)
                    sum_t sum_diag = (sum_t)lb0[j-1] + (sum_t)lb0[j+1] +
                                     (sum_t)lb2[j-1] + (sum_t)lb2[j+1];

                    sum_t center = (sum_t)lb1[j];

                    // 3 multiplies: each 26-bit × 18-bit → single DSP48 each
                    // Accumulate into acc_t (wider) to avoid precision loss
                    acc_t result = (acc_t)(wc * center) +
                                   (acc_t)(wa * sum_axis) +
                                   (acc_t)(wd * sum_diag);

                    nxt[i][j] = (data_t)result;
                }
            }
        }

        // Rotate line buffers: lb0 ← lb1 ← lb2
        // Completely partitioned → this is 256 parallel register assignments,
        // synthesised as wiring (zero LUTs, zero latency, zero cycles)
        ROTATE: for (int j = 0; j < NY; j++) {
            #pragma HLS unroll
            lb0[j] = lb1[j];
            lb1[j] = lb2[j];
        }
    }
}

// ============================================================================
// COMPUTE STENCIL: orchestrates PE_COUNT=4 parallel PE instances
//
// Ping-pong between cur and nxt each timestep (pointer swap, no data copy).
// Boundary rows and columns are written once before the time loop and never
// touched again — boundary guard in compute_pe ensures this.
// ============================================================================
static void compute_stencil(data_t cur[NX][NY], data_t nxt[NX][NY]) {
    // Initialise boundary cells in nxt (copied from cur, then never updated)
    BOUND_INIT_I: for (int i = 0; i < NX; i++) {
        #pragma HLS pipeline II=1
        nxt[i][0]      = cur[i][0];
        nxt[i][NY - 1] = cur[i][NY - 1];
    }
    BOUND_INIT_J: for (int j = 0; j < NY; j++) {
        #pragma HLS pipeline II=1
        nxt[0][j]      = cur[0][j];
        nxt[NX-1][j]   = cur[NX-1][j];
    }

    TIMESTEP: for (int t = 0; t < TSTEPS; t++) {
        // All 4 PE instances run in parallel (unrolled → 4 separate hardware blocks)
        // Each PE owns an exclusive, non-overlapping band of rows → no write conflicts
        PE_LOOP: for (int pe = 0; pe < PE_COUNT; pe++) {
            #pragma HLS unroll
            int i_start = 1 + pe * ROWS_PER_PE;
            int i_end   = i_start + ROWS_PER_PE;
            if (i_end > NX - 1) i_end = NX - 1;

            // Ping-pong: alternate source/destination each timestep
            // avoids a physical buffer copy loop (~30K wasted cycles in original)
            if (t % 2 == 0) {
                compute_pe(cur, nxt, i_start, i_end);
            } else {
                compute_pe(nxt, cur, i_start, i_end);
            }
        }
    }
}

// ============================================================================
// TOP-LEVEL KERNEL
// ============================================================================
void top_kernel(const data_t A_in[NX][NY], data_t A_out[NX][NY]) {
#pragma HLS interface m_axi port=A_in  offset=slave bundle=gmem0 max_widen_bitwidth=512
#pragma HLS interface m_axi port=A_out offset=slave bundle=gmem1 max_widen_bitwidth=512
#pragma HLS interface s_axilite port=return

    static data_t cur[NX][NY];
    static data_t nxt[NX][NY];

    // Cyclic-16 partition on column dimension:
    //   - Creates 16 independent BRAM banks (one per VEC lane)
    //   - Any aligned 16-element access (j = 0,16,32,...) hits all 16 banks → II=1
    //   - Diagonal neighbor accesses j±1 across a bank boundary are handled by
    //     the complete-partition line buffers (no BRAM access during stencil)
    #pragma HLS array_partition variable=cur cyclic factor=16 dim=2
    #pragma HLS array_partition variable=nxt cyclic factor=16 dim=2
    #pragma HLS bind_storage    variable=cur type=ram_2p impl=bram
    #pragma HLS bind_storage    variable=nxt type=ram_2p impl=bram

    // 1. Stream data from AXI into BRAM  (4,096 cycles: 256 rows × 16 beats/row)
    read_mem(A_in, cur);

    // 2. Run all 30 timesteps on-chip    (~38K cycles estimate — see below)
    compute_stencil(cur, nxt);

    // 3. Stream result back to AXI       (4,096 cycles)
    //    TSTEPS=30 is even → result is in cur after ping-pong
    if (TSTEPS % 2 == 0) {
        write_mem(A_out, cur);
    } else {
        write_mem(A_out, nxt);
    }
}

// ============================================================================
// EXPECTED CYCLE COUNT BREAKDOWN (with fixes applied)
//
//  read_mem:        256 rows × (256/16) beats  =  4,096 cycles
//
//  BOUND_INIT_I/J:  256 + 256                  =    512 cycles
//
//  compute_stencil: 4 PEs in parallel, each processing 64 rows per timestep
//    Per PE per timestep:
//      PRELOAD_0:   NY/VEC = 16 cycles
//      PRELOAD_1:   NY/VEC = 16 cycles
//      PE_ROW × 64 rows:
//        LOAD_NEXT: NY/VEC  = 16 cycles
//        STENCIL_J: NY/VEC  = 16 cycles  (guard on j=0/NY-1 adds no cycles)
//        ROTATE:    0 cycles (pure wiring)
//        Subtotal:            32 cycles/row
//      Total per PE: 32 (preload) + 64 × 32 = 32 + 2048 = 2,080 cycles
//    All 4 PEs run in parallel → 2,080 cycles per timestep
//    30 timesteps: 30 × 2,080 = 62,400 cycles
//
//  write_mem:                                   4,096 cycles
//
//  GRAND TOTAL:  ~71,100 cycles
//
// NOTE: This is higher than the original 38K estimate because the row-loading
// cost (LOAD_NEXT: 16 cycles) equals the stencil compute (STENCIL_J: 16 cycles)
// and they cannot overlap without a dataflow restructure of compute_pe.
// The DSP fix is the critical correctness step; cycle optimisation is next.
//
// PRIMARY RESOURCE SAVINGS vs previous (LUT-overflow) build:
//   LUTs: was 152% → multipliers now in DSPs, targeting ~40-50% LUT
//   DSPs: 4 PEs × 16 VEC × 3 muls = 192 DSPs (53% of 360)
//   BRAM: ~200 BRAM_18K (same as before, cyclic-16 on 256×256 arrays)
// ============================================================================