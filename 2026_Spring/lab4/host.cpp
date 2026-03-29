#include "dcl.h"
#include <iostream>
#include <vector>
#include <cmath>
#include <cstdlib>

using namespace std;

// Golden functions
void golden_kernel(
    const pixel_t input_rgb[NUM_IMAGES * IMG_W * IMG_H * 3],
    hash_t target_hash,
    TopKResult out_topk[TOP_K]
) {
    // initialize
    for(int i = 0; i < TOP_K; i++) {
        out_topk[i].id = -1;
        out_topk[i].distance = 9999;
    }

    dct_t cos_lut[N_DCT][N_DCT];
    for (int x = 0; x < N_DCT; x++) {
        for (int u = 0; u < N_DCT; u++) {
            float val = cos( 3.14159265358979323846 * (2.0 * x + 1.0) * u / (2.0 * N_DCT) );
            cos_lut[x][u] = dct_t(val);
        }
    }

    for (int img = 0; img < NUM_IMAGES; img++) {
        dct_t img_gray[N_DCT][N_DCT];
        
        // Kernel 1: preprocess
        for (int r = 0; r < N_DCT; r++) {
            for (int c = 0; c < N_DCT; c++) {
                dct_t sum = 0;
                for (int br = 0; br < BOX_SIZE; br++) {
                    for (int bc = 0; bc < BOX_SIZE; bc++) {
                        int pixel_r = r * BOX_SIZE + br;
                        int pixel_c = c * BOX_SIZE + bc;
                        int idx = img * IMG_H * IMG_W * 3 + (pixel_r * IMG_W + pixel_c) * 3;
                        
                        dct_t red = input_rgb[idx];
                        dct_t green = input_rgb[idx+1];
                        dct_t blue = input_rgb[idx+2];
                        
                        sum += red * dct_t(0.299) + green * dct_t(0.587) + blue * dct_t(0.114);
                    }
                }
                img_gray[r][c] = sum / dct_t(BOX_SIZE * BOX_SIZE);
            }
        }
        
        // Kernel 2: row-dct
        dct_t img_rowdct[N_DCT][N_DCT];
        for (int r = 0; r < N_DCT; r++) {
            for (int u = 0; u < N_DCT; u++) {
                dct_t sum = 0;
                for (int c = 0; c < N_DCT; c++) {
                    sum += img_gray[r][c] * cos_lut[c][u];
                }
                dct_t alpha = (u == 0) ? dct_t(0.70710678) : dct_t(1.0);
                img_rowdct[r][u] = sum * alpha;
            }
        }
        
        // Kernel 3: col-dct
        dct_t img_coldct[N_DCT][N_DCT];
        for (int c = 0; c < N_DCT; c++) {
            for (int v = 0; v < N_DCT; v++) {
                dct_t sum = 0;
                for (int r = 0; r < N_DCT; r++) {
                    sum += img_rowdct[r][c] * cos_lut[r][v];
                }
                dct_t alpha = (v == 0) ? dct_t(0.70710678) : dct_t(1.0);
                img_coldct[v][c] = sum * alpha;
            }
        }
        
        // Kernel 4: hash
        dct_t sum = 0;
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                sum += img_coldct[r][c];
            }
        }
        dct_t mean = sum / dct_t(64);
        
        hash_t hash_val = 0;
        int bit_pos = 0;
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                if (img_coldct[r][c] > mean) {
                    hash_val |= ((hash_t)1 << bit_pos);
                }
                bit_pos++;
            }
        }
        
        // Kernel 5: ranker
        hash_t diff = hash_val ^ target_hash;
        int dist = 0;
        for(int b = 0; b < 64; b++) {
            if((diff >> b) & 1) dist++;
        }
        
        if (dist < out_topk[TOP_K-1].distance) {
            int insert_idx = TOP_K - 1;
            while (insert_idx > 0 && dist < out_topk[insert_idx-1].distance) {
                insert_idx--;
            }
            for (int s = TOP_K - 1; s > insert_idx; s--) {
                out_topk[s] = out_topk[s-1];
            }
            out_topk[insert_idx].id = img;
            out_topk[insert_idx].distance = dist;
        }
    }
}

void init_input(pixel_t *input, hash_t &target_hash) {
    srand(12345);
    for(int i = 0; i < NUM_IMAGES * IMG_H * IMG_W * 3; i++) {
        input[i] = rand() % 256;
    }
    target_hash = 0x8F3B2C9E4A1D5F7CULL;
}

int main() {
    cout << "Allocating memory buffers for HW logic..." << endl;
    pixel_t *input_rgb = new pixel_t[NUM_IMAGES * IMG_W * IMG_H * 3];
    dct_t *inter1_gray = new dct_t[NUM_IMAGES * N_DCT * N_DCT];
    dct_t *inter2_rowdct = new dct_t[NUM_IMAGES * N_DCT * N_DCT];
    dct_t *inter3_coldct = new dct_t[NUM_IMAGES * N_DCT * N_DCT];
    hash_t *inter4_hash = new hash_t[NUM_IMAGES];
    
    hash_t target_hash;
    TopKResult hw_topk[TOP_K];
    TopKResult sw_topk[TOP_K];
    
    cout << "Initializing random inputs..." << endl;
    init_input(input_rgb, target_hash);
    
    cout << "Running HW kernel (csim)..." << endl;
    top_kernel(input_rgb, inter1_gray, inter2_rowdct, inter3_coldct, inter4_hash, target_hash, hw_topk);
    
    cout << "Running SW golden model..." << endl;
    golden_kernel(input_rgb, target_hash, sw_topk);
    
    int errors = 0;
    cout << "Comparing results (error tolerance 1%)..." << endl;
    for (int i = 0; i < TOP_K; i++) {
        if (hw_topk[i].id != sw_topk[i].id || hw_topk[i].distance != sw_topk[i].distance) {
            errors++;
            if(errors <= 10) {
                cout << "Mismatch at rank " << i << ": ";
                cout << "HW(id=" << hw_topk[i].id << ", d=" << hw_topk[i].distance << ") vs ";
                cout << "SW(id=" << sw_topk[i].id << ", d=" << sw_topk[i].distance << ")" << endl;
            }
        }
    }
    
    delete[] input_rgb;
    delete[] inter1_gray;
    delete[] inter2_rowdct;
    delete[] inter3_coldct;
    delete[] inter4_hash;
    
    if (errors == 0) {
        cout << "SUCCESS! 0 mismatches found. Hardware functionality matches golden model perfectly." << endl;
        return 0;
    } else {
        cout << "FAILED! " << errors << " mismatches between HW and SW." << endl;
        return 1;
    }
}
