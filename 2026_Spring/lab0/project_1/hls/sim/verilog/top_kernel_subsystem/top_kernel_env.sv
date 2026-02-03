//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef TOP_KERNEL_ENV__SV                                                                                   
    `define TOP_KERNEL_ENV__SV                                                                               
                                                                                                                    
                                                                                                                    
    class top_kernel_env extends uvm_env;                                                                          
                                                                                                                    
        top_kernel_virtual_sequencer top_kernel_virtual_sqr;                                                      
        top_kernel_config top_kernel_cfg;                                                                         
                                                                                                                    
        axi_pkg::axi_env#(64,4,8,3,1) axi_master_a;
        axi_pkg::axi_env#(64,4,8,3,1) axi_master_b;
        axi_pkg::axi_env#(64,4,8,3,1) axi_master_sum;
        axi_pkg::axi_env#(6,4,4,3,1) axi_lite_control;
                                                                                                                    
        top_kernel_reference_model   refm;                                                                         
                                                                                                                    
        top_kernel_subsystem_monitor subsys_mon;                                                                   
                                                                                                                    
        `uvm_component_utils_begin(top_kernel_env)                                                                 
        `uvm_field_object (refm, UVM_DEFAULT | UVM_REFERENCE)                                                       
        `uvm_field_object (top_kernel_virtual_sqr, UVM_DEFAULT | UVM_REFERENCE)                                    
        `uvm_field_object (top_kernel_cfg        , UVM_DEFAULT)                                                    
        `uvm_component_utils_end                                                                                    
                                                                                                                    
        function new (string name = "top_kernel_env", uvm_component parent = null);                              
            super.new(name, parent);                                                                                
        endfunction                                                                                                 
                                                                                                                    
        extern virtual function void build_phase(uvm_phase phase);                                                  
        extern virtual function void connect_phase(uvm_phase phase);                                                
        extern virtual task          run_phase(uvm_phase phase);                                                    
                                                                                                                    
    endclass                                                                                                        
                                                                                                                    
    function void top_kernel_env::build_phase(uvm_phase phase);                                                    
        super.build_phase(phase);                                                                                   
        top_kernel_cfg = top_kernel_config::type_id::create("top_kernel_cfg", this);                           
                                                                                                                    

        top_kernel_cfg.a_cfg.set_default();
        top_kernel_cfg.a_cfg.drv_type = axi_pkg::SLAVE;
        top_kernel_cfg.a_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        top_kernel_cfg.a_cfg.write_latency_mode = TRANSACTION_FIRST;
        top_kernel_cfg.a_cfg.read_latency_mode = TRANSACTION_FIRST;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_master_a*", "cfg", top_kernel_cfg.a_cfg);
        axi_master_a = axi_pkg::axi_env#(64,4,8,3,1)::type_id::create("axi_master_a", this);

        top_kernel_cfg.b_cfg.set_default();
        top_kernel_cfg.b_cfg.drv_type = axi_pkg::SLAVE;
        top_kernel_cfg.b_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        top_kernel_cfg.b_cfg.write_latency_mode = TRANSACTION_FIRST;
        top_kernel_cfg.b_cfg.read_latency_mode = TRANSACTION_FIRST;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_master_b*", "cfg", top_kernel_cfg.b_cfg);
        axi_master_b = axi_pkg::axi_env#(64,4,8,3,1)::type_id::create("axi_master_b", this);

        top_kernel_cfg.sum_cfg.set_default();
        top_kernel_cfg.sum_cfg.drv_type = axi_pkg::SLAVE;
        top_kernel_cfg.sum_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        top_kernel_cfg.sum_cfg.write_latency_mode = TRANSACTION_FIRST;
        top_kernel_cfg.sum_cfg.read_latency_mode = TRANSACTION_FIRST;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_master_sum*", "cfg", top_kernel_cfg.sum_cfg);
        axi_master_sum = axi_pkg::axi_env#(64,4,8,3,1)::type_id::create("axi_master_sum", this);

        top_kernel_cfg.control_cfg.set_default();
        top_kernel_cfg.control_cfg.drv_type = axi_pkg::MASTER;
        top_kernel_cfg.control_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_lite_control*", "cfg", top_kernel_cfg.control_cfg);
        axi_lite_control = axi_pkg::axi_env#(6,4,4,3,1)::type_id::create("axi_lite_control", this);



        refm = top_kernel_reference_model::type_id::create("refm", this);


        uvm_config_db#(top_kernel_reference_model)::set(this, "*", "refm", refm);


        `uvm_info(this.get_full_name(), "set reference model by uvm_config_db", UVM_LOW)


        subsys_mon = top_kernel_subsystem_monitor::type_id::create("subsys_mon", this);


        top_kernel_virtual_sqr = top_kernel_virtual_sequencer::type_id::create("top_kernel_virtual_sqr", this);
        `uvm_info(this.get_full_name(), "build_phase done", UVM_LOW)
    endfunction


    function void top_kernel_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);


        if(top_kernel_cfg.a_cfg.drv_type==axi_pkg::MASTER ||top_kernel_cfg.a_cfg.drv_type==axi_pkg::SLAVE)
            top_kernel_virtual_sqr.a_sqr = axi_master_a.vsqr;
        axi_master_a.item_wtr_port.connect(subsys_mon.a_wtr_imp);
        axi_master_a.item_rtr_port.connect(subsys_mon.a_rtr_imp);
        uvm_callbacks#(axi_pkg::axi_state, axi_pkg::axi_state_cbs)::add(axi_master_a.state, refm.axi_memaccess_cb_a);
        if(top_kernel_cfg.b_cfg.drv_type==axi_pkg::MASTER ||top_kernel_cfg.b_cfg.drv_type==axi_pkg::SLAVE)
            top_kernel_virtual_sqr.b_sqr = axi_master_b.vsqr;
        axi_master_b.item_wtr_port.connect(subsys_mon.b_wtr_imp);
        axi_master_b.item_rtr_port.connect(subsys_mon.b_rtr_imp);
        uvm_callbacks#(axi_pkg::axi_state, axi_pkg::axi_state_cbs)::add(axi_master_b.state, refm.axi_memaccess_cb_b);
        if(top_kernel_cfg.sum_cfg.drv_type==axi_pkg::MASTER ||top_kernel_cfg.sum_cfg.drv_type==axi_pkg::SLAVE)
            top_kernel_virtual_sqr.sum_sqr = axi_master_sum.vsqr;
        axi_master_sum.item_wtr_port.connect(subsys_mon.sum_wtr_imp);
        axi_master_sum.item_rtr_port.connect(subsys_mon.sum_rtr_imp);
        uvm_callbacks#(axi_pkg::axi_state, axi_pkg::axi_state_cbs)::add(axi_master_sum.state, refm.axi_memaccess_cb_sum);
        if(top_kernel_cfg.control_cfg.drv_type==axi_pkg::MASTER ||top_kernel_cfg.control_cfg.drv_type==axi_pkg::SLAVE)
            top_kernel_virtual_sqr.control_sqr = axi_lite_control.vsqr;
        axi_lite_control.item_wtr_port.connect(subsys_mon.control_wtr_imp);
        axi_lite_control.item_rtr_port.connect(subsys_mon.control_rtr_imp);
        refm.top_kernel_cfg = top_kernel_cfg;
        `uvm_info(this.get_full_name(), "connect phase done", UVM_LOW)
    endfunction


    task top_kernel_env::run_phase(uvm_phase phase);
        `uvm_info(this.get_full_name(), "top_kernel_env is running", UVM_LOW)
    endtask


`endif
