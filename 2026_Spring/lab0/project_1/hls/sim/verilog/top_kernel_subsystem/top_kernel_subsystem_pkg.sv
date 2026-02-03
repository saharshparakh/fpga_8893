//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`timescale 1ns/1ps 

`ifndef TOP_KERNEL_SUBSYSTEM_PKG__SV          
    `define TOP_KERNEL_SUBSYSTEM_PKG__SV      
                                                     
    package top_kernel_subsystem_pkg;               
                                                     
        import uvm_pkg::*;                           
        import file_agent_pkg::*;                    
        import axi_pkg::*;
                                                     
        `include "uvm_macros.svh"                  
                                                     
        `include "top_kernel_config.sv"           
        `include "top_kernel_reference_model.sv"  
        `include "top_kernel_scoreboard.sv"       
        `include "top_kernel_subsystem_monitor.sv"
        `include "top_kernel_virtual_sequencer.sv"
        `include "top_kernel_pkg_sequence_lib.sv" 
        `include "top_kernel_env.sv"              
                                                     
    endpackage                                       
                                                     
`endif                                               
