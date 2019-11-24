----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2019 11:35:38
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (7 downto 0);
           sample_in_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (7 downto 0);
           sample_out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is
constant c0,c4:signed:="00001001";
constant c1,c3:signed:="";
constant c2:signed:="";
signal control: std_logic_vector(2 downto 0);
signal r1_next, r1_reg,r2_next,r2_reg,r3_next,r3_reg:signed(15 downto 0):=(others=>'0');
signal x0, x1, x2, x3, x4:std_logic_vector(7 downto 0):=(others=>'0');
signal multA, multB:signed(7 downto 0):=(others=>'0');
begin
--input register
process(clk)
begin
    if(rising_edge(clk) and sample_in_enable='1')then
        x4<=x3;
        x3<=x2;
        x2<=x1;
        x1<=x0;
        x0<=sample_in;
    end if;
end process;
-- state register logic
process(clk)
begin
    if(rising_edge(clk))then
        r1_reg<=r1_next;
        r2_reg<=r2_next;
        r3_reg<=r3_next;
    end if;
end process;

--next state logic
process(sample_in,r1_reg,r2_reg,r3_reg,x0,x1,x2,x3,x4)
begin
    case control is 
        when "000" => multA<= signed(x0);
        when "001" => multA<= signed(x1);
        when "010" => multA<= signed(x2); 
        when "011" => multA<= signed(x3);
        when others => multA<= signed(x4);   
    end case;
    case control is 
        when "000" => multB<= signed(c0);
        when "001" => multB<= signed(c1);
        when "010" => multB<= signed(c2); 
        when "011" => multB<= signed(c3);
        when others => multB<= signed(c4);   
    end case;
    r1_next<=multA*multB;
    r2_next<=r1_reg;
    r3_next<=r2_reg + r3_reg;
    sample_out<= std_logic_vector(r3_reg(15 downto 7));
end process;
end Behavioral;
