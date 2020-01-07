----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.01.2020 17:14:32
-- Design Name: 
-- Module Name: display - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display is
    Port ( clk: in std_logic;
           rec : in STD_LOGIC;
           play : in STD_LOGIC;
           pause : in std_logic;
           segmentos : out STD_LOGIC_VECTOR (6 downto 0);
           display : out STD_LOGIC_VECTOR (7 downto 0));
end display;

architecture Behavioral of display is

type state_type is (S0,S1,S2,S3,S4);
signal state, next_state : state_type;

signal codigo_rec,codigo_play,codigo_pause: STD_LOGIC_VECTOR (6 downto 0);
begin


SYNC_PROC : process (clk)
begin
    if rising_edge(clk) then
        state<=next_state;
    end if;
end process;

--asigna los codigos y la posicion de la letra
OUTPUT_DECODE_MOORE : process(state)
begin
case state is 
    when S0 => codigo_rec<="0001000";--R
               codigo_play<="0011000";--P
               codigo_pause<="0011000";--P
               
               display<="01111111";
    
    when S1 => codigo_rec<="0110000";--E
               codigo_play<="1110001";--L
               codigo_pause<="0001001";--A
               
               display<="10111111";

               
    when S2 => codigo_rec<="0110001";--C
               codigo_play<="0001001";--A
               codigo_pause<="1000001";--U
               
               display<="11011111";
               
    when S3 => codigo_rec<="1111111";--nada
               codigo_play<="1000100";--y
               codigo_pause<="0100100";--S
              
               display<="11101111";
               
    when S4 => codigo_rec<="1111111";--nada
               codigo_play<="1111111";--nada
               codigo_pause<="0110000";--E
                
                display<="11110111";
                         
    when others =>codigo_rec<="1111111";--nada
                  codigo_play<="1111111";--nada
                  codigo_pause<="1111111";--nada
                  
                  display<="11111111";
end case;
end process;

--pasa de un estado a otro sin condición
NEXT_STATE_DECODE: process (state)
begin
    next_state <= S0;
    case (state) is
        when S0=>
            next_state <= S1;
        when S1=>
            next_state <= S2;
        when S2=>
            next_state <= S3;
        when S3=>
            next_state <= S4;
        when others=>
            next_state <= S0;
    end case;
end process;

segmentos<=codigo_play when play='1' else
           codigo_rec when rec='1' else
           codigo_pause when pause='1' else
           "1111111";
end Behavioral;
