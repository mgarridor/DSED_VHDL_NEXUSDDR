@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim audio_interface_tb_behav -key {Behavioral:sim_1:Functional:audio_interface_tb} -tclbatch audio_interface_tb.tcl -view C:/Users/dsed/Downloads/DSED_VHDL_NEXUSDDR-master/DSED_VHDL_NEXUSDDR-master/Proyecto_dsed_final/audio_interface_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
