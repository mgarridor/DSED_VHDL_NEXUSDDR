LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use work.DSED.all;

ENTITY fir_filter_advance_tb IS
END fir_filter_advance_tb;
ARCHITECTURE behavioral OF fir_filter_advance_tb IS
-- Clock signal declaration
signal clk : std_logic := '1';
-- Declaration of the reading signal
signal Sample_In : signed(7 downto 0) := (others => '0');
-- Clock period definitions
signal sample_out : integer:=0;
constant clk_period : time := 10 ns;
BEGIN
-- Clock statement
clk <= not clk after clk_period/2;

read_process : PROCESS (clk)

FILE in_file : text OPEN read_mode IS "C:\Users\dasba\Desktop\teleco\dsed\proyecto_dsed\DSED_VHDL_NEXUSDDR\Proyecto_dsed_final\sample_in.dat";
FILE out_file : text OPEN write_mode IS "C:\Users\dasba\Desktop\teleco\dsed\proyecto_dsed\DSED_VHDL_NEXUSDDR\Proyecto_dsed_final\sample_out.dat";

VARIABLE in_line : line;
VARIABLE in_int : integer;
VARIABLE out_line : line;
VARIABLE out_int : integer;
VARIABLE in_read_ok : BOOLEAN;
BEGIN
if (clk'event and clk = '1') then
    if NOT endfile(in_file) then
        ReadLine(in_file,in_line);
        Read(in_line, in_int, in_read_ok);
        sample_in <= to_signed(in_int, 8); -- 8 = the bit width
        sample_out<= to_integer(sample_in);
        Write(out_line, sample_out);

        WriteLine(out_file,out_line);
        
    else
        assert false report "Simulation Finished" severity failure;
    end if;
end if;
end process;
end Behavioral;
