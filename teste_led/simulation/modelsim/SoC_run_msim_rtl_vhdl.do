transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib altera_reserved_qsys_qsys_system
vmap altera_reserved_qsys_qsys_system altera_reserved_qsys_qsys_system
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/qsys_system.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_reset_controller.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_esp8266.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_jtag_uart_0.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_nios2.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_nios2_jtag_debug_module_sysclk.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_nios2_jtag_debug_module_tck.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_nios2_jtag_debug_module_wrapper.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_nios2_oci_test_bench.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_nios2_test_bench.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_onchip_memory2_0.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_pll.v}
vlog -vlog01compat -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_sdram.v}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_merlin_burst_adapter.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_merlin_master_agent.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_merlin_master_translator.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/altera_merlin_width_adapter.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_addr_router.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_addr_router_001.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_cmd_xbar_demux.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_cmd_xbar_demux_001.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_cmd_xbar_mux.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_id_router.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_id_router_002.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_id_router_005.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_irq_mapper.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_rsp_xbar_demux.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_rsp_xbar_demux_005.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_rsp_xbar_mux.sv}
vlog -sv -work altera_reserved_qsys_qsys_system +incdir+C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/qsys_system_rsp_xbar_mux_001.sv}
vcom -93 -work work {C:/altera/projeto_extensao/teste_led/armazenaWritedata.vhd}
vcom -93 -work work {C:/altera/projeto_extensao/teste_led/SoC.vhd}
vcom -93 -work work {C:/altera/projeto_extensao/teste_led/reg.vhd}
vcom -93 -work altera_reserved_qsys_qsys_system {C:/altera/projeto_extensao/teste_led/db/ip/qsys_system/submodules/matriz_avalon_interface.vhd}

