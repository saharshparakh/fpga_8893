//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.1.1 (lin64) Build 6233196 Thu Sep 11 21:27:11 MDT 2025
//Date        : Thu Jan 22 16:06:18 2026
//Host        : ece-linlabsrv01 running 64-bit Red Hat Enterprise Linux release 8.10 (Ootpa)
//Command     : generate_target bd_0_wrapper.bd
//Design      : bd_0_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bd_0_wrapper
   (ap_clk,
    ap_rst_n,
    interrupt,
    m_axi_a_araddr,
    m_axi_a_arburst,
    m_axi_a_arcache,
    m_axi_a_arid,
    m_axi_a_arlen,
    m_axi_a_arlock,
    m_axi_a_arprot,
    m_axi_a_arqos,
    m_axi_a_arready,
    m_axi_a_arregion,
    m_axi_a_arsize,
    m_axi_a_arvalid,
    m_axi_a_awaddr,
    m_axi_a_awburst,
    m_axi_a_awcache,
    m_axi_a_awid,
    m_axi_a_awlen,
    m_axi_a_awlock,
    m_axi_a_awprot,
    m_axi_a_awqos,
    m_axi_a_awready,
    m_axi_a_awregion,
    m_axi_a_awsize,
    m_axi_a_awvalid,
    m_axi_a_bid,
    m_axi_a_bready,
    m_axi_a_bresp,
    m_axi_a_bvalid,
    m_axi_a_rdata,
    m_axi_a_rid,
    m_axi_a_rlast,
    m_axi_a_rready,
    m_axi_a_rresp,
    m_axi_a_rvalid,
    m_axi_a_wdata,
    m_axi_a_wid,
    m_axi_a_wlast,
    m_axi_a_wready,
    m_axi_a_wstrb,
    m_axi_a_wvalid,
    m_axi_b_araddr,
    m_axi_b_arburst,
    m_axi_b_arcache,
    m_axi_b_arid,
    m_axi_b_arlen,
    m_axi_b_arlock,
    m_axi_b_arprot,
    m_axi_b_arqos,
    m_axi_b_arready,
    m_axi_b_arregion,
    m_axi_b_arsize,
    m_axi_b_arvalid,
    m_axi_b_awaddr,
    m_axi_b_awburst,
    m_axi_b_awcache,
    m_axi_b_awid,
    m_axi_b_awlen,
    m_axi_b_awlock,
    m_axi_b_awprot,
    m_axi_b_awqos,
    m_axi_b_awready,
    m_axi_b_awregion,
    m_axi_b_awsize,
    m_axi_b_awvalid,
    m_axi_b_bid,
    m_axi_b_bready,
    m_axi_b_bresp,
    m_axi_b_bvalid,
    m_axi_b_rdata,
    m_axi_b_rid,
    m_axi_b_rlast,
    m_axi_b_rready,
    m_axi_b_rresp,
    m_axi_b_rvalid,
    m_axi_b_wdata,
    m_axi_b_wid,
    m_axi_b_wlast,
    m_axi_b_wready,
    m_axi_b_wstrb,
    m_axi_b_wvalid,
    m_axi_sum_araddr,
    m_axi_sum_arburst,
    m_axi_sum_arcache,
    m_axi_sum_arid,
    m_axi_sum_arlen,
    m_axi_sum_arlock,
    m_axi_sum_arprot,
    m_axi_sum_arqos,
    m_axi_sum_arready,
    m_axi_sum_arregion,
    m_axi_sum_arsize,
    m_axi_sum_arvalid,
    m_axi_sum_awaddr,
    m_axi_sum_awburst,
    m_axi_sum_awcache,
    m_axi_sum_awid,
    m_axi_sum_awlen,
    m_axi_sum_awlock,
    m_axi_sum_awprot,
    m_axi_sum_awqos,
    m_axi_sum_awready,
    m_axi_sum_awregion,
    m_axi_sum_awsize,
    m_axi_sum_awvalid,
    m_axi_sum_bid,
    m_axi_sum_bready,
    m_axi_sum_bresp,
    m_axi_sum_bvalid,
    m_axi_sum_rdata,
    m_axi_sum_rid,
    m_axi_sum_rlast,
    m_axi_sum_rready,
    m_axi_sum_rresp,
    m_axi_sum_rvalid,
    m_axi_sum_wdata,
    m_axi_sum_wid,
    m_axi_sum_wlast,
    m_axi_sum_wready,
    m_axi_sum_wstrb,
    m_axi_sum_wvalid,
    s_axi_control_araddr,
    s_axi_control_arready,
    s_axi_control_arvalid,
    s_axi_control_awaddr,
    s_axi_control_awready,
    s_axi_control_awvalid,
    s_axi_control_bready,
    s_axi_control_bresp,
    s_axi_control_bvalid,
    s_axi_control_rdata,
    s_axi_control_rready,
    s_axi_control_rresp,
    s_axi_control_rvalid,
    s_axi_control_wdata,
    s_axi_control_wready,
    s_axi_control_wstrb,
    s_axi_control_wvalid);
  input ap_clk;
  input ap_rst_n;
  output interrupt;
  output [63:0]m_axi_a_araddr;
  output [1:0]m_axi_a_arburst;
  output [3:0]m_axi_a_arcache;
  output [0:0]m_axi_a_arid;
  output [7:0]m_axi_a_arlen;
  output [1:0]m_axi_a_arlock;
  output [2:0]m_axi_a_arprot;
  output [3:0]m_axi_a_arqos;
  input m_axi_a_arready;
  output [3:0]m_axi_a_arregion;
  output [2:0]m_axi_a_arsize;
  output m_axi_a_arvalid;
  output [63:0]m_axi_a_awaddr;
  output [1:0]m_axi_a_awburst;
  output [3:0]m_axi_a_awcache;
  output [0:0]m_axi_a_awid;
  output [7:0]m_axi_a_awlen;
  output [1:0]m_axi_a_awlock;
  output [2:0]m_axi_a_awprot;
  output [3:0]m_axi_a_awqos;
  input m_axi_a_awready;
  output [3:0]m_axi_a_awregion;
  output [2:0]m_axi_a_awsize;
  output m_axi_a_awvalid;
  input [0:0]m_axi_a_bid;
  output m_axi_a_bready;
  input [1:0]m_axi_a_bresp;
  input m_axi_a_bvalid;
  input [31:0]m_axi_a_rdata;
  input [0:0]m_axi_a_rid;
  input m_axi_a_rlast;
  output m_axi_a_rready;
  input [1:0]m_axi_a_rresp;
  input m_axi_a_rvalid;
  output [31:0]m_axi_a_wdata;
  output [0:0]m_axi_a_wid;
  output m_axi_a_wlast;
  input m_axi_a_wready;
  output [3:0]m_axi_a_wstrb;
  output m_axi_a_wvalid;
  output [63:0]m_axi_b_araddr;
  output [1:0]m_axi_b_arburst;
  output [3:0]m_axi_b_arcache;
  output [0:0]m_axi_b_arid;
  output [7:0]m_axi_b_arlen;
  output [1:0]m_axi_b_arlock;
  output [2:0]m_axi_b_arprot;
  output [3:0]m_axi_b_arqos;
  input m_axi_b_arready;
  output [3:0]m_axi_b_arregion;
  output [2:0]m_axi_b_arsize;
  output m_axi_b_arvalid;
  output [63:0]m_axi_b_awaddr;
  output [1:0]m_axi_b_awburst;
  output [3:0]m_axi_b_awcache;
  output [0:0]m_axi_b_awid;
  output [7:0]m_axi_b_awlen;
  output [1:0]m_axi_b_awlock;
  output [2:0]m_axi_b_awprot;
  output [3:0]m_axi_b_awqos;
  input m_axi_b_awready;
  output [3:0]m_axi_b_awregion;
  output [2:0]m_axi_b_awsize;
  output m_axi_b_awvalid;
  input [0:0]m_axi_b_bid;
  output m_axi_b_bready;
  input [1:0]m_axi_b_bresp;
  input m_axi_b_bvalid;
  input [31:0]m_axi_b_rdata;
  input [0:0]m_axi_b_rid;
  input m_axi_b_rlast;
  output m_axi_b_rready;
  input [1:0]m_axi_b_rresp;
  input m_axi_b_rvalid;
  output [31:0]m_axi_b_wdata;
  output [0:0]m_axi_b_wid;
  output m_axi_b_wlast;
  input m_axi_b_wready;
  output [3:0]m_axi_b_wstrb;
  output m_axi_b_wvalid;
  output [63:0]m_axi_sum_araddr;
  output [1:0]m_axi_sum_arburst;
  output [3:0]m_axi_sum_arcache;
  output [0:0]m_axi_sum_arid;
  output [7:0]m_axi_sum_arlen;
  output [1:0]m_axi_sum_arlock;
  output [2:0]m_axi_sum_arprot;
  output [3:0]m_axi_sum_arqos;
  input m_axi_sum_arready;
  output [3:0]m_axi_sum_arregion;
  output [2:0]m_axi_sum_arsize;
  output m_axi_sum_arvalid;
  output [63:0]m_axi_sum_awaddr;
  output [1:0]m_axi_sum_awburst;
  output [3:0]m_axi_sum_awcache;
  output [0:0]m_axi_sum_awid;
  output [7:0]m_axi_sum_awlen;
  output [1:0]m_axi_sum_awlock;
  output [2:0]m_axi_sum_awprot;
  output [3:0]m_axi_sum_awqos;
  input m_axi_sum_awready;
  output [3:0]m_axi_sum_awregion;
  output [2:0]m_axi_sum_awsize;
  output m_axi_sum_awvalid;
  input [0:0]m_axi_sum_bid;
  output m_axi_sum_bready;
  input [1:0]m_axi_sum_bresp;
  input m_axi_sum_bvalid;
  input [31:0]m_axi_sum_rdata;
  input [0:0]m_axi_sum_rid;
  input m_axi_sum_rlast;
  output m_axi_sum_rready;
  input [1:0]m_axi_sum_rresp;
  input m_axi_sum_rvalid;
  output [31:0]m_axi_sum_wdata;
  output [0:0]m_axi_sum_wid;
  output m_axi_sum_wlast;
  input m_axi_sum_wready;
  output [3:0]m_axi_sum_wstrb;
  output m_axi_sum_wvalid;
  input [5:0]s_axi_control_araddr;
  output s_axi_control_arready;
  input s_axi_control_arvalid;
  input [5:0]s_axi_control_awaddr;
  output s_axi_control_awready;
  input s_axi_control_awvalid;
  input s_axi_control_bready;
  output [1:0]s_axi_control_bresp;
  output s_axi_control_bvalid;
  output [31:0]s_axi_control_rdata;
  input s_axi_control_rready;
  output [1:0]s_axi_control_rresp;
  output s_axi_control_rvalid;
  input [31:0]s_axi_control_wdata;
  output s_axi_control_wready;
  input [3:0]s_axi_control_wstrb;
  input s_axi_control_wvalid;

  wire ap_clk;
  wire ap_rst_n;
  wire interrupt;
  wire [63:0]m_axi_a_araddr;
  wire [1:0]m_axi_a_arburst;
  wire [3:0]m_axi_a_arcache;
  wire [0:0]m_axi_a_arid;
  wire [7:0]m_axi_a_arlen;
  wire [1:0]m_axi_a_arlock;
  wire [2:0]m_axi_a_arprot;
  wire [3:0]m_axi_a_arqos;
  wire m_axi_a_arready;
  wire [3:0]m_axi_a_arregion;
  wire [2:0]m_axi_a_arsize;
  wire m_axi_a_arvalid;
  wire [63:0]m_axi_a_awaddr;
  wire [1:0]m_axi_a_awburst;
  wire [3:0]m_axi_a_awcache;
  wire [0:0]m_axi_a_awid;
  wire [7:0]m_axi_a_awlen;
  wire [1:0]m_axi_a_awlock;
  wire [2:0]m_axi_a_awprot;
  wire [3:0]m_axi_a_awqos;
  wire m_axi_a_awready;
  wire [3:0]m_axi_a_awregion;
  wire [2:0]m_axi_a_awsize;
  wire m_axi_a_awvalid;
  wire [0:0]m_axi_a_bid;
  wire m_axi_a_bready;
  wire [1:0]m_axi_a_bresp;
  wire m_axi_a_bvalid;
  wire [31:0]m_axi_a_rdata;
  wire [0:0]m_axi_a_rid;
  wire m_axi_a_rlast;
  wire m_axi_a_rready;
  wire [1:0]m_axi_a_rresp;
  wire m_axi_a_rvalid;
  wire [31:0]m_axi_a_wdata;
  wire [0:0]m_axi_a_wid;
  wire m_axi_a_wlast;
  wire m_axi_a_wready;
  wire [3:0]m_axi_a_wstrb;
  wire m_axi_a_wvalid;
  wire [63:0]m_axi_b_araddr;
  wire [1:0]m_axi_b_arburst;
  wire [3:0]m_axi_b_arcache;
  wire [0:0]m_axi_b_arid;
  wire [7:0]m_axi_b_arlen;
  wire [1:0]m_axi_b_arlock;
  wire [2:0]m_axi_b_arprot;
  wire [3:0]m_axi_b_arqos;
  wire m_axi_b_arready;
  wire [3:0]m_axi_b_arregion;
  wire [2:0]m_axi_b_arsize;
  wire m_axi_b_arvalid;
  wire [63:0]m_axi_b_awaddr;
  wire [1:0]m_axi_b_awburst;
  wire [3:0]m_axi_b_awcache;
  wire [0:0]m_axi_b_awid;
  wire [7:0]m_axi_b_awlen;
  wire [1:0]m_axi_b_awlock;
  wire [2:0]m_axi_b_awprot;
  wire [3:0]m_axi_b_awqos;
  wire m_axi_b_awready;
  wire [3:0]m_axi_b_awregion;
  wire [2:0]m_axi_b_awsize;
  wire m_axi_b_awvalid;
  wire [0:0]m_axi_b_bid;
  wire m_axi_b_bready;
  wire [1:0]m_axi_b_bresp;
  wire m_axi_b_bvalid;
  wire [31:0]m_axi_b_rdata;
  wire [0:0]m_axi_b_rid;
  wire m_axi_b_rlast;
  wire m_axi_b_rready;
  wire [1:0]m_axi_b_rresp;
  wire m_axi_b_rvalid;
  wire [31:0]m_axi_b_wdata;
  wire [0:0]m_axi_b_wid;
  wire m_axi_b_wlast;
  wire m_axi_b_wready;
  wire [3:0]m_axi_b_wstrb;
  wire m_axi_b_wvalid;
  wire [63:0]m_axi_sum_araddr;
  wire [1:0]m_axi_sum_arburst;
  wire [3:0]m_axi_sum_arcache;
  wire [0:0]m_axi_sum_arid;
  wire [7:0]m_axi_sum_arlen;
  wire [1:0]m_axi_sum_arlock;
  wire [2:0]m_axi_sum_arprot;
  wire [3:0]m_axi_sum_arqos;
  wire m_axi_sum_arready;
  wire [3:0]m_axi_sum_arregion;
  wire [2:0]m_axi_sum_arsize;
  wire m_axi_sum_arvalid;
  wire [63:0]m_axi_sum_awaddr;
  wire [1:0]m_axi_sum_awburst;
  wire [3:0]m_axi_sum_awcache;
  wire [0:0]m_axi_sum_awid;
  wire [7:0]m_axi_sum_awlen;
  wire [1:0]m_axi_sum_awlock;
  wire [2:0]m_axi_sum_awprot;
  wire [3:0]m_axi_sum_awqos;
  wire m_axi_sum_awready;
  wire [3:0]m_axi_sum_awregion;
  wire [2:0]m_axi_sum_awsize;
  wire m_axi_sum_awvalid;
  wire [0:0]m_axi_sum_bid;
  wire m_axi_sum_bready;
  wire [1:0]m_axi_sum_bresp;
  wire m_axi_sum_bvalid;
  wire [31:0]m_axi_sum_rdata;
  wire [0:0]m_axi_sum_rid;
  wire m_axi_sum_rlast;
  wire m_axi_sum_rready;
  wire [1:0]m_axi_sum_rresp;
  wire m_axi_sum_rvalid;
  wire [31:0]m_axi_sum_wdata;
  wire [0:0]m_axi_sum_wid;
  wire m_axi_sum_wlast;
  wire m_axi_sum_wready;
  wire [3:0]m_axi_sum_wstrb;
  wire m_axi_sum_wvalid;
  wire [5:0]s_axi_control_araddr;
  wire s_axi_control_arready;
  wire s_axi_control_arvalid;
  wire [5:0]s_axi_control_awaddr;
  wire s_axi_control_awready;
  wire s_axi_control_awvalid;
  wire s_axi_control_bready;
  wire [1:0]s_axi_control_bresp;
  wire s_axi_control_bvalid;
  wire [31:0]s_axi_control_rdata;
  wire s_axi_control_rready;
  wire [1:0]s_axi_control_rresp;
  wire s_axi_control_rvalid;
  wire [31:0]s_axi_control_wdata;
  wire s_axi_control_wready;
  wire [3:0]s_axi_control_wstrb;
  wire s_axi_control_wvalid;

  bd_0 bd_0_i
       (.ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .interrupt(interrupt),
        .m_axi_a_araddr(m_axi_a_araddr),
        .m_axi_a_arburst(m_axi_a_arburst),
        .m_axi_a_arcache(m_axi_a_arcache),
        .m_axi_a_arid(m_axi_a_arid),
        .m_axi_a_arlen(m_axi_a_arlen),
        .m_axi_a_arlock(m_axi_a_arlock),
        .m_axi_a_arprot(m_axi_a_arprot),
        .m_axi_a_arqos(m_axi_a_arqos),
        .m_axi_a_arready(m_axi_a_arready),
        .m_axi_a_arregion(m_axi_a_arregion),
        .m_axi_a_arsize(m_axi_a_arsize),
        .m_axi_a_arvalid(m_axi_a_arvalid),
        .m_axi_a_awaddr(m_axi_a_awaddr),
        .m_axi_a_awburst(m_axi_a_awburst),
        .m_axi_a_awcache(m_axi_a_awcache),
        .m_axi_a_awid(m_axi_a_awid),
        .m_axi_a_awlen(m_axi_a_awlen),
        .m_axi_a_awlock(m_axi_a_awlock),
        .m_axi_a_awprot(m_axi_a_awprot),
        .m_axi_a_awqos(m_axi_a_awqos),
        .m_axi_a_awready(m_axi_a_awready),
        .m_axi_a_awregion(m_axi_a_awregion),
        .m_axi_a_awsize(m_axi_a_awsize),
        .m_axi_a_awvalid(m_axi_a_awvalid),
        .m_axi_a_bid(m_axi_a_bid),
        .m_axi_a_bready(m_axi_a_bready),
        .m_axi_a_bresp(m_axi_a_bresp),
        .m_axi_a_bvalid(m_axi_a_bvalid),
        .m_axi_a_rdata(m_axi_a_rdata),
        .m_axi_a_rid(m_axi_a_rid),
        .m_axi_a_rlast(m_axi_a_rlast),
        .m_axi_a_rready(m_axi_a_rready),
        .m_axi_a_rresp(m_axi_a_rresp),
        .m_axi_a_rvalid(m_axi_a_rvalid),
        .m_axi_a_wdata(m_axi_a_wdata),
        .m_axi_a_wid(m_axi_a_wid),
        .m_axi_a_wlast(m_axi_a_wlast),
        .m_axi_a_wready(m_axi_a_wready),
        .m_axi_a_wstrb(m_axi_a_wstrb),
        .m_axi_a_wvalid(m_axi_a_wvalid),
        .m_axi_b_araddr(m_axi_b_araddr),
        .m_axi_b_arburst(m_axi_b_arburst),
        .m_axi_b_arcache(m_axi_b_arcache),
        .m_axi_b_arid(m_axi_b_arid),
        .m_axi_b_arlen(m_axi_b_arlen),
        .m_axi_b_arlock(m_axi_b_arlock),
        .m_axi_b_arprot(m_axi_b_arprot),
        .m_axi_b_arqos(m_axi_b_arqos),
        .m_axi_b_arready(m_axi_b_arready),
        .m_axi_b_arregion(m_axi_b_arregion),
        .m_axi_b_arsize(m_axi_b_arsize),
        .m_axi_b_arvalid(m_axi_b_arvalid),
        .m_axi_b_awaddr(m_axi_b_awaddr),
        .m_axi_b_awburst(m_axi_b_awburst),
        .m_axi_b_awcache(m_axi_b_awcache),
        .m_axi_b_awid(m_axi_b_awid),
        .m_axi_b_awlen(m_axi_b_awlen),
        .m_axi_b_awlock(m_axi_b_awlock),
        .m_axi_b_awprot(m_axi_b_awprot),
        .m_axi_b_awqos(m_axi_b_awqos),
        .m_axi_b_awready(m_axi_b_awready),
        .m_axi_b_awregion(m_axi_b_awregion),
        .m_axi_b_awsize(m_axi_b_awsize),
        .m_axi_b_awvalid(m_axi_b_awvalid),
        .m_axi_b_bid(m_axi_b_bid),
        .m_axi_b_bready(m_axi_b_bready),
        .m_axi_b_bresp(m_axi_b_bresp),
        .m_axi_b_bvalid(m_axi_b_bvalid),
        .m_axi_b_rdata(m_axi_b_rdata),
        .m_axi_b_rid(m_axi_b_rid),
        .m_axi_b_rlast(m_axi_b_rlast),
        .m_axi_b_rready(m_axi_b_rready),
        .m_axi_b_rresp(m_axi_b_rresp),
        .m_axi_b_rvalid(m_axi_b_rvalid),
        .m_axi_b_wdata(m_axi_b_wdata),
        .m_axi_b_wid(m_axi_b_wid),
        .m_axi_b_wlast(m_axi_b_wlast),
        .m_axi_b_wready(m_axi_b_wready),
        .m_axi_b_wstrb(m_axi_b_wstrb),
        .m_axi_b_wvalid(m_axi_b_wvalid),
        .m_axi_sum_araddr(m_axi_sum_araddr),
        .m_axi_sum_arburst(m_axi_sum_arburst),
        .m_axi_sum_arcache(m_axi_sum_arcache),
        .m_axi_sum_arid(m_axi_sum_arid),
        .m_axi_sum_arlen(m_axi_sum_arlen),
        .m_axi_sum_arlock(m_axi_sum_arlock),
        .m_axi_sum_arprot(m_axi_sum_arprot),
        .m_axi_sum_arqos(m_axi_sum_arqos),
        .m_axi_sum_arready(m_axi_sum_arready),
        .m_axi_sum_arregion(m_axi_sum_arregion),
        .m_axi_sum_arsize(m_axi_sum_arsize),
        .m_axi_sum_arvalid(m_axi_sum_arvalid),
        .m_axi_sum_awaddr(m_axi_sum_awaddr),
        .m_axi_sum_awburst(m_axi_sum_awburst),
        .m_axi_sum_awcache(m_axi_sum_awcache),
        .m_axi_sum_awid(m_axi_sum_awid),
        .m_axi_sum_awlen(m_axi_sum_awlen),
        .m_axi_sum_awlock(m_axi_sum_awlock),
        .m_axi_sum_awprot(m_axi_sum_awprot),
        .m_axi_sum_awqos(m_axi_sum_awqos),
        .m_axi_sum_awready(m_axi_sum_awready),
        .m_axi_sum_awregion(m_axi_sum_awregion),
        .m_axi_sum_awsize(m_axi_sum_awsize),
        .m_axi_sum_awvalid(m_axi_sum_awvalid),
        .m_axi_sum_bid(m_axi_sum_bid),
        .m_axi_sum_bready(m_axi_sum_bready),
        .m_axi_sum_bresp(m_axi_sum_bresp),
        .m_axi_sum_bvalid(m_axi_sum_bvalid),
        .m_axi_sum_rdata(m_axi_sum_rdata),
        .m_axi_sum_rid(m_axi_sum_rid),
        .m_axi_sum_rlast(m_axi_sum_rlast),
        .m_axi_sum_rready(m_axi_sum_rready),
        .m_axi_sum_rresp(m_axi_sum_rresp),
        .m_axi_sum_rvalid(m_axi_sum_rvalid),
        .m_axi_sum_wdata(m_axi_sum_wdata),
        .m_axi_sum_wid(m_axi_sum_wid),
        .m_axi_sum_wlast(m_axi_sum_wlast),
        .m_axi_sum_wready(m_axi_sum_wready),
        .m_axi_sum_wstrb(m_axi_sum_wstrb),
        .m_axi_sum_wvalid(m_axi_sum_wvalid),
        .s_axi_control_araddr(s_axi_control_araddr),
        .s_axi_control_arready(s_axi_control_arready),
        .s_axi_control_arvalid(s_axi_control_arvalid),
        .s_axi_control_awaddr(s_axi_control_awaddr),
        .s_axi_control_awready(s_axi_control_awready),
        .s_axi_control_awvalid(s_axi_control_awvalid),
        .s_axi_control_bready(s_axi_control_bready),
        .s_axi_control_bresp(s_axi_control_bresp),
        .s_axi_control_bvalid(s_axi_control_bvalid),
        .s_axi_control_rdata(s_axi_control_rdata),
        .s_axi_control_rready(s_axi_control_rready),
        .s_axi_control_rresp(s_axi_control_rresp),
        .s_axi_control_rvalid(s_axi_control_rvalid),
        .s_axi_control_wdata(s_axi_control_wdata),
        .s_axi_control_wready(s_axi_control_wready),
        .s_axi_control_wstrb(s_axi_control_wstrb),
        .s_axi_control_wvalid(s_axi_control_wvalid));
endmodule
