// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1.1 (lin64) Build 6233196 Thu Sep 11 21:27:11 MDT 2025
// Date        : Thu Jan 22 16:08:07 2026
// Host        : ece-linlabsrv01 running 64-bit Red Hat Enterprise Linux release 8.10 (Ootpa)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ bd_0_hls_inst_0_stub.v
// Design      : bd_0_hls_inst_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "bd_0_hls_inst_0,top_kernel,{}" *) (* CORE_GENERATION_INFO = "bd_0_hls_inst_0,top_kernel,{x_ipProduct=Vivado 2025.1.1,x_ipVendor=xilinx.com,x_ipLibrary=hls,x_ipName=top_kernel,x_ipVersion=1.0,x_ipCoreRevision=2114447405,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_S_AXI_CONTROL_ADDR_WIDTH=6,C_S_AXI_CONTROL_DATA_WIDTH=32,C_M_AXI_A_ID_WIDTH=1,C_M_AXI_A_ADDR_WIDTH=64,C_M_AXI_A_DATA_WIDTH=32,C_M_AXI_A_AWUSER_WIDTH=1,C_M_AXI_A_ARUSER_WIDTH=1,C_M_AXI_A_WUSER_WIDTH=1,C_M_AXI_A_RUSER_WIDTH=1,C_M_AXI_A_BUSER_WIDTH=1,C_M_AXI_A_USER_VALUE=0x00000000,C_M_AXI_A_PROT_VALUE=000,C_M_AXI_A_CACHE_VALUE=0011,C_M_AXI_B_ID_WIDTH=1,C_M_AXI_B_ADDR_WIDTH=64,C_M_AXI_B_DATA_WIDTH=32,C_M_AXI_B_AWUSER_WIDTH=1,C_M_AXI_B_ARUSER_WIDTH=1,C_M_AXI_B_WUSER_WIDTH=1,C_M_AXI_B_RUSER_WIDTH=1,C_M_AXI_B_BUSER_WIDTH=1,C_M_AXI_B_USER_VALUE=0x00000000,C_M_AXI_B_PROT_VALUE=000,C_M_AXI_B_CACHE_VALUE=0011,C_M_AXI_SUM_ID_WIDTH=1,C_M_AXI_SUM_ADDR_WIDTH=64,C_M_AXI_SUM_DATA_WIDTH=32,C_M_AXI_SUM_AWUSER_WIDTH=1,C_M_AXI_SUM_ARUSER_WIDTH=1,C_M_AXI_SUM_WUSER_WIDTH=1,C_M_AXI_SUM_RUSER_WIDTH=1,C_M_AXI_SUM_BUSER_WIDTH=1,C_M_AXI_SUM_USER_VALUE=0x00000000,C_M_AXI_SUM_PROT_VALUE=000,C_M_AXI_SUM_CACHE_VALUE=0011}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "HLS" *) (* X_CORE_INFO = "top_kernel,Vivado 2025.1.1" *) (* hls_module = "yes" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(s_axi_control_ARADDR, 
  s_axi_control_ARREADY, s_axi_control_ARVALID, s_axi_control_AWADDR, 
  s_axi_control_AWREADY, s_axi_control_AWVALID, s_axi_control_BREADY, 
  s_axi_control_BRESP, s_axi_control_BVALID, s_axi_control_RDATA, s_axi_control_RREADY, 
  s_axi_control_RRESP, s_axi_control_RVALID, s_axi_control_WDATA, s_axi_control_WREADY, 
  s_axi_control_WSTRB, s_axi_control_WVALID, ap_clk, ap_rst_n, interrupt, m_axi_a_ARADDR, 
  m_axi_a_ARBURST, m_axi_a_ARCACHE, m_axi_a_ARID, m_axi_a_ARLEN, m_axi_a_ARLOCK, 
  m_axi_a_ARPROT, m_axi_a_ARQOS, m_axi_a_ARREADY, m_axi_a_ARREGION, m_axi_a_ARSIZE, 
  m_axi_a_ARVALID, m_axi_a_AWADDR, m_axi_a_AWBURST, m_axi_a_AWCACHE, m_axi_a_AWID, 
  m_axi_a_AWLEN, m_axi_a_AWLOCK, m_axi_a_AWPROT, m_axi_a_AWQOS, m_axi_a_AWREADY, 
  m_axi_a_AWREGION, m_axi_a_AWSIZE, m_axi_a_AWVALID, m_axi_a_BID, m_axi_a_BREADY, 
  m_axi_a_BRESP, m_axi_a_BVALID, m_axi_a_RDATA, m_axi_a_RID, m_axi_a_RLAST, m_axi_a_RREADY, 
  m_axi_a_RRESP, m_axi_a_RVALID, m_axi_a_WDATA, m_axi_a_WID, m_axi_a_WLAST, m_axi_a_WREADY, 
  m_axi_a_WSTRB, m_axi_a_WVALID, m_axi_b_ARADDR, m_axi_b_ARBURST, m_axi_b_ARCACHE, 
  m_axi_b_ARID, m_axi_b_ARLEN, m_axi_b_ARLOCK, m_axi_b_ARPROT, m_axi_b_ARQOS, 
  m_axi_b_ARREADY, m_axi_b_ARREGION, m_axi_b_ARSIZE, m_axi_b_ARVALID, m_axi_b_AWADDR, 
  m_axi_b_AWBURST, m_axi_b_AWCACHE, m_axi_b_AWID, m_axi_b_AWLEN, m_axi_b_AWLOCK, 
  m_axi_b_AWPROT, m_axi_b_AWQOS, m_axi_b_AWREADY, m_axi_b_AWREGION, m_axi_b_AWSIZE, 
  m_axi_b_AWVALID, m_axi_b_BID, m_axi_b_BREADY, m_axi_b_BRESP, m_axi_b_BVALID, m_axi_b_RDATA, 
  m_axi_b_RID, m_axi_b_RLAST, m_axi_b_RREADY, m_axi_b_RRESP, m_axi_b_RVALID, m_axi_b_WDATA, 
  m_axi_b_WID, m_axi_b_WLAST, m_axi_b_WREADY, m_axi_b_WSTRB, m_axi_b_WVALID, 
  m_axi_sum_ARADDR, m_axi_sum_ARBURST, m_axi_sum_ARCACHE, m_axi_sum_ARID, m_axi_sum_ARLEN, 
  m_axi_sum_ARLOCK, m_axi_sum_ARPROT, m_axi_sum_ARQOS, m_axi_sum_ARREADY, 
  m_axi_sum_ARREGION, m_axi_sum_ARSIZE, m_axi_sum_ARVALID, m_axi_sum_AWADDR, 
  m_axi_sum_AWBURST, m_axi_sum_AWCACHE, m_axi_sum_AWID, m_axi_sum_AWLEN, m_axi_sum_AWLOCK, 
  m_axi_sum_AWPROT, m_axi_sum_AWQOS, m_axi_sum_AWREADY, m_axi_sum_AWREGION, 
  m_axi_sum_AWSIZE, m_axi_sum_AWVALID, m_axi_sum_BID, m_axi_sum_BREADY, m_axi_sum_BRESP, 
  m_axi_sum_BVALID, m_axi_sum_RDATA, m_axi_sum_RID, m_axi_sum_RLAST, m_axi_sum_RREADY, 
  m_axi_sum_RRESP, m_axi_sum_RVALID, m_axi_sum_WDATA, m_axi_sum_WID, m_axi_sum_WLAST, 
  m_axi_sum_WREADY, m_axi_sum_WSTRB, m_axi_sum_WVALID)
