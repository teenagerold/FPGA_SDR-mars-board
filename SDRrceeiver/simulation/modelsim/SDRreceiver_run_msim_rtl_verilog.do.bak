transcript on
if ![file isdirectory SDRreceiver_iputf_libs] {
	file mkdir SDRreceiver_iputf_libs
}

vmap altera_ver D:/software/modeltech_10.1a/mylibrary/verilog_libs/altera_ver
vmap lpm_ver D:/software/modeltech_10.1a/mylibrary/verilog_libs/lpm_ver
vmap sgate_ver D:/software/modeltech_10.1a/mylibrary/verilog_libs/sgate_ver
vmap altera_mf_ver D:/software/modeltech_10.1a/mylibrary/verilog_libs/altera_mf_ver
vmap altera_lnsim_ver D:/software/modeltech_10.1a/mylibrary/verilog_libs/altera_lnsim_ver
vmap cycloneive_ver D:/software/modeltech_10.1a/mylibrary/verilog_libs/cycloneive_ver
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/altera_avalon_sc_fifo.v"                        
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/auk_dspip_math_pkg_hpfir.vhd"                   
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/auk_dspip_lib_pkg_hpfir.vhd"                    
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/auk_dspip_avalon_streaming_controller_hpfir.vhd"
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/auk_dspip_avalon_streaming_sink_hpfir.vhd"      
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/auk_dspip_avalon_streaming_source_hpfir.vhd"    
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/auk_dspip_roundsat_hpfir.vhd"                   
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/dspba_library_package.vhd"                      
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/dspba_library.vhd"                              
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/mfir_rtl.vhd"                                   
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/mfir_ast.vhd"                                   
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/mfir.vhd"                                       
vcom "E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mfir_sim/mfir_tb.vhd"                                    

vlog -vlog01compat -work work +incdir+E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver {E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mnco.vo}
vlog -vlog01compat -work work +incdir+E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver {E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mcic.vo}
vlog -vlog01compat -work work +incdir+E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver {E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/SDRreceiver.v}
vlog -vlog01compat -work work +incdir+E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver {E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/multiply.v}
vlog -vlog01compat -work work +incdir+E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver {E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/mDSP.v}

vlog -vlog01compat -work work +incdir+E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/simulation/modelsim {E:/F/FPGAcode/SDR-radio-receiver/DE0-nano/SDRrceeiver/simulation/modelsim/SDRreceiver.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  SDRreceiver_vlg_tst

add wave *
view structure
view signals
run -all
