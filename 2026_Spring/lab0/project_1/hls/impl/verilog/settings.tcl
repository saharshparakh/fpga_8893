# ==============================================================
# Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1.1 (64-bit)
# Tool Version Limit: 2025.05
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
# 
# ==============================================================
#
# Settings for Vivado implementation flow
#
set top_module top_kernel
set language verilog
set family zynquplus
set device xczu3eg
set package -sbva484
set speed -1-e
set clock ap_clk
set fsm_ext "off"

# For customizing the implementation flow
set add_io_buffers false ;# true|false
