transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/roberto/dev/soc-quartus/qsys_tutorial/timer_pwm.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/qsys_tutorial/register_data_width.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/qsys_tutorial/motor.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/qsys_tutorial/fsm_commands.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/qsys_tutorial/matriz_interface.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/qsys_tutorial/temporizador.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/qsys_tutorial/MotorMatrixControl.vhd}
vcom -93 -work work {/home/roberto/dev/soc-quartus/qsys_tutorial/motor_fsm.vhd}

