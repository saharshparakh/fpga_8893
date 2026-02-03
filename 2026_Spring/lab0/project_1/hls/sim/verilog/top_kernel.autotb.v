// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
`timescale 1ns/1ps


`define AUTOTB_DUT      top_kernel
`define AUTOTB_DUT_INST AESL_inst_top_kernel
`define AUTOTB_TOP      apatb_top_kernel_top
`define AUTOTB_LAT_RESULT_FILE "top_kernel.result.lat.rb"
`define AUTOTB_PER_RESULT_TRANS_FILE "top_kernel.performance.result.transaction.xml"
`define AUTOTB_TOP_INST AESL_inst_apatb_top_kernel_top
`define AUTOTB_MAX_ALLOW_LATENCY  15000000
`define AUTOTB_CLOCK_PERIOD_DIV2 5.00

`define AESL_DEPTH_a 1
`define AESL_DEPTH_b 1
`define AESL_DEPTH_sum 1
`define AESL_DEPTH_a_r 1
`define AESL_DEPTH_b_r 1
`define AESL_DEPTH_sum_r 1
`define AUTOTB_TVIN_a  "../tv/cdatafile/c.top_kernel.autotvin_a.dat"
`define AUTOTB_TVIN_b  "../tv/cdatafile/c.top_kernel.autotvin_b.dat"
`define AUTOTB_TVIN_a_r  "../tv/cdatafile/c.top_kernel.autotvin_a_r.dat"
`define AUTOTB_TVIN_b_r  "../tv/cdatafile/c.top_kernel.autotvin_b_r.dat"
`define AUTOTB_TVIN_sum_r  "../tv/cdatafile/c.top_kernel.autotvin_sum_r.dat"
`define AUTOTB_TVIN_a_out_wrapc  "../tv/rtldatafile/rtl.top_kernel.autotvin_a.dat"
`define AUTOTB_TVIN_b_out_wrapc  "../tv/rtldatafile/rtl.top_kernel.autotvin_b.dat"
`define AUTOTB_TVIN_a_r_out_wrapc  "../tv/rtldatafile/rtl.top_kernel.autotvin_a_r.dat"
`define AUTOTB_TVIN_b_r_out_wrapc  "../tv/rtldatafile/rtl.top_kernel.autotvin_b_r.dat"
`define AUTOTB_TVIN_sum_r_out_wrapc  "../tv/rtldatafile/rtl.top_kernel.autotvin_sum_r.dat"
`define AUTOTB_TVOUT_sum  "../tv/cdatafile/c.top_kernel.autotvout_sum.dat"
`define AUTOTB_TVOUT_sum_out_wrapc  "../tv/rtldatafile/rtl.top_kernel.autotvout_sum.dat"
module `AUTOTB_TOP;

parameter AUTOTB_TRANSACTION_NUM = 1;
parameter PROGRESS_TIMEOUT = 10000000;
parameter LATENCY_ESTIMATION = 117;
parameter LENGTH_a = 100;
parameter LENGTH_a_r = 1;
parameter LENGTH_b = 100;
parameter LENGTH_b_r = 1;
parameter LENGTH_sum = 100;
parameter LENGTH_sum_r = 1;

