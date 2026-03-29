# Project: Perceptual Image Similarity Ranking (pHash)

### 1. Problem Description
We are building a hardware-accelerated engine to solve the **Visual Deduplication Problem**. In high-volume data environments, identifying "similar" images (not just bit-identical ones) is computationally expensive. We are offloading this multi-stage pipeline—consisting of spatial reduction, frequency analysis (DCT), and Hamming distance ranking—to an FPGA to achieve a massive speedup over a sequential software baseline.

---

### 2. Baseline Architecture Plan

* **Memory Interface:** All data is accessed via a single `m_axi` port connected to DDR memory.
* **Data Retrieval:** Use **Scalar AXI Mapping**; fetch every pixel/byte individually via pointer indexing (e.g., `input[i]`) inside the innermost loops.
* **No Buffering:** Strictly prohibited to use BRAM or local arrays for image caching; all kernels must read/write directly to DDR via the AXI master.
* **Arithmetic:** Mandatory use of `ap_fixed<24, 12>` (defined in `dcl.h`) to establish the high-precision "Golden" numerical reference.
* **Execution Flow:** Strictly sequential execution; Kernel $n$ must write its entire output to DDR before Kernel $n+1$ begins.
* **Batch Processing:** Process a batch of 5120 images one-by-one inside a top-level `for` loop.
* **Pragmas:** Zero usage of `#pragma HLS` (no pipeline, no unroll, no dataflow) in the baseline synthesis.
* **Code Volume:** Each of the 5 kernels must contain $\ge 30$ lines of executable code to meet the "meaningful computation" requirement.
* **Total Volume:** The total benchmark code must exceed 200 lines (excluding headers).

**The 5-Kernel Pipeline:**
* **Kernel 1 (Preprocess):** Read raw RGB pixels from AXI, calculate grayscale, and box-average to an $N \times N$ grid ($16 \le N \le 32$).
* **Kernel 2 (Row-DCT):** Perform a 1D-DCT on each row using a triple-nested loop ($N \times N \times N$) to calculate frequency coefficients.
* **Kernel 3 (Col-DCT):** Perform a 1D-DCT on each column to complete the frequency transformation.
* **K3 Bottleneck:** Access DDR memory in a non-contiguous **"column-major" pattern** to maximize AXI latency and bus wait-states.
* **Kernel 4 (Hash):** Calculate the mean of the DCT coefficients and generate a 64-bit `ap_uint<64>` perceptual fingerprint. (Logic: Iterate through the $8 \times 8$ low-frequency corner; if `coefficient[i] > mean`, set the hash bit to `1`).
* **Kernel 5 (Ranker):** Calculate the Hamming Distance between the current hash and a pre-loaded Target Hash using a manual loop to count set bits.
* **K5 Sorting:** Maintain a sorted "Top 50" list using a standard **Insertion Sort** algorithm with manual array shifting in a loop.
* **Final Output:** Write the resulting Top 50 Image IDs and their calculated distances back to DDR.

---

### 3. Project Structure & File Deliverables

The project will be split into the following specific files to meet grading requirements:

#### A. Codebase
* **`dcl.h`**: The common header file containing `ap_fixed` definitions, struct definitions (for Top-K results), and function prototypes.
* **`host.cpp`**: The testbench and software reference. Contains the **"Golden Kernel"** implementation of the baseline algorithm. It also houses the `main()` function which feeds data to `top.cpp` and compares the hardware output against the Golden Kernel for the 1% error tolerance.
* **`top.cpp`**: The HLS target file. (For the final submission, this will contain the Optimized Hardware Kernel demonstrating a speedup of > 1.1x).
* **`makefile`**: Standard C++ simulation makefile to compile `host.cpp` and `top.cpp`.
* **`script.tcl`**: The Tcl script used to drive Vitis HLS synthesis, co-simulation, and export.

#### B. Documentation & Reports
* **`baseline_explanation.pdf`**:
  * **Use-Case (Min 100 words):** Explanation of Perceptual Hashing for image deduplication.
  * **Acceleration Benefit (Min 100 words):** Why moving from $O(N^4)$ scalar CPU memory access to parallel FPGA stream processing is beneficial.
  * **Baseline Latency:** Calculated as $(Cycle\_Count \times Clock\_Period)$.
  * **Screenshots:** Co-sim cycle report and final post-implementation clock period for the baseline.
* **`report.pdf`**:
  * Baseline Latency value.
  * Screenshot of HLS synthesized latency (Optimized).
  * Screenshot of C/RTL co-simulation latency and clock period (Optimized).
  * Screenshot of post-implementation resource utilization showing LUT, FF, BRAM, and DSP usage.
  * **Speedup Ratio:** Computed as $(Baseline\_Latency / Optimized\_Latency)$. Note: The design must successfully complete synthesis, placement, and routing without errors.

---

### 4. Accuracy & Success Criteria
* **Ranking Integrity:** The hardware implementation (`top.cpp`) must result in the **exact same Top 50 Image IDs** as the Golden Kernel (`host.cpp`).
* **Numerical Tolerance:** The calculated Hamming distances in `top.cpp` must stay within a **1% error margin** of `host.cpp`.
* **Speedup Logic:** Accuracy is treated as a budget; bit-widths in the optimized version may be reduced to save resources/cycles as long as the Top 50 IDs remain correct.