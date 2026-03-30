# HLS Project Structural Template & Style Guide

## Overview
This document defines the strict structural, syntactical, and verification requirements for standard Vitis HLS lab submissions. All generated code must adhere to these patterns to ensure successful synthesis, co-simulation, and grading. 

The project consists of three core files: `dcl.h` (definitions), `host.cpp` (testbench and golden model), and `top.cpp` (synthesizable hardware).

---

## 1. Header File Structure (`dcl.h`)
**Purpose:** Centralized definitions, macros, and fixed-point type declarations used by both the host and the hardware.

**Required Elements:**
* **Header Guards:** Must use standard `#ifndef`, `#define`, `#endif` wrappers.
* **Includes:** Must include `<ap_fixed.h>` and standard integer libraries (e.g., `<cstdint>`).
* **System Macros:** Define all dataset sizes, dimensions, and algorithmic constants (e.g., `N`, `BLOCK_SIZE`) as `#define` macros.
* **Fixed-Point Typedefs:** All algorithmic data types must be heavily typed using `ap_fixed`. 
    * *Rule:* You must explicitly define rounding and saturation modes for stability: `typedef ap_fixed<W, I, AP_RND, AP_SAT> type_name;`
* **Top-Level Prototype:** Declare the signature for `top_kernel`. Pointers or arrays mapping to AXI interfaces should be clearly defined.

---

## 2. Testbench & Golden Model Structure (`host.cpp`)
**Purpose:** Provides the software-only "Golden Kernel" for baseline accuracy and the `main()` function to verify the hardware implementation.

**Required Elements:**
* **Helper Functions:** Any mathematical helpers (like absolute value or clamping) should be declared `static inline`.
* **Golden Kernel (`golden_kernel`):** * Must be a pure C++ implementation of the algorithm.
    * Takes the same inputs as the hardware kernel.
    * Operates using the `ap_fixed` types defined in `dcl.h`.
* **Initialization (`init_input`):** A dedicated function to populate input arrays with deterministic pseudo-random data or specific test patterns.
* **Main Execution Flow (`main`):**
    1.  **Allocation:** Declare static arrays for inputs, hardware outputs, and golden outputs.
    2.  **Initialization:** Call `init_input`.
    3.  **Execution:** Call `top_kernel` (hardware) and `golden_kernel` (software).
    4.  **Verification (The 1% Rule):** Iterate through the output arrays and compare the hardware output to the golden output.
        * *Comparison Logic:* Convert `ap_fixed` outputs to standard floats/doubles for the error calculation.
        * *Tolerance Formula:* `abs(hw_val - gold_val) > abs(gold_val) * 0.01`
    5.  **Reporting:** Track the number of errors. Print the first few mismatches (e.g., up to 10) to aid debugging. Return `0` if `errors == 0`, else return `1`.

---

## 3. Hardware Accelerator Structure (`top.cpp`)
**Purpose:** The synthesizable HLS design containing the accelerated kernels and mandatory interface pragmas.

**Required Elements:**
* **Includes:** Must include `"dcl.h"`.
* **Helper Functions:** Include synthesizable versions of any helpers used (e.g., `abs_fp`, `clamp_fp`). Must be `static inline`.
* **Top-Level Function (`top_kernel`):**
    * **Mandatory Pragmas:** Immediately inside the function body, define the AXI interfaces.
        * For array/pointer inputs and outputs: `#pragma HLS interface m_axi port=<name> offset=slave bundle=<bundle_name>`
        * For the return port: `#pragma HLS interface s_axilite port=return`
    * **Constants:** Define algorithmic constants locally using the `ap_fixed` typedefs.
* **Kernel Separation (The Multi-Stage DAG):**
    * The algorithm must be divided into clearly defined, sequential stages (e.g., K0, K1, K2...).
    * *Constraint Check:* Ensure each distinct stage meets the lab's line-count and complexity requirements as defined in the project plan.
    * *Data Handoff:* In standard implementations, stages pass data via static internal arrays (e.g., `static data_t s0[N];`). *(Note: Refer strictly to the active `plan.md` to see if internal buffering is permitted or if direct AXI reads are forced for the baseline).*