reg AESL_clock;
reg rst;
reg dut_rst;
reg start;
reg ce;
reg tb_continue;
wire AESL_start;
wire AESL_reset;
wire AESL_ce;
wire AESL_ready;
wire AESL_idle;
wire AESL_continue;
wire AESL_done;
reg AESL_done_delay = 0;
reg AESL_done_delay2 = 0;
reg AESL_ready_delay = 0;
wire ready;
wire ready_wire;
wire [5 : 0] control_AWADDR;
wire  control_AWVALID;
wire  control_AWREADY;
wire  control_WVALID;
wire  control_WREADY;
wire [31 : 0] control_WDATA;
wire [3 : 0] control_WSTRB;
wire [5 : 0] control_ARADDR;
wire  control_ARVALID;
wire  control_ARREADY;
wire  control_RVALID;
wire  control_RREADY;
wire [31 : 0] control_RDATA;
wire [1 : 0] control_RRESP;
wire  control_BVALID;
wire  control_BREADY;
wire [1 : 0] control_BRESP;
wire  control_INTERRUPT;
wire  a_AWVALID;
wire  a_AWREADY;
wire [63 : 0] a_AWADDR;
wire [0 : 0] a_AWID;
wire [7 : 0] a_AWLEN;
wire [2 : 0] a_AWSIZE;
wire [1 : 0] a_AWBURST;
wire [1 : 0] a_AWLOCK;
wire [3 : 0] a_AWCACHE;
wire [2 : 0] a_AWPROT;
wire [3 : 0] a_AWQOS;
wire [3 : 0] a_AWREGION;
wire [0 : 0] a_AWUSER;
wire  a_WVALID;
wire  a_WREADY;
wire [31 : 0] a_WDATA;
wire [3 : 0] a_WSTRB;
wire  a_WLAST;
wire [0 : 0] a_WID;
wire [0 : 0] a_WUSER;
wire  a_ARVALID;
wire  a_ARREADY;
wire [63 : 0] a_ARADDR;
wire [0 : 0] a_ARID;
wire [7 : 0] a_ARLEN;
wire [2 : 0] a_ARSIZE;
wire [1 : 0] a_ARBURST;
wire [1 : 0] a_ARLOCK;
wire [3 : 0] a_ARCACHE;
wire [2 : 0] a_ARPROT;
wire [3 : 0] a_ARQOS;
wire [3 : 0] a_ARREGION;
wire [0 : 0] a_ARUSER;
wire  a_RVALID;
wire  a_RREADY;
wire [31 : 0] a_RDATA;
wire  a_RLAST;
wire [0 : 0] a_RID;
wire [0 : 0] a_RUSER;
wire [1 : 0] a_RRESP;
wire  a_BVALID;
wire  a_BREADY;
wire [1 : 0] a_BRESP;
wire [0 : 0] a_BID;
wire [0 : 0] a_BUSER;
wire  b_AWVALID;
wire  b_AWREADY;
wire [63 : 0] b_AWADDR;
wire [0 : 0] b_AWID;
wire [7 : 0] b_AWLEN;
wire [2 : 0] b_AWSIZE;
wire [1 : 0] b_AWBURST;
wire [1 : 0] b_AWLOCK;
wire [3 : 0] b_AWCACHE;
wire [2 : 0] b_AWPROT;
wire [3 : 0] b_AWQOS;
wire [3 : 0] b_AWREGION;
wire [0 : 0] b_AWUSER;
wire  b_WVALID;
wire  b_WREADY;
wire [31 : 0] b_WDATA;
wire [3 : 0] b_WSTRB;
wire  b_WLAST;
wire [0 : 0] b_WID;
wire [0 : 0] b_WUSER;
wire  b_ARVALID;
wire  b_ARREADY;
wire [63 : 0] b_ARADDR;
wire [0 : 0] b_ARID;
wire [7 : 0] b_ARLEN;
wire [2 : 0] b_ARSIZE;
wire [1 : 0] b_ARBURST;
wire [1 : 0] b_ARLOCK;
wire [3 : 0] b_ARCACHE;
wire [2 : 0] b_ARPROT;
wire [3 : 0] b_ARQOS;
wire [3 : 0] b_ARREGION;
wire [0 : 0] b_ARUSER;
wire  b_RVALID;
wire  b_RREADY;
wire [31 : 0] b_RDATA;
wire  b_RLAST;
wire [0 : 0] b_RID;
wire [0 : 0] b_RUSER;
wire [1 : 0] b_RRESP;
wire  b_BVALID;
wire  b_BREADY;
wire [1 : 0] b_BRESP;
wire [0 : 0] b_BID;
wire [0 : 0] b_BUSER;
wire  sum_AWVALID;
wire  sum_AWREADY;
wire [63 : 0] sum_AWADDR;
wire [0 : 0] sum_AWID;
wire [7 : 0] sum_AWLEN;
wire [2 : 0] sum_AWSIZE;
wire [1 : 0] sum_AWBURST;
wire [1 : 0] sum_AWLOCK;
wire [3 : 0] sum_AWCACHE;
wire [2 : 0] sum_AWPROT;
wire [3 : 0] sum_AWQOS;
wire [3 : 0] sum_AWREGION;
wire [0 : 0] sum_AWUSER;
wire  sum_WVALID;
wire  sum_WREADY;
wire [31 : 0] sum_WDATA;
wire [3 : 0] sum_WSTRB;
wire  sum_WLAST;
wire [0 : 0] sum_WID;
wire [0 : 0] sum_WUSER;
wire  sum_ARVALID;
wire  sum_ARREADY;
wire [63 : 0] sum_ARADDR;
wire [0 : 0] sum_ARID;
wire [7 : 0] sum_ARLEN;
wire [2 : 0] sum_ARSIZE;
wire [1 : 0] sum_ARBURST;
wire [1 : 0] sum_ARLOCK;
wire [3 : 0] sum_ARCACHE;
wire [2 : 0] sum_ARPROT;
wire [3 : 0] sum_ARQOS;
wire [3 : 0] sum_ARREGION;
wire [0 : 0] sum_ARUSER;
wire  sum_RVALID;
wire  sum_RREADY;
wire [31 : 0] sum_RDATA;
wire  sum_RLAST;
wire [0 : 0] sum_RID;
wire [0 : 0] sum_RUSER;
wire [1 : 0] sum_RRESP;
wire  sum_BVALID;
wire  sum_BREADY;
wire [1 : 0] sum_BRESP;
wire [0 : 0] sum_BID;
wire [0 : 0] sum_BUSER;
integer done_cnt = 0;
integer AESL_ready_cnt = 0;
integer ready_cnt = 0;
reg ready_initial;
reg ready_initial_n;
reg ready_last_n;
reg ready_delay_last_n;
reg done_delay_last_n;
reg interface_done = 0;
wire control_write_data_finish;
wire AESL_slave_start;
reg AESL_slave_start_lock = 0;
wire AESL_slave_write_start_in;
wire AESL_slave_write_start_finish;
reg AESL_slave_ready;
wire AESL_slave_output_done;
wire AESL_slave_done;
reg ready_rise = 0;
reg start_rise = 0;
reg slave_start_status = 0;
reg slave_done_status = 0;
reg ap_done_lock = 0;


