#include "dcl.h"
#include <ap_int.h>

typedef ap_uint<512> wide_t;

static const int EBITS  = 32;
static const int DBITS  = 24;
static const int PACK   = 512 / EBITS;   // 16
static const int WPR    = NY / PACK;     // 16
static const int NWORDS = NX * WPR;      // 4096

static const int NPE    = 86;            // number of PEs
static const int NCHUNK = 3;             // 3 chunks per row

/* ------------------------------------------------------------------
   compute_chunk: process up to NPE columns starting at offset
   ------------------------------------------------------------------ */
static void compute_chunk(int i, int offset,
                          data_t Lp[NY],
                          data_t Lc[NY],
                          data_t Ln[NY],
                          data_t Ro[NY],
                          const data_t wa,
                          const data_t wd)
{
#pragma HLS inline

    // Fixed-width PE loop: 86 lanes
    for (int jj = 0; jj < NPE; jj++) {
#pragma HLS unroll
        int j = offset + jj;
        if (j >= NY) continue;   // last chunk has only 84 valid cols

        if (i == 0 || i == NX - 1 || j == 0 || j == NY - 1) {
            Ro[j] = Lc[j];
        } else {
            // Neighbor sums in fabric
            acc_t sa = (acc_t)Lp[j]   + (acc_t)Ln[j];
            acc_t sb = (acc_t)Lc[j-1] + (acc_t)Lc[j+1];
            acc_t sc = (acc_t)Lp[j-1] + (acc_t)Lp[j+1];
            acc_t sd = (acc_t)Ln[j-1] + (acc_t)Ln[j+1];

            acc_t sab = sa + sb;   // fabric
            acc_t scd = sc + sd;   // fabric

            // Weighted terms in DSPs (2 DSPs per PE)
            acc_t t1 = wa * sab;
#pragma HLS BIND_OP variable=t1 op=mul impl=dsp
            acc_t t2 = wd * scd;
#pragma HLS BIND_OP variable=t2 op=mul impl=dsp

            acc_t cc = (acc_t)Lc[j];
            acc_t t0 = cc >> 1;   // 0.5 * center

            acc_t o  = t0 + t1 + t2;
            Ro[j] = (data_t)o;
        }
    }
}

/* ------------------------------------------------------------------
   stencil_step: one timestep, src → dst.
   86 PEs, 3 chunks per row.
   ------------------------------------------------------------------ */
static void stencil_step(data_t src[NX][NY],
                         data_t dst[NX][NY],
                         const data_t wc,
                         const data_t wa,
                         const data_t wd)
{
#pragma HLS inline off

    data_t Lp[NY], Lc[NY], Ln[NY];
#pragma HLS array_partition variable=Lp dim=1 block factor=NPE
#pragma HLS array_partition variable=Lc dim=1 block factor=NPE
#pragma HLS array_partition variable=Ln dim=1 block factor=NPE

    data_t Ro[NY];
#pragma HLS array_partition variable=Ro dim=1 block factor=NPE

    // Preload row 0 into Lc
    PRELOAD:
    for (int j = 0; j < NY; j++) {
#pragma HLS pipeline II=1
        Lc[j] = src[0][j];
    }

    ROW_LOOP:
    for (int i = 0; i < NX; i++) {
#pragma HLS loop_tripcount min=256 max=256

        // Load next row into Ln
        int inxt = (i + 1 < NX) ? (i + 1) : (NX - 1);
        PREFETCH:
        for (int j = 0; j < NY; j++) {
#pragma HLS pipeline II=1
            Ln[j] = src[inxt][j];
        }

        // Process row in 3 chunks with 86 PEs
        CHUNK_LOOP:
        for (int c = 0; c < NCHUNK; c++) {
#pragma HLS pipeline II=1
            int offset = c * NPE;
            compute_chunk(i, offset, Lp, Lc, Ln, Ro, wa, wd);
        }

        // Write result row
        WRITE_ROW:
        for (int j = 0; j < NY; j++) {
#pragma HLS pipeline II=1
            dst[i][j] = Ro[j];
        }

        // Shift window: Lc -> Lp, Ln -> Lc
        ADVANCE:
        for (int j = 0; j < NY; j++) {
#pragma HLS pipeline II=1
            Lp[j] = Lc[j];
            Lc[j] = Ln[j];
        }
    }
}

/* ------------------------------------------------------------------
   Top-level kernel
   ------------------------------------------------------------------ */
void top_kernel(const data_t A_in[NX][NY],
                data_t A_out[NX][NY])
{
#pragma HLS interface m_axi port=A_in  offset=slave bundle=A_in  depth=65536 max_widen_bitwidth=512
#pragma HLS interface m_axi port=A_out offset=slave bundle=A_out depth=65536 max_widen_bitwidth=512
#pragma HLS interface s_axilite port=return

    static data_t buf0[NX][NY];
    static data_t buf1[NX][NY];
#pragma HLS array_partition variable=buf0 dim=2 block factor=NPE
#pragma HLS array_partition variable=buf1 dim=2 block factor=NPE

    const data_t wc = (data_t)0.50;
    const data_t wa = (data_t)0.10;
    const data_t wd = (data_t)0.025;

    /* LOAD */
    {
        const wide_t *win = (const wide_t *)A_in;
        LOAD:
        for (int idx = 0; idx < NWORDS; idx++) {
#pragma HLS pipeline II=1
            wide_t d = win[idx];
            int i = idx / WPR;
            int w = idx % WPR;
            for (int k = 0; k < PACK; k++) {
#pragma HLS unroll
                data_t v;
                v.range() = d.range(k * EBITS + DBITS - 1, k * EBITS);
                buf0[i][w * PACK + k] = v;
            }
        }
    }

    /* TIMESTEPS */
    TIMESTEP:
    for (int t = 0; t < TSTEPS; t++) {
#pragma HLS loop_tripcount min=30 max=30
        if ((t & 1) == 0)
            stencil_step(buf0, buf1, wc, wa, wd);
        else
            stencil_step(buf1, buf0, wc, wa, wd);
    }

    /* STORE */
    {
        wide_t *wout = (wide_t *)A_out;
        bool fb0 = ((TSTEPS & 1) == 0);

        STORE:
        for (int idx = 0; idx < NWORDS; idx++) {
#pragma HLS pipeline II=1
            int i = idx / WPR;
            int w = idx % WPR;
            wide_t d = 0;
            for (int k = 0; k < PACK; k++) {
#pragma HLS unroll
                data_t v = fb0 ? buf0[i][w * PACK + k]
                               : buf1[i][w * PACK + k];
                d.range(k * EBITS + DBITS - 1, k * EBITS) = v.range();
            }
            wout[idx] = d;
        }
    }
}