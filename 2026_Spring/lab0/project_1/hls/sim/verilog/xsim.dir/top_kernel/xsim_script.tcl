xsim {top_kernel} -testplusarg UVM_VERBOSITY=UVM_NONE -testplusarg UVM_TESTNAME=top_kernel_test_lib -testplusarg UVM_TIMEOUT=20000000000000 -autoloadwcfg -tclbatch {top_kernel.tcl}