/* synthesis syn_black_box black_box_pad_pin="s_axi_control_ARADDR[5:0],s_axi_control_ARREADY,s_axi_control_ARVALID,s_axi_control_AWADDR[5:0],s_axi_control_AWREADY,s_axi_control_AWVALID,s_axi_control_BREADY,s_axi_control_BRESP[1:0],s_axi_control_BVALID,s_axi_control_RDATA[31:0],s_axi_control_RREADY,s_axi_control_RRESP[1:0],s_axi_control_RVALID,s_axi_control_WDATA[31:0],s_axi_control_WREADY,s_axi_control_WSTRB[3:0],s_axi_control_WVALID,ap_rst_n,interrupt,m_axi_a_ARADDR[63:0],m_axi_a_ARBURST[1:0],m_axi_a_ARCACHE[3:0],m_axi_a_ARID[0:0],m_axi_a_ARLEN[7:0],m_axi_a_ARLOCK[1:0],m_axi_a_ARPROT[2:0],m_axi_a_ARQOS[3:0],m_axi_a_ARREADY,m_axi_a_ARREGION[3:0],m_axi_a_ARSIZE[2:0],m_axi_a_ARVALID,m_axi_a_AWADDR[63:0],m_axi_a_AWBURST[1:0],m_axi_a_AWCACHE[3:0],m_axi_a_AWID[0:0],m_axi_a_AWLEN[7:0],m_axi_a_AWLOCK[1:0],m_axi_a_AWPROT[2:0],m_axi_a_AWQOS[3:0],m_axi_a_AWREADY,m_axi_a_AWREGION[3:0],m_axi_a_AWSIZE[2:0],m_axi_a_AWVALID,m_axi_a_BID[0:0],m_axi_a_BREADY,m_axi_a_BRESP[1:0],m_axi_a_BVALID,m_axi_a_RDATA[31:0],m_axi_a_RID[0:0],m_axi_a_RLAST,m_axi_a_RREADY,m_axi_a_RRESP[1:0],m_axi_a_RVALID,m_axi_a_WDATA[31:0],m_axi_a_WID[0:0],m_axi_a_WLAST,m_axi_a_WREADY,m_axi_a_WSTRB[3:0],m_axi_a_WVALID,m_axi_b_ARADDR[63:0],m_axi_b_ARBURST[1:0],m_axi_b_ARCACHE[3:0],m_axi_b_ARID[0:0],m_axi_b_ARLEN[7:0],m_axi_b_ARLOCK[1:0],m_axi_b_ARPROT[2:0],m_axi_b_ARQOS[3:0],m_axi_b_ARREADY,m_axi_b_ARREGION[3:0],m_axi_b_ARSIZE[2:0],m_axi_b_ARVALID,m_axi_b_AWADDR[63:0],m_axi_b_AWBURST[1:0],m_axi_b_AWCACHE[3:0],m_axi_b_AWID[0:0],m_axi_b_AWLEN[7:0],m_axi_b_AWLOCK[1:0],m_axi_b_AWPROT[2:0],m_axi_b_AWQOS[3:0],m_axi_b_AWREADY,m_axi_b_AWREGION[3:0],m_axi_b_AWSIZE[2:0],m_axi_b_AWVALID,m_axi_b_BID[0:0],m_axi_b_BREADY,m_axi_b_BRESP[1:0],m_axi_b_BVALID,m_axi_b_RDATA[31:0],m_axi_b_RID[0:0],m_axi_b_RLAST,m_axi_b_RREADY,m_axi_b_RRESP[1:0],m_axi_b_RVALID,m_axi_b_WDATA[31:0],m_axi_b_WID[0:0],m_axi_b_WLAST,m_axi_b_WREADY,m_axi_b_WSTRB[3:0],m_axi_b_WVALID,m_axi_sum_ARADDR[63:0],m_axi_sum_ARBURST[1:0],m_axi_sum_ARCACHE[3:0],m_axi_sum_ARID[0:0],m_axi_sum_ARLEN[7:0],m_axi_sum_ARLOCK[1:0],m_axi_sum_ARPROT[2:0],m_axi_sum_ARQOS[3:0],m_axi_sum_ARREADY,m_axi_sum_ARREGION[3:0],m_axi_sum_ARSIZE[2:0],m_axi_sum_ARVALID,m_axi_sum_AWADDR[63:0],m_axi_sum_AWBURST[1:0],m_axi_sum_AWCACHE[3:0],m_axi_sum_AWID[0:0],m_axi_sum_AWLEN[7:0],m_axi_sum_AWLOCK[1:0],m_axi_sum_AWPROT[2:0],m_axi_sum_AWQOS[3:0],m_axi_sum_AWREADY,m_axi_sum_AWREGION[3:0],m_axi_sum_AWSIZE[2:0],m_axi_sum_AWVALID,m_axi_sum_BID[0:0],m_axi_sum_BREADY,m_axi_sum_BRESP[1:0],m_axi_sum_BVALID,m_axi_sum_RDATA[31:0],m_axi_sum_RID[0:0],m_axi_sum_RLAST,m_axi_sum_RREADY,m_axi_sum_RRESP[1:0],m_axi_sum_RVALID,m_axi_sum_WDATA[31:0],m_axi_sum_WID[0:0],m_axi_sum_WLAST,m_axi_sum_WREADY,m_axi_sum_WSTRB[3:0],m_axi_sum_WVALID" */
/* synthesis syn_force_seq_prim="ap_clk" */;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control ARADDR" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_control, ADDR_WIDTH 6, DATA_WIDTH 32, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000.0, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN bd_0_ap_clk_0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [5:0]s_axi_control_ARADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control ARREADY" *) output s_axi_control_ARREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control ARVALID" *) input s_axi_control_ARVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control AWADDR" *) input [5:0]s_axi_control_AWADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control AWREADY" *) output s_axi_control_AWREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control AWVALID" *) input s_axi_control_AWVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control BREADY" *) input s_axi_control_BREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control BRESP" *) output [1:0]s_axi_control_BRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control BVALID" *) output s_axi_control_BVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RDATA" *) output [31:0]s_axi_control_RDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RREADY" *) input s_axi_control_RREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RRESP" *) output [1:0]s_axi_control_RRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RVALID" *) output s_axi_control_RVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WDATA" *) input [31:0]s_axi_control_WDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WREADY" *) output s_axi_control_WREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WSTRB" *) input [3:0]s_axi_control_WSTRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WVALID" *) input s_axi_control_WVALID;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_clk, ASSOCIATED_BUSIF s_axi_control:m_axi_a:m_axi_b:m_axi_sum, ASSOCIATED_RESET ap_rst_n, FREQ_HZ 100000000.0, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN bd_0_ap_clk_0, INSERT_VIP 0" *) input ap_clk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input ap_rst_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1" *) output interrupt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARADDR" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axi_a, NUM_READ_OUTSTANDING 16, NUM_WRITE_OUTSTANDING 16, MAX_READ_BURST_LENGTH 16, MAX_WRITE_BURST_LENGTH 16, MAX_BURST_LENGTH 256, PROTOCOL AXI4, READ_WRITE_MODE READ_ONLY, HAS_BURST 0, SUPPORTS_NARROW_BURST 0, ADDR_WIDTH 64, DATA_WIDTH 32, FREQ_HZ 100000000.0, ID_WIDTH 1, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, PHASE 0.0, CLK_DOMAIN bd_0_ap_clk_0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output [63:0]m_axi_a_ARADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARBURST" *) output [1:0]m_axi_a_ARBURST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARCACHE" *) output [3:0]m_axi_a_ARCACHE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARID" *) output [0:0]m_axi_a_ARID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARLEN" *) output [7:0]m_axi_a_ARLEN;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARLOCK" *) output [1:0]m_axi_a_ARLOCK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARPROT" *) output [2:0]m_axi_a_ARPROT;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARQOS" *) output [3:0]m_axi_a_ARQOS;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARREADY" *) input m_axi_a_ARREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARREGION" *) output [3:0]m_axi_a_ARREGION;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARSIZE" *) output [2:0]m_axi_a_ARSIZE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a ARVALID" *) output m_axi_a_ARVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWADDR" *) output [63:0]m_axi_a_AWADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWBURST" *) output [1:0]m_axi_a_AWBURST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWCACHE" *) output [3:0]m_axi_a_AWCACHE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWID" *) output [0:0]m_axi_a_AWID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWLEN" *) output [7:0]m_axi_a_AWLEN;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWLOCK" *) output [1:0]m_axi_a_AWLOCK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWPROT" *) output [2:0]m_axi_a_AWPROT;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWQOS" *) output [3:0]m_axi_a_AWQOS;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWREADY" *) input m_axi_a_AWREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWREGION" *) output [3:0]m_axi_a_AWREGION;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWSIZE" *) output [2:0]m_axi_a_AWSIZE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a AWVALID" *) output m_axi_a_AWVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a BID" *) input [0:0]m_axi_a_BID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a BREADY" *) output m_axi_a_BREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a BRESP" *) input [1:0]m_axi_a_BRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a BVALID" *) input m_axi_a_BVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RDATA" *) input [31:0]m_axi_a_RDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RID" *) input [0:0]m_axi_a_RID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RLAST" *) input m_axi_a_RLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RREADY" *) output m_axi_a_RREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RRESP" *) input [1:0]m_axi_a_RRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a RVALID" *) input m_axi_a_RVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WDATA" *) output [31:0]m_axi_a_WDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WID" *) output [0:0]m_axi_a_WID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WLAST" *) output m_axi_a_WLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WREADY" *) input m_axi_a_WREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WSTRB" *) output [3:0]m_axi_a_WSTRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_a WVALID" *) output m_axi_a_WVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARADDR" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axi_b, NUM_READ_OUTSTANDING 16, NUM_WRITE_OUTSTANDING 16, MAX_READ_BURST_LENGTH 16, MAX_WRITE_BURST_LENGTH 16, MAX_BURST_LENGTH 256, PROTOCOL AXI4, READ_WRITE_MODE READ_ONLY, HAS_BURST 0, SUPPORTS_NARROW_BURST 0, ADDR_WIDTH 64, DATA_WIDTH 32, FREQ_HZ 100000000.0, ID_WIDTH 1, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, PHASE 0.0, CLK_DOMAIN bd_0_ap_clk_0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output [63:0]m_axi_b_ARADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARBURST" *) output [1:0]m_axi_b_ARBURST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARCACHE" *) output [3:0]m_axi_b_ARCACHE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARID" *) output [0:0]m_axi_b_ARID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARLEN" *) output [7:0]m_axi_b_ARLEN;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARLOCK" *) output [1:0]m_axi_b_ARLOCK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARPROT" *) output [2:0]m_axi_b_ARPROT;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARQOS" *) output [3:0]m_axi_b_ARQOS;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARREADY" *) input m_axi_b_ARREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARREGION" *) output [3:0]m_axi_b_ARREGION;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARSIZE" *) output [2:0]m_axi_b_ARSIZE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b ARVALID" *) output m_axi_b_ARVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWADDR" *) output [63:0]m_axi_b_AWADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWBURST" *) output [1:0]m_axi_b_AWBURST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWCACHE" *) output [3:0]m_axi_b_AWCACHE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWID" *) output [0:0]m_axi_b_AWID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWLEN" *) output [7:0]m_axi_b_AWLEN;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWLOCK" *) output [1:0]m_axi_b_AWLOCK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWPROT" *) output [2:0]m_axi_b_AWPROT;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWQOS" *) output [3:0]m_axi_b_AWQOS;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWREADY" *) input m_axi_b_AWREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWREGION" *) output [3:0]m_axi_b_AWREGION;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWSIZE" *) output [2:0]m_axi_b_AWSIZE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b AWVALID" *) output m_axi_b_AWVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b BID" *) input [0:0]m_axi_b_BID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b BREADY" *) output m_axi_b_BREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b BRESP" *) input [1:0]m_axi_b_BRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b BVALID" *) input m_axi_b_BVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RDATA" *) input [31:0]m_axi_b_RDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RID" *) input [0:0]m_axi_b_RID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RLAST" *) input m_axi_b_RLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RREADY" *) output m_axi_b_RREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RRESP" *) input [1:0]m_axi_b_RRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b RVALID" *) input m_axi_b_RVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WDATA" *) output [31:0]m_axi_b_WDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WID" *) output [0:0]m_axi_b_WID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WLAST" *) output m_axi_b_WLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WREADY" *) input m_axi_b_WREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WSTRB" *) output [3:0]m_axi_b_WSTRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_b WVALID" *) output m_axi_b_WVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARADDR" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axi_sum, NUM_READ_OUTSTANDING 16, NUM_WRITE_OUTSTANDING 16, MAX_READ_BURST_LENGTH 16, MAX_WRITE_BURST_LENGTH 16, MAX_BURST_LENGTH 256, PROTOCOL AXI4, READ_WRITE_MODE WRITE_ONLY, HAS_BURST 0, SUPPORTS_NARROW_BURST 0, ADDR_WIDTH 64, DATA_WIDTH 32, FREQ_HZ 100000000.0, ID_WIDTH 1, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, PHASE 0.0, CLK_DOMAIN bd_0_ap_clk_0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output [63:0]m_axi_sum_ARADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARBURST" *) output [1:0]m_axi_sum_ARBURST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARCACHE" *) output [3:0]m_axi_sum_ARCACHE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARID" *) output [0:0]m_axi_sum_ARID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARLEN" *) output [7:0]m_axi_sum_ARLEN;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARLOCK" *) output [1:0]m_axi_sum_ARLOCK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARPROT" *) output [2:0]m_axi_sum_ARPROT;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARQOS" *) output [3:0]m_axi_sum_ARQOS;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARREADY" *) input m_axi_sum_ARREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARREGION" *) output [3:0]m_axi_sum_ARREGION;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARSIZE" *) output [2:0]m_axi_sum_ARSIZE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum ARVALID" *) output m_axi_sum_ARVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWADDR" *) output [63:0]m_axi_sum_AWADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWBURST" *) output [1:0]m_axi_sum_AWBURST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWCACHE" *) output [3:0]m_axi_sum_AWCACHE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWID" *) output [0:0]m_axi_sum_AWID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWLEN" *) output [7:0]m_axi_sum_AWLEN;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWLOCK" *) output [1:0]m_axi_sum_AWLOCK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWPROT" *) output [2:0]m_axi_sum_AWPROT;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWQOS" *) output [3:0]m_axi_sum_AWQOS;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWREADY" *) input m_axi_sum_AWREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWREGION" *) output [3:0]m_axi_sum_AWREGION;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWSIZE" *) output [2:0]m_axi_sum_AWSIZE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum AWVALID" *) output m_axi_sum_AWVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum BID" *) input [0:0]m_axi_sum_BID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum BREADY" *) output m_axi_sum_BREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum BRESP" *) input [1:0]m_axi_sum_BRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum BVALID" *) input m_axi_sum_BVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RDATA" *) input [31:0]m_axi_sum_RDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RID" *) input [0:0]m_axi_sum_RID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RLAST" *) input m_axi_sum_RLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RREADY" *) output m_axi_sum_RREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RRESP" *) input [1:0]m_axi_sum_RRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum RVALID" *) input m_axi_sum_RVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WDATA" *) output [31:0]m_axi_sum_WDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WID" *) output [0:0]m_axi_sum_WID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WLAST" *) output m_axi_sum_WLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WREADY" *) input m_axi_sum_WREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WSTRB" *) output [3:0]m_axi_sum_WSTRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_sum WVALID" *) output m_axi_sum_WVALID;
endmodule
