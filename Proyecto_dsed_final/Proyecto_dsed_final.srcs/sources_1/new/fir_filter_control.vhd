----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2019 12:55:17
-- Design Name: 
-- Module Name: fir_filter_control - Behavioral
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

entity fir_filter_control is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in_ready : in STD_LOGIC;
           control : out STD_LOGIC_VECTOR(2 downto 0);
           fir_enable:out STD_LOGIC;
           en_5:out STD_LOGIC);
end fir_filter_control;

architecture Behavioral of fir_filter_control is
signal flag_first_en_reg,flag_first_en_next:std_logic:='0';
signal en_ready_reg,en_ready_next: std_logic;
signal cuenta_reg,cuenta_next: std_logic_vector(2 downto 0);
begin
--register logic
process(clk_12megas,reset)
begin
if(reset='1')then
    cuenta_reg<="000";
    en_ready_reg<='0';
    flag_first_en_reg<='0';
elsif(rising_edge(clk_12megas))then
    cuenta_reg<=cuenta_next;
    en_ready_reg<=en_ready_next;
    flag_first_en_reg<=flag_first_en_next;
end if;
end process;

--next state logic
process(cuenta_reg,en_ready_reg,flag_first_en_reg)
begin
cuenta_next<=std_logic_vector(unsigned(cuenta_reg)+1);
if(sample_in_ready='1')then
    flag_first_en_next<='0';
else
    flag_first_en_next<=flag_first_en_reg;
end if;
if(cuenta_reg="100")then
    if(flag_first_en_reg='0')then
        flag_first_en_next<='1';
        fir_enable<='1';
        cuenta_next<="000";
    else
        flag_first_en_next<=flag_first_en_reg;
        fir_enable<='0';
        cuenta_next<="000";
    end if;
else
    fir_enable<='0';
    cuenta_next<=cuenta_reg;
end if;
end process;
-- output logic
control<=cuenta_reg;
fir_enable<=en_ready_reg;
en_5<=flag_first_en_reg;
end Behavioral;

