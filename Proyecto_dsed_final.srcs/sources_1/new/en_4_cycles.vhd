----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2019 12:23:53
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
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

entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is
signal aux_clk3,aux_en2:std_logic:='0';
signal cuenta4: unsigned(1 downto 0):= "00";
signal cuenta2: unsigned(1 downto 0):= "00";

signal cuenta1: std_logic:= '0';
begin

process(clk_12megas,reset)
begin 
    if(reset='1')then
    cuenta1<='0';
    cuenta2<="00";
    cuenta4<="00";
    aux_en2<='0';
    aux_clk3<='0';
elsif(rising_edge(clk_12megas))then

    if(cuenta4=1)then
         cuenta4<="00";
         aux_clk3<= not aux_clk3;
         else 
         cuenta4 <= cuenta4 + 1;
    end if;
    if(cuenta1 = '1')then
         aux_en2<= not aux_en2;
         else 
         cuenta1<= not cuenta1;
    end if;
    cuenta2<=cuenta2+1;
end if;
end process;

en_4_cycles<='1' when (cuenta2=3) else '0';
en_2_cycles<=aux_en2;
clk_3megas<=aux_clk3;
end Behavioral;
