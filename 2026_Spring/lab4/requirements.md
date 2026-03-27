## SAHARSH PARAKH 

# Lab 4: Open-Ended Accelerator Design Requirements

## 1. Baseline Implementation (Sequential)
* **Kernel Count:** ≥ 5 distinct functional kernels.
* **Kernel Length:** ≥ 30 lines of executable code per kernel.
* **Total Volume:** ≥ 200 lines of benchmark code.
* **Logic Style:** Straightforward, sequential C++ code.
* **Pragmas:** Zero usage of `#pragma HLS` allowed.
* **Algorithm:** Must be a meaningful, nontrivial computation.
* **Dependencies:** Must have nontrivial data dependencies between stages.
* **Arithmetic:** Mandatory use of `ap_fixed` for all math.
* **Data Types:** Must be identical to the optimized version.
* **Integrity:** No artificial delays or empty loops to slow it down.
* **Integrity:** No manual buffering or restructuring to intentionally slow the code.
* **Integrity:** No dummy computation or useless code allowed.
* **Penalty:** Violation of baseline rules results in zero credit for the lab.

## 2. Verification & Correctness
* **Accuracy:** Must preserve exact functional correctness relative to baseline.
* **Consistency:** Computation must not change between baseline and optimized.
* **Testbench:** Must include host code verifying both implementations.
* **Error Tolerance:** Verification passes if HW output is within ≤ 1% error of baseline.
* **Reporting:** Console must print average error percentage for the test run.
* **Simulation:** Must successfully pass C/RTL Co-simulation.
* **Exit Status:** Testbench returns 0 only if error threshold is met.

## 3. Optimized Implementation (FPGA)
* **Optimization:** Use `PIPELINE` to reduce Initiation Interval.
* **Optimization:** Use `DATAFLOW` for task-level parallelism.
* **Optimization:** Use `STREAMING` for inter-kernel communication.
* **Optimization:** Use `BUFFERING` (BRAM/Local memory) to manage data.
* **Optimization:** Use `LOOP RESTRUCTURING` to improve hardware mapping.
* **Optimization:** Use `PARALLELISM` (Unroll/Partition) to increase throughput.
* **Refactoring:** Free to refactor code structure between baseline and optimized.
* **Implementation:** Must successfully complete C Synthesis.
* **Implementation:** Must successfully complete RTL Place and Route.
* **Timing:** Must meet timing with positive slack on the {xczu3eg}.
* **Metric:** Final ranking is based on Cycle Count from Co-simulation.
* **Speedup:** (Baseline Cycles / Optimized Cycles) must be > 1.0.