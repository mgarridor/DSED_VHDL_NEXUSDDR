----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2019 17:01:37
-- Design Name: 
-- Module Name: fir_filter_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir_filter_tb is
--  Port ( );
end fir_filter_tb;

architecture Behavioral of fir_filter_tb is
component fir_filter 
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         sample_in : in STD_LOGIC_VECTOR (7 downto 0);
         sample_in_enable : in STD_LOGIC;
         filter_select : in STD_LOGIC;
         sample_out : out STD_LOGIC_VECTOR (7 downto 0);
         sample_out_ready : out STD_LOGIC);
end component;
signal clk,reset,sample_in_enable,filter_select,sample_out_ready:std_logic;
signal a,b,c:std_logic:='0';
signal sample_in,sample_out:std_logic_vector(7 downto 0);
constant clk_period : time := 84 ns; 
begin
UUT: fir_filter port map(
    clk=>clk,
    reset=>reset,
    sample_in=>sample_in,
    sample_in_enable=>sample_in_enable,
    filter_select=>filter_select,--filtro paso bajo 
    sample_out=>sample_out,
    sample_out_ready=>sample_out_ready
);

CLK_process:process
begin
    clk <= '0';
    wait for clk_period/2;
    clk<= '1';
    wait for clk_period/2;
end process;

--señal aleatoria de sample_in
process
begin

    sample_in<="00000001";
    wait for 4000 ns;
        sample_in<="00110001";
    wait for 4000 ns;
        sample_in<="00000011";
    wait for 4000 ns;
        sample_in<="10001110";
    wait for 4000 ns;
        sample_in<="00101000";
    wait for 4000 ns;
    wait;
end process;            


process
begin
    reset <='1';
    wait for 10 ns;
    reset<='0';
    wait;

end process;
--señal sample in cada 1000 ns durnte un periodo
process
begin

    sample_in_enable<='0';
    wait for 1 us;
    sample_in_enable<='1';
    wait for clk_period;
end process;
filter_select<='0';
end Behavioral;