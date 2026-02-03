set moduleName top_kernel
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set isPipelined_legacy 0
set pipeline_type loop_auto_rewind
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 2
set C_modelName {top_kernel}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ a int 32 regular {axi_master 0}  }
	{ b int 32 regular {axi_master 0}  }
	{ sum int 32 regular {axi_master 1}  }
	{ a_r int 64 regular {axi_slave 0}  }
	{ b_r int 64 regular {axi_slave 0}  }
	{ sum_r int 64 regular {axi_slave 0}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "a", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_r","offset": { "type": "dynamic","port_name": "a_r","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "b", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_r","offset": { "type": "dynamic","port_name": "b_r","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "sum", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "sum_r","offset": { "type": "dynamic","port_name": "sum_r","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "a_r", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":16}, "offset_end" : {"in":27}} , 
 	{ "Name" : "b_r", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":28}, "offset_end" : {"in":39}} , 
 	{ "Name" : "sum_r", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":40}, "offset_end" : {"in":51}} ]}
# RTL Port declarations: 
set portNum 155
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ m_axi_a_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_AWADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_a_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_AWLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_a_AWSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_a_AWBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_a_AWLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_a_AWCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_AWPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_a_AWQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_AWREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_AWUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_WVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_WREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_WDATA sc_out sc_lv 32 signal 0 } 
	{ m_axi_a_WSTRB sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_WLAST sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_WID sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_WUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_ARVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_ARREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_ARADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_a_ARID sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_ARLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_a_ARSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_a_ARBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_a_ARLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_a_ARCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_ARPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_a_ARQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_ARREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_ARUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_RVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_RREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_RDATA sc_in sc_lv 32 signal 0 } 
	{ m_axi_a_RLAST sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_RID sc_in sc_lv 1 signal 0 } 
	{ m_axi_a_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_a_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_a_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_a_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_a_BUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_b_AWVALID sc_out sc_logic 1 signal 1 } 
	{ m_axi_b_AWREADY sc_in sc_logic 1 signal 1 } 
	{ m_axi_b_AWADDR sc_out sc_lv 64 signal 1 } 
	{ m_axi_b_AWID sc_out sc_lv 1 signal 1 } 
	{ m_axi_b_AWLEN sc_out sc_lv 8 signal 1 } 
	{ m_axi_b_AWSIZE sc_out sc_lv 3 signal 1 } 
	{ m_axi_b_AWBURST sc_out sc_lv 2 signal 1 } 
	{ m_axi_b_AWLOCK sc_out sc_lv 2 signal 1 } 
	{ m_axi_b_AWCACHE sc_out sc_lv 4 signal 1 } 
	{ m_axi_b_AWPROT sc_out sc_lv 3 signal 1 } 
	{ m_axi_b_AWQOS sc_out sc_lv 4 signal 1 } 
	{ m_axi_b_AWREGION sc_out sc_lv 4 signal 1 } 
	{ m_axi_b_AWUSER sc_out sc_lv 1 signal 1 } 
	{ m_axi_b_WVALID sc_out sc_logic 1 signal 1 } 
	{ m_axi_b_WREADY sc_in sc_logic 1 signal 1 } 
	{ m_axi_b_WDATA sc_out sc_lv 32 signal 1 } 
	{ m_axi_b_WSTRB sc_out sc_lv 4 signal 1 } 
	{ m_axi_b_WLAST sc_out sc_logic 1 signal 1 } 
	{ m_axi_b_WID sc_out sc_lv 1 signal 1 } 
	{ m_axi_b_WUSER sc_out sc_lv 1 signal 1 } 
	{ m_axi_b_ARVALID sc_out sc_logic 1 signal 1 } 
	{ m_axi_b_ARREADY sc_in sc_logic 1 signal 1 } 
	{ m_axi_b_ARADDR sc_out sc_lv 64 signal 1 } 
	{ m_axi_b_ARID sc_out sc_lv 1 signal 1 } 
	{ m_axi_b_ARLEN sc_out sc_lv 8 signal 1 } 
	{ m_axi_b_ARSIZE sc_out sc_lv 3 signal 1 } 
	{ m_axi_b_ARBURST sc_out sc_lv 2 signal 1 } 
	{ m_axi_b_ARLOCK sc_out sc_lv 2 signal 1 } 
	{ m_axi_b_ARCACHE sc_out sc_lv 4 signal 1 } 
	{ m_axi_b_ARPROT sc_out sc_lv 3 signal 1 } 
	{ m_axi_b_ARQOS sc_out sc_lv 4 signal 1 } 
	{ m_axi_b_ARREGION sc_out sc_lv 4 signal 1 } 
	{ m_axi_b_ARUSER sc_out sc_lv 1 signal 1 } 
	{ m_axi_b_RVALID sc_in sc_logic 1 signal 1 } 
	{ m_axi_b_RREADY sc_out sc_logic 1 signal 1 } 
	{ m_axi_b_RDATA sc_in sc_lv 32 signal 1 } 
	{ m_axi_b_RLAST sc_in sc_logic 1 signal 1 } 
	{ m_axi_b_RID sc_in sc_lv 1 signal 1 } 
	{ m_axi_b_RUSER sc_in sc_lv 1 signal 1 } 
	{ m_axi_b_RRESP sc_in sc_lv 2 signal 1 } 
	{ m_axi_b_BVALID sc_in sc_logic 1 signal 1 } 
	{ m_axi_b_BREADY sc_out sc_logic 1 signal 1 } 
	{ m_axi_b_BRESP sc_in sc_lv 2 signal 1 } 
	{ m_axi_b_BID sc_in sc_lv 1 signal 1 } 
	{ m_axi_b_BUSER sc_in sc_lv 1 signal 1 } 
	{ m_axi_sum_AWVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_sum_AWREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_sum_AWADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_sum_AWID sc_out sc_lv 1 signal 2 } 
	{ m_axi_sum_AWLEN sc_out sc_lv 8 signal 2 } 
	{ m_axi_sum_AWSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_sum_AWBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_sum_AWLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_sum_AWCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_sum_AWPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_sum_AWQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_sum_AWREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_sum_AWUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_sum_WVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_sum_WREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_sum_WDATA sc_out sc_lv 32 signal 2 } 
	{ m_axi_sum_WSTRB sc_out sc_lv 4 signal 2 } 
	{ m_axi_sum_WLAST sc_out sc_logic 1 signal 2 } 
	{ m_axi_sum_WID sc_out sc_lv 1 signal 2 } 
	{ m_axi_sum_WUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_sum_ARVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_sum_ARREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_sum_ARADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_sum_ARID sc_out sc_lv 1 signal 2 } 
	{ m_axi_sum_ARLEN sc_out sc_lv 8 signal 2 } 
	{ m_axi_sum_ARSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_sum_ARBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_sum_ARLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_sum_ARCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_sum_ARPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_sum_ARQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_sum_ARREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_sum_ARUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_sum_RVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_sum_RREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_sum_RDATA sc_in sc_lv 32 signal 2 } 
	{ m_axi_sum_RLAST sc_in sc_logic 1 signal 2 } 
	{ m_axi_sum_RID sc_in sc_lv 1 signal 2 } 
	{ m_axi_sum_RUSER sc_in sc_lv 1 signal 2 } 
	{ m_axi_sum_RRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_sum_BVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_sum_BREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_sum_BRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_sum_BID sc_in sc_lv 1 signal 2 } 
	{ m_axi_sum_BUSER sc_in sc_lv 1 signal 2 } 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_control_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_control_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_BRESP sc_out sc_lv 2 signal -1 } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
}
set NewPortList {[ 
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"top_kernel","role":"start","value":"0","valid_bit":"0"},{"name":"top_kernel","role":"continue","value":"0","valid_bit":"4"},{"name":"top_kernel","role":"auto_start","value":"0","valid_bit":"7"},{"name":"a_r","role":"data","value":"16"},{"name":"b_r","role":"data","value":"28"},{"name":"sum_r","role":"data","value":"40"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"top_kernel","role":"start","value":"0","valid_bit":"0"},{"name":"top_kernel","role":"done","value":"0","valid_bit":"1"},{"name":"top_kernel","role":"idle","value":"0","valid_bit":"2"},{"name":"top_kernel","role":"ready","value":"0","valid_bit":"3"},{"name":"top_kernel","role":"auto_start","value":"0","valid_bit":"7"}] },
	{ "name": "s_axi_control_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARVALID" } },
	{ "name": "s_axi_control_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARREADY" } },
	{ "name": "s_axi_control_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RVALID" } },
	{ "name": "s_axi_control_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RREADY" } },
	{ "name": "s_axi_control_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "RDATA" } },
	{ "name": "s_axi_control_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "RRESP" } },
	{ "name": "s_axi_control_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BVALID" } },
	{ "name": "s_axi_control_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BREADY" } },
	{ "name": "s_axi_control_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "BRESP" } },
	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "interrupt" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "m_axi_a_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "AWVALID" }} , 
 	{ "name": "m_axi_a_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "AWREADY" }} , 
 	{ "name": "m_axi_a_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "a", "role": "AWADDR" }} , 
 	{ "name": "m_axi_a_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "AWID" }} , 
 	{ "name": "m_axi_a_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "a", "role": "AWLEN" }} , 
 	{ "name": "m_axi_a_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "a", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_a_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a", "role": "AWBURST" }} , 
 	{ "name": "m_axi_a_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_a_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_a_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "a", "role": "AWPROT" }} , 
 	{ "name": "m_axi_a_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a", "role": "AWQOS" }} , 
 	{ "name": "m_axi_a_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a", "role": "AWREGION" }} , 
 	{ "name": "m_axi_a_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "AWUSER" }} , 
 	{ "name": "m_axi_a_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "WVALID" }} , 
 	{ "name": "m_axi_a_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "WREADY" }} , 
 	{ "name": "m_axi_a_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "a", "role": "WDATA" }} , 
 	{ "name": "m_axi_a_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a", "role": "WSTRB" }} , 
 	{ "name": "m_axi_a_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "WLAST" }} , 
 	{ "name": "m_axi_a_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "WID" }} , 
 	{ "name": "m_axi_a_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "WUSER" }} , 
 	{ "name": "m_axi_a_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "ARVALID" }} , 
 	{ "name": "m_axi_a_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "ARREADY" }} , 
 	{ "name": "m_axi_a_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "a", "role": "ARADDR" }} , 
 	{ "name": "m_axi_a_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "ARID" }} , 
 	{ "name": "m_axi_a_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "a", "role": "ARLEN" }} , 
 	{ "name": "m_axi_a_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "a", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_a_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a", "role": "ARBURST" }} , 
 	{ "name": "m_axi_a_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_a_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_a_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "a", "role": "ARPROT" }} , 
 	{ "name": "m_axi_a_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a", "role": "ARQOS" }} , 
 	{ "name": "m_axi_a_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a", "role": "ARREGION" }} , 
 	{ "name": "m_axi_a_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "ARUSER" }} , 
 	{ "name": "m_axi_a_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "RVALID" }} , 
 	{ "name": "m_axi_a_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "RREADY" }} , 
 	{ "name": "m_axi_a_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "a", "role": "RDATA" }} , 
 	{ "name": "m_axi_a_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "RLAST" }} , 
 	{ "name": "m_axi_a_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "RID" }} , 
 	{ "name": "m_axi_a_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "RUSER" }} , 
 	{ "name": "m_axi_a_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a", "role": "RRESP" }} , 
 	{ "name": "m_axi_a_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "BVALID" }} , 
 	{ "name": "m_axi_a_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "BREADY" }} , 
 	{ "name": "m_axi_a_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a", "role": "BRESP" }} , 
 	{ "name": "m_axi_a_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "BID" }} , 
 	{ "name": "m_axi_a_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "BUSER" }} , 
 	{ "name": "m_axi_b_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "AWVALID" }} , 
 	{ "name": "m_axi_b_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "AWREADY" }} , 
 	{ "name": "m_axi_b_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "b", "role": "AWADDR" }} , 
 	{ "name": "m_axi_b_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "AWID" }} , 
 	{ "name": "m_axi_b_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "b", "role": "AWLEN" }} , 
 	{ "name": "m_axi_b_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "b", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_b_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "b", "role": "AWBURST" }} , 
 	{ "name": "m_axi_b_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "b", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_b_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "b", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_b_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "b", "role": "AWPROT" }} , 
 	{ "name": "m_axi_b_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "b", "role": "AWQOS" }} , 
 	{ "name": "m_axi_b_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "b", "role": "AWREGION" }} , 
 	{ "name": "m_axi_b_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "AWUSER" }} , 
 	{ "name": "m_axi_b_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "WVALID" }} , 
 	{ "name": "m_axi_b_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "WREADY" }} , 
 	{ "name": "m_axi_b_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "b", "role": "WDATA" }} , 
 	{ "name": "m_axi_b_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "b", "role": "WSTRB" }} , 
 	{ "name": "m_axi_b_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "WLAST" }} , 
 	{ "name": "m_axi_b_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "WID" }} , 
 	{ "name": "m_axi_b_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "WUSER" }} , 
 	{ "name": "m_axi_b_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "ARVALID" }} , 
 	{ "name": "m_axi_b_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "ARREADY" }} , 
 	{ "name": "m_axi_b_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "b", "role": "ARADDR" }} , 
 	{ "name": "m_axi_b_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "ARID" }} , 
 	{ "name": "m_axi_b_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "b", "role": "ARLEN" }} , 
 	{ "name": "m_axi_b_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "b", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_b_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "b", "role": "ARBURST" }} , 
 	{ "name": "m_axi_b_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "b", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_b_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "b", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_b_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "b", "role": "ARPROT" }} , 
 	{ "name": "m_axi_b_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "b", "role": "ARQOS" }} , 
 	{ "name": "m_axi_b_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "b", "role": "ARREGION" }} , 
 	{ "name": "m_axi_b_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "ARUSER" }} , 
 	{ "name": "m_axi_b_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "RVALID" }} , 
 	{ "name": "m_axi_b_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "RREADY" }} , 
 	{ "name": "m_axi_b_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "b", "role": "RDATA" }} , 
 	{ "name": "m_axi_b_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "RLAST" }} , 
 	{ "name": "m_axi_b_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "RID" }} , 
 	{ "name": "m_axi_b_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "RUSER" }} , 
 	{ "name": "m_axi_b_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "b", "role": "RRESP" }} , 
 	{ "name": "m_axi_b_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "BVALID" }} , 
 	{ "name": "m_axi_b_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "BREADY" }} , 
 	{ "name": "m_axi_b_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "b", "role": "BRESP" }} , 
 	{ "name": "m_axi_b_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "BID" }} , 
 	{ "name": "m_axi_b_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "BUSER" }} , 
 	{ "name": "m_axi_sum_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "AWVALID" }} , 
 	{ "name": "m_axi_sum_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "AWREADY" }} , 
 	{ "name": "m_axi_sum_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "sum", "role": "AWADDR" }} , 
 	{ "name": "m_axi_sum_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "AWID" }} , 
 	{ "name": "m_axi_sum_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sum", "role": "AWLEN" }} , 
 	{ "name": "m_axi_sum_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "sum", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_sum_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "sum", "role": "AWBURST" }} , 
 	{ "name": "m_axi_sum_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "sum", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_sum_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "sum", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_sum_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "sum", "role": "AWPROT" }} , 
 	{ "name": "m_axi_sum_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "sum", "role": "AWQOS" }} , 
 	{ "name": "m_axi_sum_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "sum", "role": "AWREGION" }} , 
 	{ "name": "m_axi_sum_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "AWUSER" }} , 
 	{ "name": "m_axi_sum_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "WVALID" }} , 
 	{ "name": "m_axi_sum_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "WREADY" }} , 
 	{ "name": "m_axi_sum_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "sum", "role": "WDATA" }} , 
 	{ "name": "m_axi_sum_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "sum", "role": "WSTRB" }} , 
 	{ "name": "m_axi_sum_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "WLAST" }} , 
 	{ "name": "m_axi_sum_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "WID" }} , 
 	{ "name": "m_axi_sum_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "WUSER" }} , 
 	{ "name": "m_axi_sum_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "ARVALID" }} , 
 	{ "name": "m_axi_sum_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "ARREADY" }} , 
 	{ "name": "m_axi_sum_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "sum", "role": "ARADDR" }} , 
 	{ "name": "m_axi_sum_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "ARID" }} , 
 	{ "name": "m_axi_sum_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sum", "role": "ARLEN" }} , 
 	{ "name": "m_axi_sum_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "sum", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_sum_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "sum", "role": "ARBURST" }} , 
 	{ "name": "m_axi_sum_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "sum", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_sum_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "sum", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_sum_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "sum", "role": "ARPROT" }} , 
 	{ "name": "m_axi_sum_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "sum", "role": "ARQOS" }} , 
 	{ "name": "m_axi_sum_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "sum", "role": "ARREGION" }} , 
 	{ "name": "m_axi_sum_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "ARUSER" }} , 
 	{ "name": "m_axi_sum_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "RVALID" }} , 
 	{ "name": "m_axi_sum_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "RREADY" }} , 
 	{ "name": "m_axi_sum_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "sum", "role": "RDATA" }} , 
 	{ "name": "m_axi_sum_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "RLAST" }} , 
 	{ "name": "m_axi_sum_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "RID" }} , 
 	{ "name": "m_axi_sum_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "RUSER" }} , 
 	{ "name": "m_axi_sum_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "sum", "role": "RRESP" }} , 
 	{ "name": "m_axi_sum_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "BVALID" }} , 
 	{ "name": "m_axi_sum_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "BREADY" }} , 
 	{ "name": "m_axi_sum_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "sum", "role": "BRESP" }} , 
 	{ "name": "m_axi_sum_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "BID" }} , 
 	{ "name": "m_axi_sum_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sum", "role": "BUSER" }}  ]}

set ArgLastReadFirstWriteLatency {
	top_kernel {
		a {Type I LastRead 9 FirstWrite -1}
		b {Type I LastRead 9 FirstWrite -1}
		sum {Type O LastRead 12 FirstWrite 11}
		a_r {Type I LastRead 0 FirstWrite -1}
		b_r {Type I LastRead 0 FirstWrite -1}
		sum_r {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "117", "Max" : "117"}
	, {"Name" : "Interval", "Min" : "118", "Max" : "118"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	a { m_axi {  { m_axi_a_AWVALID VALID 1 1 }  { m_axi_a_AWREADY READY 0 1 }  { m_axi_a_AWADDR ADDR 1 64 }  { m_axi_a_AWID ID 1 1 }  { m_axi_a_AWLEN SIZE 1 8 }  { m_axi_a_AWSIZE BURST 1 3 }  { m_axi_a_AWBURST LOCK 1 2 }  { m_axi_a_AWLOCK CACHE 1 2 }  { m_axi_a_AWCACHE PROT 1 4 }  { m_axi_a_AWPROT QOS 1 3 }  { m_axi_a_AWQOS REGION 1 4 }  { m_axi_a_AWREGION USER 1 4 }  { m_axi_a_AWUSER DATA 1 1 }  { m_axi_a_WVALID VALID 1 1 }  { m_axi_a_WREADY READY 0 1 }  { m_axi_a_WDATA FIFONUM 1 32 }  { m_axi_a_WSTRB STRB 1 4 }  { m_axi_a_WLAST LAST 1 1 }  { m_axi_a_WID ID 1 1 }  { m_axi_a_WUSER DATA 1 1 }  { m_axi_a_ARVALID VALID 1 1 }  { m_axi_a_ARREADY READY 0 1 }  { m_axi_a_ARADDR ADDR 1 64 }  { m_axi_a_ARID ID 1 1 }  { m_axi_a_ARLEN SIZE 1 8 }  { m_axi_a_ARSIZE BURST 1 3 }  { m_axi_a_ARBURST LOCK 1 2 }  { m_axi_a_ARLOCK CACHE 1 2 }  { m_axi_a_ARCACHE PROT 1 4 }  { m_axi_a_ARPROT QOS 1 3 }  { m_axi_a_ARQOS REGION 1 4 }  { m_axi_a_ARREGION USER 1 4 }  { m_axi_a_ARUSER DATA 1 1 }  { m_axi_a_RVALID VALID 0 1 }  { m_axi_a_RREADY READY 1 1 }  { m_axi_a_RDATA FIFONUM 0 32 }  { m_axi_a_RLAST LAST 0 1 }  { m_axi_a_RID ID 0 1 }  { m_axi_a_RUSER DATA 0 1 }  { m_axi_a_RRESP RESP 0 2 }  { m_axi_a_BVALID VALID 0 1 }  { m_axi_a_BREADY READY 1 1 }  { m_axi_a_BRESP RESP 0 2 }  { m_axi_a_BID ID 0 1 }  { m_axi_a_BUSER DATA 0 1 } } }
	b { m_axi {  { m_axi_b_AWVALID VALID 1 1 }  { m_axi_b_AWREADY READY 0 1 }  { m_axi_b_AWADDR ADDR 1 64 }  { m_axi_b_AWID ID 1 1 }  { m_axi_b_AWLEN SIZE 1 8 }  { m_axi_b_AWSIZE BURST 1 3 }  { m_axi_b_AWBURST LOCK 1 2 }  { m_axi_b_AWLOCK CACHE 1 2 }  { m_axi_b_AWCACHE PROT 1 4 }  { m_axi_b_AWPROT QOS 1 3 }  { m_axi_b_AWQOS REGION 1 4 }  { m_axi_b_AWREGION USER 1 4 }  { m_axi_b_AWUSER DATA 1 1 }  { m_axi_b_WVALID VALID 1 1 }  { m_axi_b_WREADY READY 0 1 }  { m_axi_b_WDATA FIFONUM 1 32 }  { m_axi_b_WSTRB STRB 1 4 }  { m_axi_b_WLAST LAST 1 1 }  { m_axi_b_WID ID 1 1 }  { m_axi_b_WUSER DATA 1 1 }  { m_axi_b_ARVALID VALID 1 1 }  { m_axi_b_ARREADY READY 0 1 }  { m_axi_b_ARADDR ADDR 1 64 }  { m_axi_b_ARID ID 1 1 }  { m_axi_b_ARLEN SIZE 1 8 }  { m_axi_b_ARSIZE BURST 1 3 }  { m_axi_b_ARBURST LOCK 1 2 }  { m_axi_b_ARLOCK CACHE 1 2 }  { m_axi_b_ARCACHE PROT 1 4 }  { m_axi_b_ARPROT QOS 1 3 }  { m_axi_b_ARQOS REGION 1 4 }  { m_axi_b_ARREGION USER 1 4 }  { m_axi_b_ARUSER DATA 1 1 }  { m_axi_b_RVALID VALID 0 1 }  { m_axi_b_RREADY READY 1 1 }  { m_axi_b_RDATA FIFONUM 0 32 }  { m_axi_b_RLAST LAST 0 1 }  { m_axi_b_RID ID 0 1 }  { m_axi_b_RUSER DATA 0 1 }  { m_axi_b_RRESP RESP 0 2 }  { m_axi_b_BVALID VALID 0 1 }  { m_axi_b_BREADY READY 1 1 }  { m_axi_b_BRESP RESP 0 2 }  { m_axi_b_BID ID 0 1 }  { m_axi_b_BUSER DATA 0 1 } } }
	sum { m_axi {  { m_axi_sum_AWVALID VALID 1 1 }  { m_axi_sum_AWREADY READY 0 1 }  { m_axi_sum_AWADDR ADDR 1 64 }  { m_axi_sum_AWID ID 1 1 }  { m_axi_sum_AWLEN SIZE 1 8 }  { m_axi_sum_AWSIZE BURST 1 3 }  { m_axi_sum_AWBURST LOCK 1 2 }  { m_axi_sum_AWLOCK CACHE 1 2 }  { m_axi_sum_AWCACHE PROT 1 4 }  { m_axi_sum_AWPROT QOS 1 3 }  { m_axi_sum_AWQOS REGION 1 4 }  { m_axi_sum_AWREGION USER 1 4 }  { m_axi_sum_AWUSER DATA 1 1 }  { m_axi_sum_WVALID VALID 1 1 }  { m_axi_sum_WREADY READY 0 1 }  { m_axi_sum_WDATA FIFONUM 1 32 }  { m_axi_sum_WSTRB STRB 1 4 }  { m_axi_sum_WLAST LAST 1 1 }  { m_axi_sum_WID ID 1 1 }  { m_axi_sum_WUSER DATA 1 1 }  { m_axi_sum_ARVALID VALID 1 1 }  { m_axi_sum_ARREADY READY 0 1 }  { m_axi_sum_ARADDR ADDR 1 64 }  { m_axi_sum_ARID ID 1 1 }  { m_axi_sum_ARLEN SIZE 1 8 }  { m_axi_sum_ARSIZE BURST 1 3 }  { m_axi_sum_ARBURST LOCK 1 2 }  { m_axi_sum_ARLOCK CACHE 1 2 }  { m_axi_sum_ARCACHE PROT 1 4 }  { m_axi_sum_ARPROT QOS 1 3 }  { m_axi_sum_ARQOS REGION 1 4 }  { m_axi_sum_ARREGION USER 1 4 }  { m_axi_sum_ARUSER DATA 1 1 }  { m_axi_sum_RVALID VALID 0 1 }  { m_axi_sum_RREADY READY 1 1 }  { m_axi_sum_RDATA FIFONUM 0 32 }  { m_axi_sum_RLAST LAST 0 1 }  { m_axi_sum_RID ID 0 1 }  { m_axi_sum_RUSER DATA 0 1 }  { m_axi_sum_RRESP RESP 0 2 }  { m_axi_sum_BVALID VALID 0 1 }  { m_axi_sum_BREADY READY 1 1 }  { m_axi_sum_BRESP RESP 0 2 }  { m_axi_sum_BID ID 0 1 }  { m_axi_sum_BUSER DATA 0 1 } } }
}

set maxi_interface_dict [dict create]
dict set maxi_interface_dict a { CHANNEL_NUM 0 BUNDLE a NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict b { CHANNEL_NUM 0 BUNDLE b NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict sum { CHANNEL_NUM 0 BUNDLE sum NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
	{ a 1 }
	{ b 1 }
	{ sum 1 }
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
	{ a 1 }
	{ b 1 }
	{ sum 1 }
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
