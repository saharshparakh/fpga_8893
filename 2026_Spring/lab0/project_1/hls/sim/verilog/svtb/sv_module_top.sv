//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef SV_MODULE_TOP_SV
`define SV_MODULE_TOP_SV


`timescale 1ns/1ps


`include "uvm_macros.svh"
import uvm_pkg::*;
import file_agent_pkg::*;
import top_kernel_subsystem_pkg::*;
`include "top_kernel_subsys_test_sequence_lib.sv"
`include "top_kernel_test_lib.sv"


module sv_module_top;


    misc_interface              misc_if ( .clock(apatb_top_kernel_top.AESL_clock), .reset(apatb_top_kernel_top.AESL_reset) );
    assign misc_if.dut2tb_ap_ready = apatb_top_kernel_top.AESL_inst_top_kernel.ap_ready;
    assign misc_if.dut2tb_ap_done_kernel = apatb_top_kernel_top.AESL_inst_top_kernel.ap_done;
    initial begin
        uvm_config_db #(virtual misc_interface)::set(null, "uvm_test_top.top_env.*", "misc_if", misc_if);
    end


    axi_if #(64,4,8,3,1)  axi_a_if (.clk  (apatb_top_kernel_top.AESL_clock), .rst(apatb_top_kernel_top.AESL_reset));
    assign axi_a_if.AWVALID = apatb_top_kernel_top.a_AWVALID;
    assign apatb_top_kernel_top.a_AWREADY = axi_a_if.AWREADY;
    assign axi_a_if.AWADDR = apatb_top_kernel_top.a_AWADDR;
    assign axi_a_if.AWID = apatb_top_kernel_top.a_AWID;
    assign axi_a_if.AWLEN = apatb_top_kernel_top.a_AWLEN;
    assign axi_a_if.AWSIZE = apatb_top_kernel_top.a_AWSIZE;
    assign axi_a_if.AWBURST = apatb_top_kernel_top.a_AWBURST;
    assign axi_a_if.AWLOCK = apatb_top_kernel_top.a_AWLOCK;
    assign axi_a_if.AWCACHE = apatb_top_kernel_top.a_AWCACHE;
    assign axi_a_if.AWPROT = apatb_top_kernel_top.a_AWPROT;
    assign axi_a_if.AWQOS = apatb_top_kernel_top.a_AWQOS;
    assign axi_a_if.AWREGION = apatb_top_kernel_top.a_AWREGION;
    assign axi_a_if.AWUSER = apatb_top_kernel_top.a_AWUSER;
    assign axi_a_if.WVALID = apatb_top_kernel_top.a_WVALID;
    assign apatb_top_kernel_top.a_WREADY = axi_a_if.WREADY;
    assign axi_a_if.WDATA = apatb_top_kernel_top.a_WDATA;
    assign axi_a_if.WSTRB = apatb_top_kernel_top.a_WSTRB;
    assign axi_a_if.WLAST = apatb_top_kernel_top.a_WLAST;
    assign axi_a_if.WID = apatb_top_kernel_top.a_WID;
    assign axi_a_if.WUSER = apatb_top_kernel_top.a_WUSER;
    assign axi_a_if.ARVALID = apatb_top_kernel_top.a_ARVALID;
    assign apatb_top_kernel_top.a_ARREADY = axi_a_if.ARREADY;
    assign axi_a_if.ARADDR = apatb_top_kernel_top.a_ARADDR;
    assign axi_a_if.ARID = apatb_top_kernel_top.a_ARID;
    assign axi_a_if.ARLEN = apatb_top_kernel_top.a_ARLEN;
    assign axi_a_if.ARSIZE = apatb_top_kernel_top.a_ARSIZE;
    assign axi_a_if.ARBURST = apatb_top_kernel_top.a_ARBURST;
    assign axi_a_if.ARLOCK = apatb_top_kernel_top.a_ARLOCK;
    assign axi_a_if.ARCACHE = apatb_top_kernel_top.a_ARCACHE;
    assign axi_a_if.ARPROT = apatb_top_kernel_top.a_ARPROT;
    assign axi_a_if.ARQOS = apatb_top_kernel_top.a_ARQOS;
    assign axi_a_if.ARREGION = apatb_top_kernel_top.a_ARREGION;
    assign axi_a_if.ARUSER = apatb_top_kernel_top.a_ARUSER;
    assign apatb_top_kernel_top.a_RVALID = axi_a_if.RVALID;
    assign axi_a_if.RREADY = apatb_top_kernel_top.a_RREADY;
    assign apatb_top_kernel_top.a_RDATA = axi_a_if.RDATA;
    assign apatb_top_kernel_top.a_RLAST = axi_a_if.RLAST;
    assign apatb_top_kernel_top.a_RID = axi_a_if.RID;
    assign apatb_top_kernel_top.a_RUSER = axi_a_if.RUSER;
    assign apatb_top_kernel_top.a_RRESP = axi_a_if.RRESP;
    assign apatb_top_kernel_top.a_BVALID = axi_a_if.BVALID;
    assign axi_a_if.BREADY = apatb_top_kernel_top.a_BREADY;
    assign apatb_top_kernel_top.a_BRESP = axi_a_if.BRESP;
    assign apatb_top_kernel_top.a_BID = axi_a_if.BID;
    assign apatb_top_kernel_top.a_BUSER = axi_a_if.BUSER;
    initial begin
        uvm_config_db #( virtual axi_if#(64,4,8,3,1) )::set(null, "uvm_test_top.top_env.axi_master_a.*", "vif", axi_a_if);
    end


    axi_if #(64,4,8,3,1)  axi_b_if (.clk  (apatb_top_kernel_top.AESL_clock), .rst(apatb_top_kernel_top.AESL_reset));
    assign axi_b_if.AWVALID = apatb_top_kernel_top.b_AWVALID;
    assign apatb_top_kernel_top.b_AWREADY = axi_b_if.AWREADY;
    assign axi_b_if.AWADDR = apatb_top_kernel_top.b_AWADDR;
    assign axi_b_if.AWID = apatb_top_kernel_top.b_AWID;
    assign axi_b_if.AWLEN = apatb_top_kernel_top.b_AWLEN;
    assign axi_b_if.AWSIZE = apatb_top_kernel_top.b_AWSIZE;
    assign axi_b_if.AWBURST = apatb_top_kernel_top.b_AWBURST;
    assign axi_b_if.AWLOCK = apatb_top_kernel_top.b_AWLOCK;
    assign axi_b_if.AWCACHE = apatb_top_kernel_top.b_AWCACHE;
    assign axi_b_if.AWPROT = apatb_top_kernel_top.b_AWPROT;
    assign axi_b_if.AWQOS = apatb_top_kernel_top.b_AWQOS;
    assign axi_b_if.AWREGION = apatb_top_kernel_top.b_AWREGION;
    assign axi_b_if.AWUSER = apatb_top_kernel_top.b_AWUSER;
    assign axi_b_if.WVALID = apatb_top_kernel_top.b_WVALID;
    assign apatb_top_kernel_top.b_WREADY = axi_b_if.WREADY;
    assign axi_b_if.WDATA = apatb_top_kernel_top.b_WDATA;
    assign axi_b_if.WSTRB = apatb_top_kernel_top.b_WSTRB;
    assign axi_b_if.WLAST = apatb_top_kernel_top.b_WLAST;
    assign axi_b_if.WID = apatb_top_kernel_top.b_WID;
    assign axi_b_if.WUSER = apatb_top_kernel_top.b_WUSER;
    assign axi_b_if.ARVALID = apatb_top_kernel_top.b_ARVALID;
    assign apatb_top_kernel_top.b_ARREADY = axi_b_if.ARREADY;
    assign axi_b_if.ARADDR = apatb_top_kernel_top.b_ARADDR;
    assign axi_b_if.ARID = apatb_top_kernel_top.b_ARID;
    assign axi_b_if.ARLEN = apatb_top_kernel_top.b_ARLEN;
    assign axi_b_if.ARSIZE = apatb_top_kernel_top.b_ARSIZE;
    assign axi_b_if.ARBURST = apatb_top_kernel_top.b_ARBURST;
    assign axi_b_if.ARLOCK = apatb_top_kernel_top.b_ARLOCK;
    assign axi_b_if.ARCACHE = apatb_top_kernel_top.b_ARCACHE;
    assign axi_b_if.ARPROT = apatb_top_kernel_top.b_ARPROT;
    assign axi_b_if.ARQOS = apatb_top_kernel_top.b_ARQOS;
    assign axi_b_if.ARREGION = apatb_top_kernel_top.b_ARREGION;
    assign axi_b_if.ARUSER = apatb_top_kernel_top.b_ARUSER;
    assign apatb_top_kernel_top.b_RVALID = axi_b_if.RVALID;
    assign axi_b_if.RREADY = apatb_top_kernel_top.b_RREADY;
    assign apatb_top_kernel_top.b_RDATA = axi_b_if.RDATA;
    assign apatb_top_kernel_top.b_RLAST = axi_b_if.RLAST;
    assign apatb_top_kernel_top.b_RID = axi_b_if.RID;
    assign apatb_top_kernel_top.b_RUSER = axi_b_if.RUSER;
    assign apatb_top_kernel_top.b_RRESP = axi_b_if.RRESP;
    assign apatb_top_kernel_top.b_BVALID = axi_b_if.BVALID;
    assign axi_b_if.BREADY = apatb_top_kernel_top.b_BREADY;
    assign apatb_top_kernel_top.b_BRESP = axi_b_if.BRESP;
    assign apatb_top_kernel_top.b_BID = axi_b_if.BID;
    assign apatb_top_kernel_top.b_BUSER = axi_b_if.BUSER;
    initial begin
        uvm_config_db #( virtual axi_if#(64,4,8,3,1) )::set(null, "uvm_test_top.top_env.axi_master_b.*", "vif", axi_b_if);
    end


    axi_if #(64,4,8,3,1)  axi_sum_if (.clk  (apatb_top_kernel_top.AESL_clock), .rst(apatb_top_kernel_top.AESL_reset));
    assign axi_sum_if.AWVALID = apatb_top_kernel_top.sum_AWVALID;
    assign apatb_top_kernel_top.sum_AWREADY = axi_sum_if.AWREADY;
    assign axi_sum_if.AWADDR = apatb_top_kernel_top.sum_AWADDR;
    assign axi_sum_if.AWID = apatb_top_kernel_top.sum_AWID;
    assign axi_sum_if.AWLEN = apatb_top_kernel_top.sum_AWLEN;
    assign axi_sum_if.AWSIZE = apatb_top_kernel_top.sum_AWSIZE;
    assign axi_sum_if.AWBURST = apatb_top_kernel_top.sum_AWBURST;
    assign axi_sum_if.AWLOCK = apatb_top_kernel_top.sum_AWLOCK;
    assign axi_sum_if.AWCACHE = apatb_top_kernel_top.sum_AWCACHE;
    assign axi_sum_if.AWPROT = apatb_top_kernel_top.sum_AWPROT;
    assign axi_sum_if.AWQOS = apatb_top_kernel_top.sum_AWQOS;
    assign axi_sum_if.AWREGION = apatb_top_kernel_top.sum_AWREGION;
    assign axi_sum_if.AWUSER = apatb_top_kernel_top.sum_AWUSER;
    assign axi_sum_if.WVALID = apatb_top_kernel_top.sum_WVALID;
    assign apatb_top_kernel_top.sum_WREADY = axi_sum_if.WREADY;
    assign axi_sum_if.WDATA = apatb_top_kernel_top.sum_WDATA;
    assign axi_sum_if.WSTRB = apatb_top_kernel_top.sum_WSTRB;
    assign axi_sum_if.WLAST = apatb_top_kernel_top.sum_WLAST;
    assign axi_sum_if.WID = apatb_top_kernel_top.sum_WID;
    assign axi_sum_if.WUSER = apatb_top_kernel_top.sum_WUSER;
    assign axi_sum_if.ARVALID = apatb_top_kernel_top.sum_ARVALID;
    assign apatb_top_kernel_top.sum_ARREADY = axi_sum_if.ARREADY;
    assign axi_sum_if.ARADDR = apatb_top_kernel_top.sum_ARADDR;
    assign axi_sum_if.ARID = apatb_top_kernel_top.sum_ARID;
    assign axi_sum_if.ARLEN = apatb_top_kernel_top.sum_ARLEN;
    assign axi_sum_if.ARSIZE = apatb_top_kernel_top.sum_ARSIZE;
    assign axi_sum_if.ARBURST = apatb_top_kernel_top.sum_ARBURST;
    assign axi_sum_if.ARLOCK = apatb_top_kernel_top.sum_ARLOCK;
    assign axi_sum_if.ARCACHE = apatb_top_kernel_top.sum_ARCACHE;
    assign axi_sum_if.ARPROT = apatb_top_kernel_top.sum_ARPROT;
    assign axi_sum_if.ARQOS = apatb_top_kernel_top.sum_ARQOS;
    assign axi_sum_if.ARREGION = apatb_top_kernel_top.sum_ARREGION;
    assign axi_sum_if.ARUSER = apatb_top_kernel_top.sum_ARUSER;
    assign apatb_top_kernel_top.sum_RVALID = axi_sum_if.RVALID;
    assign axi_sum_if.RREADY = apatb_top_kernel_top.sum_RREADY;
    assign apatb_top_kernel_top.sum_RDATA = axi_sum_if.RDATA;
    assign apatb_top_kernel_top.sum_RLAST = axi_sum_if.RLAST;
    assign apatb_top_kernel_top.sum_RID = axi_sum_if.RID;
    assign apatb_top_kernel_top.sum_RUSER = axi_sum_if.RUSER;
    assign apatb_top_kernel_top.sum_RRESP = axi_sum_if.RRESP;
    assign apatb_top_kernel_top.sum_BVALID = axi_sum_if.BVALID;
    assign axi_sum_if.BREADY = apatb_top_kernel_top.sum_BREADY;
    assign apatb_top_kernel_top.sum_BRESP = axi_sum_if.BRESP;
    assign apatb_top_kernel_top.sum_BID = axi_sum_if.BID;
    assign apatb_top_kernel_top.sum_BUSER = axi_sum_if.BUSER;
    initial begin
        uvm_config_db #( virtual axi_if#(64,4,8,3,1) )::set(null, "uvm_test_top.top_env.axi_master_sum.*", "vif", axi_sum_if);
    end


    axi_if #(6,4,4,3,1)  axi_control_if (.clk  (apatb_top_kernel_top.AESL_clock), .rst(apatb_top_kernel_top.AESL_reset));
    assign apatb_top_kernel_top.control_AWADDR = axi_control_if.AWADDR;
    assign apatb_top_kernel_top.control_AWVALID = axi_control_if.AWVALID;
    assign axi_control_if.AWREADY = apatb_top_kernel_top.control_AWREADY;
    assign apatb_top_kernel_top.control_WVALID = axi_control_if.WVALID;
    assign axi_control_if.WREADY = apatb_top_kernel_top.control_WREADY;
    assign apatb_top_kernel_top.control_WDATA = axi_control_if.WDATA;
    assign apatb_top_kernel_top.control_WSTRB = axi_control_if.WSTRB;
    assign apatb_top_kernel_top.control_ARADDR = axi_control_if.ARADDR;
    assign apatb_top_kernel_top.control_ARVALID = axi_control_if.ARVALID;
    assign axi_control_if.ARREADY = apatb_top_kernel_top.control_ARREADY;
    assign axi_control_if.RVALID = apatb_top_kernel_top.control_RVALID;
    assign apatb_top_kernel_top.control_RREADY = axi_control_if.RREADY;
    assign axi_control_if.RDATA = apatb_top_kernel_top.control_RDATA;
    assign axi_control_if.RRESP = apatb_top_kernel_top.control_RRESP;
    assign axi_control_if.BVALID = apatb_top_kernel_top.control_BVALID;
    assign apatb_top_kernel_top.control_BREADY = axi_control_if.BREADY;
    assign axi_control_if.BRESP = apatb_top_kernel_top.control_BRESP;
    assign axi_control_if.BID = 0;
    assign axi_control_if.RID = 0;
    assign axi_control_if.RLAST = 1;
    initial begin
        uvm_config_db #( virtual axi_if#(6,4,4,3,1) )::set(null, "uvm_test_top.top_env.axi_lite_control.*", "vif", axi_control_if);
    end


    initial begin
        run_test();
    end
endmodule
`endif