wire all_finish;
wire ap_clk;
wire ap_rst_n;
wire ap_rst_n_n;

`AUTOTB_DUT `AUTOTB_DUT_INST(
    .s_axi_control_AWADDR(control_AWADDR),
    .s_axi_control_AWVALID(control_AWVALID),
    .s_axi_control_AWREADY(control_AWREADY),
    .s_axi_control_WVALID(control_WVALID),
    .s_axi_control_WREADY(control_WREADY),
    .s_axi_control_WDATA(control_WDATA),
    .s_axi_control_WSTRB(control_WSTRB),
    .s_axi_control_ARADDR(control_ARADDR),
    .s_axi_control_ARVALID(control_ARVALID),
    .s_axi_control_ARREADY(control_ARREADY),
    .s_axi_control_RVALID(control_RVALID),
    .s_axi_control_RREADY(control_RREADY),
    .s_axi_control_RDATA(control_RDATA),
    .s_axi_control_RRESP(control_RRESP),
    .s_axi_control_BVALID(control_BVALID),
    .s_axi_control_BREADY(control_BREADY),
    .s_axi_control_BRESP(control_BRESP),
    .interrupt(control_INTERRUPT),
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n),
    .m_axi_a_AWVALID(a_AWVALID),
    .m_axi_a_AWREADY(a_AWREADY),
    .m_axi_a_AWADDR(a_AWADDR),
    .m_axi_a_AWID(a_AWID),
    .m_axi_a_AWLEN(a_AWLEN),
    .m_axi_a_AWSIZE(a_AWSIZE),
    .m_axi_a_AWBURST(a_AWBURST),
    .m_axi_a_AWLOCK(a_AWLOCK),
    .m_axi_a_AWCACHE(a_AWCACHE),
    .m_axi_a_AWPROT(a_AWPROT),
    .m_axi_a_AWQOS(a_AWQOS),
    .m_axi_a_AWREGION(a_AWREGION),
    .m_axi_a_AWUSER(a_AWUSER),
    .m_axi_a_WVALID(a_WVALID),
    .m_axi_a_WREADY(a_WREADY),
    .m_axi_a_WDATA(a_WDATA),
    .m_axi_a_WSTRB(a_WSTRB),
    .m_axi_a_WLAST(a_WLAST),
    .m_axi_a_WID(a_WID),
    .m_axi_a_WUSER(a_WUSER),
    .m_axi_a_ARVALID(a_ARVALID),
    .m_axi_a_ARREADY(a_ARREADY),
    .m_axi_a_ARADDR(a_ARADDR),
    .m_axi_a_ARID(a_ARID),
    .m_axi_a_ARLEN(a_ARLEN),
    .m_axi_a_ARSIZE(a_ARSIZE),
    .m_axi_a_ARBURST(a_ARBURST),
    .m_axi_a_ARLOCK(a_ARLOCK),
    .m_axi_a_ARCACHE(a_ARCACHE),
    .m_axi_a_ARPROT(a_ARPROT),
    .m_axi_a_ARQOS(a_ARQOS),
    .m_axi_a_ARREGION(a_ARREGION),
    .m_axi_a_ARUSER(a_ARUSER),
    .m_axi_a_RVALID(a_RVALID),
    .m_axi_a_RREADY(a_RREADY),
    .m_axi_a_RDATA(a_RDATA),
    .m_axi_a_RLAST(a_RLAST),
    .m_axi_a_RID(a_RID),
    .m_axi_a_RUSER(a_RUSER),
    .m_axi_a_RRESP(a_RRESP),
    .m_axi_a_BVALID(a_BVALID),
    .m_axi_a_BREADY(a_BREADY),
    .m_axi_a_BRESP(a_BRESP),
    .m_axi_a_BID(a_BID),
    .m_axi_a_BUSER(a_BUSER),
    .m_axi_b_AWVALID(b_AWVALID),
    .m_axi_b_AWREADY(b_AWREADY),
    .m_axi_b_AWADDR(b_AWADDR),
    .m_axi_b_AWID(b_AWID),
    .m_axi_b_AWLEN(b_AWLEN),
    .m_axi_b_AWSIZE(b_AWSIZE),
    .m_axi_b_AWBURST(b_AWBURST),
    .m_axi_b_AWLOCK(b_AWLOCK),
    .m_axi_b_AWCACHE(b_AWCACHE),
    .m_axi_b_AWPROT(b_AWPROT),
    .m_axi_b_AWQOS(b_AWQOS),
    .m_axi_b_AWREGION(b_AWREGION),
    .m_axi_b_AWUSER(b_AWUSER),
    .m_axi_b_WVALID(b_WVALID),
    .m_axi_b_WREADY(b_WREADY),
    .m_axi_b_WDATA(b_WDATA),
    .m_axi_b_WSTRB(b_WSTRB),
    .m_axi_b_WLAST(b_WLAST),
    .m_axi_b_WID(b_WID),
    .m_axi_b_WUSER(b_WUSER),
    .m_axi_b_ARVALID(b_ARVALID),
    .m_axi_b_ARREADY(b_ARREADY),
    .m_axi_b_ARADDR(b_ARADDR),
    .m_axi_b_ARID(b_ARID),
    .m_axi_b_ARLEN(b_ARLEN),
    .m_axi_b_ARSIZE(b_ARSIZE),
    .m_axi_b_ARBURST(b_ARBURST),
    .m_axi_b_ARLOCK(b_ARLOCK),
    .m_axi_b_ARCACHE(b_ARCACHE),
    .m_axi_b_ARPROT(b_ARPROT),
    .m_axi_b_ARQOS(b_ARQOS),
    .m_axi_b_ARREGION(b_ARREGION),
    .m_axi_b_ARUSER(b_ARUSER),
    .m_axi_b_RVALID(b_RVALID),
    .m_axi_b_RREADY(b_RREADY),
    .m_axi_b_RDATA(b_RDATA),
    .m_axi_b_RLAST(b_RLAST),
    .m_axi_b_RID(b_RID),
    .m_axi_b_RUSER(b_RUSER),
    .m_axi_b_RRESP(b_RRESP),
    .m_axi_b_BVALID(b_BVALID),
    .m_axi_b_BREADY(b_BREADY),
    .m_axi_b_BRESP(b_BRESP),
    .m_axi_b_BID(b_BID),
    .m_axi_b_BUSER(b_BUSER),
    .m_axi_sum_AWVALID(sum_AWVALID),
    .m_axi_sum_AWREADY(sum_AWREADY),
    .m_axi_sum_AWADDR(sum_AWADDR),
    .m_axi_sum_AWID(sum_AWID),
    .m_axi_sum_AWLEN(sum_AWLEN),
    .m_axi_sum_AWSIZE(sum_AWSIZE),
    .m_axi_sum_AWBURST(sum_AWBURST),
    .m_axi_sum_AWLOCK(sum_AWLOCK),
    .m_axi_sum_AWCACHE(sum_AWCACHE),
    .m_axi_sum_AWPROT(sum_AWPROT),
    .m_axi_sum_AWQOS(sum_AWQOS),
    .m_axi_sum_AWREGION(sum_AWREGION),
    .m_axi_sum_AWUSER(sum_AWUSER),
    .m_axi_sum_WVALID(sum_WVALID),
    .m_axi_sum_WREADY(sum_WREADY),
    .m_axi_sum_WDATA(sum_WDATA),
    .m_axi_sum_WSTRB(sum_WSTRB),
    .m_axi_sum_WLAST(sum_WLAST),
    .m_axi_sum_WID(sum_WID),
    .m_axi_sum_WUSER(sum_WUSER),
    .m_axi_sum_ARVALID(sum_ARVALID),
    .m_axi_sum_ARREADY(sum_ARREADY),
    .m_axi_sum_ARADDR(sum_ARADDR),
    .m_axi_sum_ARID(sum_ARID),
    .m_axi_sum_ARLEN(sum_ARLEN),
    .m_axi_sum_ARSIZE(sum_ARSIZE),
    .m_axi_sum_ARBURST(sum_ARBURST),
    .m_axi_sum_ARLOCK(sum_ARLOCK),
    .m_axi_sum_ARCACHE(sum_ARCACHE),
    .m_axi_sum_ARPROT(sum_ARPROT),
    .m_axi_sum_ARQOS(sum_ARQOS),
    .m_axi_sum_ARREGION(sum_ARREGION),
    .m_axi_sum_ARUSER(sum_ARUSER),
    .m_axi_sum_RVALID(sum_RVALID),
    .m_axi_sum_RREADY(sum_RREADY),
    .m_axi_sum_RDATA(sum_RDATA),
    .m_axi_sum_RLAST(sum_RLAST),
    .m_axi_sum_RID(sum_RID),
    .m_axi_sum_RUSER(sum_RUSER),
    .m_axi_sum_RRESP(sum_RRESP),
    .m_axi_sum_BVALID(sum_BVALID),
    .m_axi_sum_BREADY(sum_BREADY),
    .m_axi_sum_BRESP(sum_BRESP),
    .m_axi_sum_BID(sum_BID),
    .m_axi_sum_BUSER(sum_BUSER));
