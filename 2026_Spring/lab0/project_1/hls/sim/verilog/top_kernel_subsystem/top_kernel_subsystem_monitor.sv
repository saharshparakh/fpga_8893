//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef TOP_KERNEL_SUBSYSTEM_MONITOR_SV
`define TOP_KERNEL_SUBSYSTEM_MONITOR_SV

`uvm_analysis_imp_decl(_axi_wtr_a)
`uvm_analysis_imp_decl(_axi_rtr_a)
`uvm_analysis_imp_decl(_axi_wtr_b)
`uvm_analysis_imp_decl(_axi_rtr_b)
`uvm_analysis_imp_decl(_axi_wtr_sum)
`uvm_analysis_imp_decl(_axi_rtr_sum)
`uvm_analysis_imp_decl(_axi_wtr_control)
`uvm_analysis_imp_decl(_axi_rtr_control)

class top_kernel_subsystem_monitor extends uvm_component;

    top_kernel_reference_model refm;
    top_kernel_scoreboard scbd;

    `uvm_component_utils_begin(top_kernel_subsystem_monitor)
    `uvm_component_utils_end

    uvm_analysis_imp_axi_wtr_a#(axi_pkg::axi_transfer, top_kernel_subsystem_monitor) a_wtr_imp;
    uvm_analysis_imp_axi_rtr_a#(axi_pkg::axi_transfer, top_kernel_subsystem_monitor) a_rtr_imp;
    uvm_analysis_imp_axi_wtr_b#(axi_pkg::axi_transfer, top_kernel_subsystem_monitor) b_wtr_imp;
    uvm_analysis_imp_axi_rtr_b#(axi_pkg::axi_transfer, top_kernel_subsystem_monitor) b_rtr_imp;
    uvm_analysis_imp_axi_wtr_sum#(axi_pkg::axi_transfer, top_kernel_subsystem_monitor) sum_wtr_imp;
    uvm_analysis_imp_axi_rtr_sum#(axi_pkg::axi_transfer, top_kernel_subsystem_monitor) sum_rtr_imp;
    uvm_analysis_imp_axi_wtr_control#(axi_pkg::axi_transfer, top_kernel_subsystem_monitor) control_wtr_imp;
    uvm_analysis_imp_axi_rtr_control#(axi_pkg::axi_transfer, top_kernel_subsystem_monitor) control_rtr_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(top_kernel_reference_model)::get(this, "", "refm", refm))
            `uvm_fatal(this.get_full_name(), "No refm from high level")
        `uvm_info(this.get_full_name(), "get reference model by uvm_config_db", UVM_MEDIUM)
        scbd = top_kernel_scoreboard::type_id::create("scbd", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
        a_wtr_imp = new("a_wtr_imp", this);
        a_rtr_imp = new("a_rtr_imp", this);
        b_wtr_imp = new("b_wtr_imp", this);
        b_rtr_imp = new("b_rtr_imp", this);
        sum_wtr_imp = new("sum_wtr_imp", this);
        sum_rtr_imp = new("sum_rtr_imp", this);
        control_wtr_imp = new("control_wtr_imp", this);
        control_rtr_imp = new("control_rtr_imp", this);
    endfunction

    virtual function void write_axi_wtr_a(axi_transfer tr);
        refm.write_axi_wtr_a(tr);
        scbd.write_axi_wtr_a(tr);
    endfunction

    virtual function void write_axi_rtr_a(axi_transfer tr);
        refm.write_axi_rtr_a(tr);
        scbd.write_axi_rtr_a(tr);
    endfunction

    virtual function void write_axi_wtr_b(axi_transfer tr);
        refm.write_axi_wtr_b(tr);
        scbd.write_axi_wtr_b(tr);
    endfunction

    virtual function void write_axi_rtr_b(axi_transfer tr);
        refm.write_axi_rtr_b(tr);
        scbd.write_axi_rtr_b(tr);
    endfunction

    virtual function void write_axi_wtr_sum(axi_transfer tr);
        refm.write_axi_wtr_sum(tr);
        scbd.write_axi_wtr_sum(tr);
    endfunction

    virtual function void write_axi_rtr_sum(axi_transfer tr);
        refm.write_axi_rtr_sum(tr);
        scbd.write_axi_rtr_sum(tr);
    endfunction

    virtual function void write_axi_wtr_control(axi_transfer tr);
        refm.write_axi_wtr_control(tr);
        scbd.write_axi_wtr_control(tr);
    endfunction

    virtual function void write_axi_rtr_control(axi_transfer tr);
        refm.write_axi_rtr_control(tr);
        scbd.write_axi_rtr_control(tr);
    endfunction
endclass
`endif
