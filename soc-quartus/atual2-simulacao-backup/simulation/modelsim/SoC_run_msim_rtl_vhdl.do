transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/roberto/dev/soc-quartus/atual2-simulacao/temporizador.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/atual2-simulacao/timer_pwm.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/atual2-simulacao/register_data_width.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/atual2-simulacao/MotorMatrixControl.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/atual2-simulacao/motor_fsm.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/atual2-simulacao/motor.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/atual2-simulacao/fsm_commands.vhd}
vlib altera_reserved_qsys_qsys_system
vmap altera_reserved_qsys_qsys_system altera_reserved_qsys_qsys_system

