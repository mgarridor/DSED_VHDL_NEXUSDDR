@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 1d616c9ac3d1437fb4d082f3382c0f5e -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip -L xpm --snapshot fir_filter_tb3_behav xil_defaultlib.fir_filter_tb3 -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
