//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef TOP_KERNEL_CONFIG__SV                        
    `define TOP_KERNEL_CONFIG__SV                    
                                                            
    class top_kernel_config extends uvm_object;            
                                                            
        int check_ena;                                      
        int cover_ena;                                      
        axi_pkg::axi_cfg a_cfg;
        axi_pkg::axi_cfg b_cfg;
        axi_pkg::axi_cfg sum_cfg;
        axi_pkg::axi_cfg control_cfg;

        `uvm_object_utils_begin(top_kernel_config)         
        `uvm_field_object(a_cfg, UVM_DEFAULT);
        `uvm_field_object(b_cfg, UVM_DEFAULT);
        `uvm_field_object(sum_cfg, UVM_DEFAULT);
        `uvm_field_object(control_cfg, UVM_DEFAULT);
        `uvm_field_int   (check_ena , UVM_DEFAULT)          
        `uvm_field_int   (cover_ena , UVM_DEFAULT)          
        `uvm_object_utils_end                               

        function new (string name = "top_kernel_config");
            super.new(name);                                
        a_cfg = axi_pkg::axi_cfg::type_id::create("a_cfg");
        b_cfg = axi_pkg::axi_cfg::type_id::create("b_cfg");
        sum_cfg = axi_pkg::axi_cfg::type_id::create("sum_cfg");
        control_cfg = axi_pkg::axi_cfg::type_id::create("control_cfg");
        endfunction                                         
                                                            
    endclass                                                
                                                            
`endif                                                      
