//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.1.1 (lin64) Build 6233196 Thu Sep 11 21:27:11 MDT 2025
//Date        : Thu Jan 22 16:06:18 2026
//Host        : ece-linlabsrv01 running 64-bit Red Hat Enterprise Linux release 8.10 (Ootpa)
//Command     : generate_target bd_0.bd
//Design      : bd_0
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "bd_0,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=bd_0,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=1,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "bd_0.hwdef" *) 
module bd_0
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.AP_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.AP_CLK, ASSOCIATED_BUSIF m_axi_a:m_axi_b:m_axi_sum:s_axi_control, ASSOCIATED_RESET ap_rst_n, CLK_DOMAIN bd_0_ap_clk_0, FREQ_HZ 100000000.0, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input ap_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.AP_RST_N RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.AP_RST_N, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input ap_rst_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.INTERRUPT INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.INTERRUPT, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) output interrupt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARADDR" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axi_a, ADDR_WIDTH 64, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN bd_0_ap_clk_0, DATA_WIDTH 32, FREQ_HZ 100000000.0, HAS_BRESP 1, HAS_BURST 0, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 1, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 16, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 16, NUM_WRITE_THREADS 1, PHASE 0.0, PROTOCOL AXI4, READ_WRITE_MODE READ_ONLY, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) output [63:0]m_axi_a_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARBURST" *) output [1:0]m_axi_a_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARCACHE" *) output [3:0]m_axi_a_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARID" *) output [0:0]m_axi_a_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARLEN" *) output [7:0]m_axi_a_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARLOCK" *) output [1:0]m_axi_a_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARPROT" *) output [2:0]m_axi_a_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARQOS" *) output [3:0]m_axi_a_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARREADY" *) input m_axi_a_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARREGION" *) output [3:0]m_axi_a_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARSIZE" *) output [2:0]m_axi_a_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARVALID" *) output m_axi_a_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWADDR" *) output [63:0]m_axi_a_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWBURST" *) output [1:0]m_axi_a_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWCACHE" *) output [3:0]m_axi_a_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWID" *) output [0:0]m_axi_a_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWLEN" *) output [7:0]m_axi_a_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWLOCK" *) output [1:0]m_axi_a_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWPROT" *) output [2:0]m_axi_a_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWQOS" *) output [3:0]m_axi_a_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWREADY" *) input m_axi_a_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWREGION" *) output [3:0]m_axi_a_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWSIZE" *) output [2:0]m_axi_a_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWVALID" *) output m_axi_a_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a BID" *) input [0:0]m_axi_a_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a BREADY" *) output m_axi_a_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a BRESP" *) input [1:0]m_axi_a_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a BVALID" *) input m_axi_a_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RDATA" *) input [31:0]m_axi_a_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RID" *) input [0:0]m_axi_a_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RLAST" *) input m_axi_a_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RREADY" *) output m_axi_a_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RRESP" *) input [1:0]m_axi_a_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RVALID" *) input m_axi_a_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WDATA" *) output [31:0]m_axi_a_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WID" *) output [0:0]m_axi_a_wid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WLAST" *) output m_axi_a_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WREADY" *) input m_axi_a_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WSTRB" *) output [3:0]m_axi_a_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WVALID" *) output m_axi_a_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARADDR" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axi_b, ADDR_WIDTH 64, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN bd_0_ap_clk_0, DATA_WIDTH 32, FREQ_HZ 100000000.0, HAS_BRESP 1, HAS_BURST 0, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 1, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 16, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 16, NUM_WRITE_THREADS 1, PHASE 0.0, PROTOCOL AXI4, READ_WRITE_MODE READ_ONLY, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) output [63:0]m_axi_b_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARBURST" *) output [1:0]m_axi_b_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARCACHE" *) output [3:0]m_axi_b_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARID" *) output [0:0]m_axi_b_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARLEN" *) output [7:0]m_axi_b_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARLOCK" *) output [1:0]m_axi_b_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARPROT" *) output [2:0]m_axi_b_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARQOS" *) output [3:0]m_axi_b_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARREADY" *) input m_axi_b_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARREGION" *) output [3:0]m_axi_b_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARSIZE" *) output [2:0]m_axi_b_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARVALID" *) output m_axi_b_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWADDR" *) output [63:0]m_axi_b_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWBURST" *) output [1:0]m_axi_b_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWCACHE" *) output [3:0]m_axi_b_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWID" *) output [0:0]m_axi_b_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWLEN" *) output [7:0]m_axi_b_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWLOCK" *) output [1:0]m_axi_b_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWPROT" *) output [2:0]m_axi_b_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWQOS" *) output [3:0]m_axi_b_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWREADY" *) input m_axi_b_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWREGION" *) output [3:0]m_axi_b_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWSIZE" *) output [2:0]m_axi_b_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWVALID" *) output m_axi_b_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b BID" *) input [0:0]m_axi_b_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b BREADY" *) output m_axi_b_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b BRESP" *) input [1:0]m_axi_b_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b BVALID" *) input m_axi_b_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RDATA" *) input [31:0]m_axi_b_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RID" *) input [0:0]m_axi_b_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RLAST" *) input m_axi_b_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RREADY" *) output m_axi_b_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RRESP" *) input [1:0]m_axi_b_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RVALID" *) input m_axi_b_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WDATA" *) output [31:0]m_axi_b_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WID" *) output [0:0]m_axi_b_wid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WLAST" *) output m_axi_b_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WREADY" *) input m_axi_b_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WSTRB" *) output [3:0]m_axi_b_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WVALID" *) output m_axi_b_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARADDR" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axi_sum, ADDR_WIDTH 64, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN bd_0_ap_clk_0, DATA_WIDTH 32, FREQ_HZ 100000000.0, HAS_BRESP 1, HAS_BURST 0, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 1, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 16, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 16, NUM_WRITE_THREADS 1, PHASE 0.0, PROTOCOL AXI4, READ_WRITE_MODE WRITE_ONLY, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) output [63:0]m_axi_sum_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARBURST" *) output [1:0]m_axi_sum_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARCACHE" *) output [3:0]m_axi_sum_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARID" *) output [0:0]m_axi_sum_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARLEN" *) output [7:0]m_axi_sum_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARLOCK" *) output [1:0]m_axi_sum_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARPROT" *) output [2:0]m_axi_sum_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARQOS" *) output [3:0]m_axi_sum_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARREADY" *) input m_axi_sum_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARREGION" *) output [3:0]m_axi_sum_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARSIZE" *) output [2:0]m_axi_sum_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARVALID" *) output m_axi_sum_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWADDR" *) output [63:0]m_axi_sum_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWBURST" *) output [1:0]m_axi_sum_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWCACHE" *) output [3:0]m_axi_sum_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWID" *) output [0:0]m_axi_sum_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWLEN" *) output [7:0]m_axi_sum_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWLOCK" *) output [1:0]m_axi_sum_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWPROT" *) output [2:0]m_axi_sum_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWQOS" *) output [3:0]m_axi_sum_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWREADY" *) input m_axi_sum_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWREGION" *) output [3:0]m_axi_sum_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWSIZE" *) output [2:0]m_axi_sum_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWVALID" *) output m_axi_sum_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum BID" *) input [0:0]m_axi_sum_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum BREADY" *) output m_axi_sum_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum BRESP" *) input [1:0]m_axi_sum_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum BVALID" *) input m_axi_sum_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RDATA" *) input [31:0]m_axi_sum_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RID" *) input [0:0]m_axi_sum_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RLAST" *) input m_axi_sum_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RREADY" *) output m_axi_sum_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RRESP" *) input [1:0]m_axi_sum_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RVALID" *) input m_axi_sum_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WDATA" *) output [31:0]m_axi_sum_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WID" *) output [0:0]m_axi_sum_wid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WLAST" *) output m_axi_sum_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WREADY" *) input m_axi_sum_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WSTRB" *) output [3:0]m_axi_sum_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WVALID" *) output m_axi_sum_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control ARADDR" *) (* X_INTERFACE_MODE = "Slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_control, ADDR_WIDTH 32, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN bd_0_ap_clk_0, DATA_WIDTH 32, FREQ_HZ 100000000.0, HAS_BRESP 1, HAS_BURST 0, HAS_CACHE 0, HAS_LOCK 0, HAS_PROT 0, HAS_QOS 0, HAS_REGION 0, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 0, INSERT_VIP 0, MAX_BURST_LENGTH 1, NUM_READ_OUTSTANDING 1, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 1, NUM_WRITE_THREADS 1, PHASE 0.0, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) input [5:0]s_axi_control_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control ARREADY" *) output s_axi_control_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control ARVALID" *) input s_axi_control_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control AWADDR" *) input [5:0]s_axi_control_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control AWREADY" *) output s_axi_control_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control AWVALID" *) input s_axi_control_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control BREADY" *) input s_axi_control_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control BRESP" *) output [1:0]s_axi_control_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control BVALID" *) output s_axi_control_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RDATA" *) output [31:0]s_axi_control_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RREADY" *) input s_axi_control_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RRESP" *) output [1:0]s_axi_control_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RVALID" *) output s_axi_control_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WDATA" *) input [31:0]s_axi_control_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WREADY" *) output s_axi_control_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WSTRB" *) input [3:0]s_axi_control_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WVALID" *) input s_axi_control_wvalid;

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

  bd_0_hls_inst_0 hls_inst
       (.ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .interrupt(interrupt),
        .m_axi_a_ARADDR(m_axi_a_araddr),
        .m_axi_a_ARBURST(m_axi_a_arburst),
        .m_axi_a_ARCACHE(m_axi_a_arcache),
        .m_axi_a_ARID(m_axi_a_arid),
        .m_axi_a_ARLEN(m_axi_a_arlen),
        .m_axi_a_ARLOCK(m_axi_a_arlock),
        .m_axi_a_ARPROT(m_axi_a_arprot),
        .m_axi_a_ARQOS(m_axi_a_arqos),
        .m_axi_a_ARREADY(m_axi_a_arready),
        .m_axi_a_ARREGION(m_axi_a_arregion),
        .m_axi_a_ARSIZE(m_axi_a_arsize),
        .m_axi_a_ARVALID(m_axi_a_arvalid),
        .m_axi_a_AWADDR(m_axi_a_awaddr),
        .m_axi_a_AWBURST(m_axi_a_awburst),
        .m_axi_a_AWCACHE(m_axi_a_awcache),
        .m_axi_a_AWID(m_axi_a_awid),
        .m_axi_a_AWLEN(m_axi_a_awlen),
        .m_axi_a_AWLOCK(m_axi_a_awlock),
        .m_axi_a_AWPROT(m_axi_a_awprot),
        .m_axi_a_AWQOS(m_axi_a_awqos),
        .m_axi_a_AWREADY(m_axi_a_awready),
        .m_axi_a_AWREGION(m_axi_a_awregion),
        .m_axi_a_AWSIZE(m_axi_a_awsize),
        .m_axi_a_AWVALID(m_axi_a_awvalid),
        .m_axi_a_BID(m_axi_a_bid),
        .m_axi_a_BREADY(m_axi_a_bready),
        .m_axi_a_BRESP(m_axi_a_bresp),
        .m_axi_a_BVALID(m_axi_a_bvalid),
        .m_axi_a_RDATA(m_axi_a_rdata),
        .m_axi_a_RID(m_axi_a_rid),
        .m_axi_a_RLAST(m_axi_a_rlast),
        .m_axi_a_RREADY(m_axi_a_rready),
        .m_axi_a_RRESP(m_axi_a_rresp),
        .m_axi_a_RVALID(m_axi_a_rvalid),
        .m_axi_a_WDATA(m_axi_a_wdata),
        .m_axi_a_WID(m_axi_a_wid),
        .m_axi_a_WLAST(m_axi_a_wlast),
        .m_axi_a_WREADY(m_axi_a_wready),
        .m_axi_a_WSTRB(m_axi_a_wstrb),
        .m_axi_a_WVALID(m_axi_a_wvalid),
        .m_axi_b_ARADDR(m_axi_b_araddr),
        .m_axi_b_ARBURST(m_axi_b_arburst),
        .m_axi_b_ARCACHE(m_axi_b_arcache),
        .m_axi_b_ARID(m_axi_b_arid),
        .m_axi_b_ARLEN(m_axi_b_arlen),
        .m_axi_b_ARLOCK(m_axi_b_arlock),
        .m_axi_b_ARPROT(m_axi_b_arprot),
        .m_axi_b_ARQOS(m_axi_b_arqos),
        .m_axi_b_ARREADY(m_axi_b_arready),
        .m_axi_b_ARREGION(m_axi_b_arregion),
        .m_axi_b_ARSIZE(m_axi_b_arsize),
        .m_axi_b_ARVALID(m_axi_b_arvalid),
        .m_axi_b_AWADDR(m_axi_b_awaddr),
        .m_axi_b_AWBURST(m_axi_b_awburst),
        .m_axi_b_AWCACHE(m_axi_b_awcache),
        .m_axi_b_AWID(m_axi_b_awid),
        .m_axi_b_AWLEN(m_axi_b_awlen),
        .m_axi_b_AWLOCK(m_axi_b_awlock),
        .m_axi_b_AWPROT(m_axi_b_awprot),
        .m_axi_b_AWQOS(m_axi_b_awqos),
        .m_axi_b_AWREADY(m_axi_b_awready),
        .m_axi_b_AWREGION(m_axi_b_awregion),
        .m_axi_b_AWSIZE(m_axi_b_awsize),
        .m_axi_b_AWVALID(m_axi_b_awvalid),
        .m_axi_b_BID(m_axi_b_bid),
        .m_axi_b_BREADY(m_axi_b_bready),
        .m_axi_b_BRESP(m_axi_b_bresp),
        .m_axi_b_BVALID(m_axi_b_bvalid),
        .m_axi_b_RDATA(m_axi_b_rdata),
        .m_axi_b_RID(m_axi_b_rid),
        .m_axi_b_RLAST(m_axi_b_rlast),
        .m_axi_b_RREADY(m_axi_b_rready),
        .m_axi_b_RRESP(m_axi_b_rresp),
        .m_axi_b_RVALID(m_axi_b_rvalid),
        .m_axi_b_WDATA(m_axi_b_wdata),
        .m_axi_b_WID(m_axi_b_wid),
        .m_axi_b_WLAST(m_axi_b_wlast),
        .m_axi_b_WREADY(m_axi_b_wready),
        .m_axi_b_WSTRB(m_axi_b_wstrb),
        .m_axi_b_WVALID(m_axi_b_wvalid),
        .m_axi_sum_ARADDR(m_axi_sum_araddr),
        .m_axi_sum_ARBURST(m_axi_sum_arburst),
        .m_axi_sum_ARCACHE(m_axi_sum_arcache),
        .m_axi_sum_ARID(m_axi_sum_arid),
        .m_axi_sum_ARLEN(m_axi_sum_arlen),
        .m_axi_sum_ARLOCK(m_axi_sum_arlock),
        .m_axi_sum_ARPROT(m_axi_sum_arprot),
        .m_axi_sum_ARQOS(m_axi_sum_arqos),
        .m_axi_sum_ARREADY(m_axi_sum_arready),
        .m_axi_sum_ARREGION(m_axi_sum_arregion),
        .m_axi_sum_ARSIZE(m_axi_sum_arsize),
        .m_axi_sum_ARVALID(m_axi_sum_arvalid),
        .m_axi_sum_AWADDR(m_axi_sum_awaddr),
        .m_axi_sum_AWBURST(m_axi_sum_awburst),
        .m_axi_sum_AWCACHE(m_axi_sum_awcache),
        .m_axi_sum_AWID(m_axi_sum_awid),
        .m_axi_sum_AWLEN(m_axi_sum_awlen),
        .m_axi_sum_AWLOCK(m_axi_sum_awlock),
        .m_axi_sum_AWPROT(m_axi_sum_awprot),
        .m_axi_sum_AWQOS(m_axi_sum_awqos),
        .m_axi_sum_AWREADY(m_axi_sum_awready),
        .m_axi_sum_AWREGION(m_axi_sum_awregion),
        .m_axi_sum_AWSIZE(m_axi_sum_awsize),
        .m_axi_sum_AWVALID(m_axi_sum_awvalid),
        .m_axi_sum_BID(m_axi_sum_bid),
        .m_axi_sum_BREADY(m_axi_sum_bready),
        .m_axi_sum_BRESP(m_axi_sum_bresp),
        .m_axi_sum_BVALID(m_axi_sum_bvalid),
        .m_axi_sum_RDATA(m_axi_sum_rdata),
        .m_axi_sum_RID(m_axi_sum_rid),
        .m_axi_sum_RLAST(m_axi_sum_rlast),
        .m_axi_sum_RREADY(m_axi_sum_rready),
        .m_axi_sum_RRESP(m_axi_sum_rresp),
        .m_axi_sum_RVALID(m_axi_sum_rvalid),
        .m_axi_sum_WDATA(m_axi_sum_wdata),
        .m_axi_sum_WID(m_axi_sum_wid),
        .m_axi_sum_WLAST(m_axi_sum_wlast),
        .m_axi_sum_WREADY(m_axi_sum_wready),
        .m_axi_sum_WSTRB(m_axi_sum_wstrb),
        .m_axi_sum_WVALID(m_axi_sum_wvalid),
        .s_axi_control_ARADDR(s_axi_control_araddr),
        .s_axi_control_ARREADY(s_axi_control_arready),
        .s_axi_control_ARVALID(s_axi_control_arvalid),
        .s_axi_control_AWADDR(s_axi_control_awaddr),
        .s_axi_control_AWREADY(s_axi_control_awready),
        .s_axi_control_AWVALID(s_axi_control_awvalid),
        .s_axi_control_BREADY(s_axi_control_bready),
        .s_axi_control_BRESP(s_axi_control_bresp),
        .s_axi_control_BVALID(s_axi_control_bvalid),
        .s_axi_control_RDATA(s_axi_control_rdata),
        .s_axi_control_RREADY(s_axi_control_rready),
        .s_axi_control_RRESP(s_axi_control_rresp),
        .s_axi_control_RVALID(s_axi_control_rvalid),
        .s_axi_control_WDATA(s_axi_control_wdata),
        .s_axi_control_WREADY(s_axi_control_wready),
        .s_axi_control_WSTRB(s_axi_control_wstrb),
        .s_axi_control_WVALID(s_axi_control_wvalid));
endmodule