assign ap_clk = AESL_clock;
assign ap_rst_n = AESL_reset;
assign ap_rst_n_n = ~AESL_reset;
assign AESL_reset = dut_rst;
assign AESL_start = svtb_top.misc_if.tb2dut_ap_start;
assign AESL_ready = svtb_top.misc_if.dut2tb_ap_ready;
assign AESL_done  = svtb_top.misc_if.dut2tb_ap_done;
assign all_finish = svtb_top.misc_if.finished;
initial begin : initial_process
    integer proc_rand;
    rst = 0;
    # 100;
    repeat(0+3) @ (posedge AESL_clock);
    # 0.1;
    rst = 1;
end
initial begin : initial_process_for_dut_rst
    integer proc_rand;
    dut_rst = 0;
    # 100;
    repeat(3) @ (posedge AESL_clock);
    # 0.1;
    dut_rst = 1;
end
initial begin
    AESL_clock = 0;
    forever #`AUTOTB_CLOCK_PERIOD_DIV2 AESL_clock = ~AESL_clock;
end

    sv_module_top svtb_top();

////////////////////////////////////////////
// progress and performance
////////////////////////////////////////////

task wait_start();
    while (~AESL_start) begin
        @ (posedge AESL_clock);
    end
endtask

reg [31:0] clk_cnt = 0;
reg AESL_ready_p1;
reg AESL_start_p1;

always @ (posedge AESL_clock) begin
    if (AESL_reset == 0) begin
        clk_cnt <= 32'h0;
        AESL_ready_p1 <= 1'b0;
        AESL_start_p1 <= 1'b0;
    end
    else begin
        clk_cnt <= clk_cnt + 1;
        AESL_ready_p1 <= AESL_ready;
        AESL_start_p1 <= AESL_start;
    end
end

reg [31:0] start_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] start_cnt;
reg [31:0] ready_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] ap_ready_cnt;
reg [31:0] finish_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] finish_cnt;
reg [31:0] lat_total;
event report_progress;

always @(posedge AESL_clock)
begin
    if (finish_cnt == AUTOTB_TRANSACTION_NUM - 1 && AESL_done == 1'b1)
        lat_total = clk_cnt - start_timestamp[0];
end

initial begin
    start_cnt = 0;
    finish_cnt = 0;
    ap_ready_cnt = 0;
    wait (AESL_reset == 1);
    wait_start();
    start_timestamp[start_cnt] = clk_cnt;
    start_cnt = start_cnt + 1;
    if (AESL_done) begin
        finish_timestamp[finish_cnt] = clk_cnt;
        finish_cnt = finish_cnt + 1;
    end
    -> report_progress;
    forever begin
        @ (posedge AESL_clock);
        if (start_cnt < AUTOTB_TRANSACTION_NUM) begin
            if ((AESL_start && AESL_ready_p1)||(AESL_start && ~AESL_start_p1)) begin
                start_timestamp[start_cnt] = clk_cnt;
                start_cnt = start_cnt + 1;
            end
        end
        if (ap_ready_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_start_p1 && AESL_ready_p1) begin
                ready_timestamp[ap_ready_cnt] = clk_cnt;
                ap_ready_cnt = ap_ready_cnt + 1;
            end
        end
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                finish_timestamp[finish_cnt] = clk_cnt;
                finish_cnt = finish_cnt + 1;
            end
        end
        -> report_progress;
    end
end

reg [31:0] progress_timeout;

initial begin : simulation_progress
    real intra_progress;
    wait (AESL_reset == 1);
    progress_timeout = PROGRESS_TIMEOUT;
    $display("////////////////////////////////////////////////////////////////////////////////////");
    $display("// Inter-Transaction Progress: Completed Transaction / Total Transaction");
    $display("// Intra-Transaction Progress: Measured Latency / Latency Estimation * 100%%");
    $display("//");
    $display("// RTL Simulation : \"Inter-Transaction Progress\" [\"Intra-Transaction Progress\"] @ \"Simulation Time\"");
    $display("////////////////////////////////////////////////////////////////////////////////////");
    print_progress();
    while (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
        @ (report_progress);
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                print_progress();
                progress_timeout = PROGRESS_TIMEOUT;
            end else begin
                if (progress_timeout == 0) begin
                    print_progress();
                    progress_timeout = PROGRESS_TIMEOUT;
                end else begin
                    progress_timeout = progress_timeout - 1;
                end
            end
        end
    end
    print_progress();
    $display("////////////////////////////////////////////////////////////////////////////////////");
    calculate_performance();
end

task get_intra_progress(output real intra_progress);
    begin
        if (start_cnt > finish_cnt) begin
            intra_progress = clk_cnt - start_timestamp[finish_cnt];
        end else if(finish_cnt > 0) begin
            intra_progress = LATENCY_ESTIMATION;
        end else begin
            intra_progress = 0;
        end
        intra_progress = intra_progress / LATENCY_ESTIMATION;
    end
endtask

task print_progress();
    real intra_progress;
    begin
        if (LATENCY_ESTIMATION > 0) begin
            get_intra_progress(intra_progress);
            $display("// RTL Simulation : %0d / %0d [%2.2f%%] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, intra_progress * 100, $time);
        end else begin
            $display("// RTL Simulation : %0d / %0d [n/a] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, $time);
        end
    end
endtask

task calculate_performance();
    integer i;
    integer fp;
    reg [31:0] latency [0:AUTOTB_TRANSACTION_NUM - 1];
    reg [31:0] latency_min;
    reg [31:0] latency_max;
    reg [31:0] latency_total;
    reg [31:0] latency_average;
    reg [31:0] interval [0:AUTOTB_TRANSACTION_NUM - 2];
    reg [31:0] interval_min;
    reg [31:0] interval_max;
    reg [31:0] interval_total;
    reg [31:0] interval_average;
    reg [31:0] total_execute_time;
    begin
        latency_min = -1;
        latency_max = 0;
        latency_total = 0;
        interval_min = -1;
        interval_max = 0;
        interval_total = 0;
        total_execute_time = lat_total;

        for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
            // calculate latency
            latency[i] = finish_timestamp[i] - start_timestamp[i];
            if (latency[i] > latency_max) latency_max = latency[i];
            if (latency[i] < latency_min) latency_min = latency[i];
            latency_total = latency_total + latency[i];
            // calculate interval
            if (AUTOTB_TRANSACTION_NUM == 1) begin
                interval[i] = 0;
                interval_max = 0;
                interval_min = 0;
                interval_total = 0;
            end else if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                interval[i] = start_timestamp[i + 1] - start_timestamp[i];
                if (interval[i] > interval_max) interval_max = interval[i];
                if (interval[i] < interval_min) interval_min = interval[i];
                interval_total = interval_total + interval[i];
            end
        end

        latency_average = latency_total / AUTOTB_TRANSACTION_NUM;
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            interval_average = 0;
        end else begin
            interval_average = interval_total / (AUTOTB_TRANSACTION_NUM - 1);
        end

        fp = $fopen(`AUTOTB_LAT_RESULT_FILE, "w");

        $fdisplay(fp, "$MAX_LATENCY = \"%0d\"", latency_max);
        $fdisplay(fp, "$MIN_LATENCY = \"%0d\"", latency_min);
        $fdisplay(fp, "$AVER_LATENCY = \"%0d\"", latency_average);
        $fdisplay(fp, "$MAX_THROUGHPUT = \"%0d\"", interval_max);
        $fdisplay(fp, "$MIN_THROUGHPUT = \"%0d\"", interval_min);
        $fdisplay(fp, "$AVER_THROUGHPUT = \"%0d\"", interval_average);
        $fdisplay(fp, "$TOTAL_EXECUTE_TIME = \"%0d\"", total_execute_time);

        $fclose(fp);

        fp = $fopen(`AUTOTB_PER_RESULT_TRANS_FILE, "w");

        $fdisplay(fp, "%20s%16s%16s", "", "latency", "interval");
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            i = 0;
            $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
        end else begin
            for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
                if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                    $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
                end else begin
                    $fdisplay(fp, "transaction%8d:%16d               x", i, latency[i]);
                end
            end
        end

        $fclose(fp);
    end
endtask


////////////////////////////////////////////
// Dependence Check
////////////////////////////////////////////

`ifndef POST_SYN

`endif
///////////////////////////////////////////////////////
// dataflow status monitor
///////////////////////////////////////////////////////
dataflow_monitor U_dataflow_monitor(
    .clock(AESL_clock),
    .reset(~rst),
    .finish(all_finish));

`include "fifo_para.vh"
endmodule
