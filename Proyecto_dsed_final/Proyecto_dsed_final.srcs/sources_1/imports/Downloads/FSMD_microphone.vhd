----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2019 19:10:32
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (8 downto 0);
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

type state_type is (idle, muestreo);
signal state, next_state : state_type;
signal dato1_reg,dato1_next, dato2_reg,dato2_next, cuenta_reg,cuenta_next : unsigned(8 downto 0);
signal primer_ciclo_reg,primer_ciclo_next : std_logic;

begin

SYNC_PROC : process (clk_12megas,reset)
begin
    if (reset = '1') then
        state <= idle;
    elsif (rising_edge(clk_12megas)and enable_4_cycles='1') then
        
            state<=next_state;
            
            dato1_reg<=dato1_next;
            dato2_reg<=dato2_next;
            cuenta_reg<=cuenta_next;
            primer_ciclo_reg<=primer_ciclo_next;
            
    end if;
    
end process;

OUTPUT_DECODE : process (reset,state,micro_data,cuenta_reg,dato1_reg,dato2_reg)
begin
--valores por defecto
dato1_next<=dato1_reg;
dato2_next<=dato2_reg;
cuenta_next<=cuenta_reg;
primer_ciclo_next<=primer_ciclo_reg;
case state is
when idle=>
    sample_out<="000000000";
    if (reset = '0')then
        dato1_next<="000000000";
        dato2_next<="000000000";
        cuenta_next<="000000000";
        primer_ciclo_next<='0';
    end if;
when others=>
        if((cuenta_reg <=105)or
                ((cuenta_reg >=150)and
                (cuenta_reg <=255))) then
                
                 cuenta_next<=cuenta_reg + 1;
                 
                    if(micro_data='1')then
                    
                        dato1_next<=dato1_reg + 1;
                        dato2_next<=dato2_reg + 1;
                    end if;
           
        
        elsif((cuenta_reg >=106) and
              (cuenta_reg <= 149))then
              
                   cuenta_next<=cuenta_reg + 1;
                   
                   if(micro_data='1')then
                                       
                       dato1_next<=dato1_reg + 1;
                   end if;
                   
                   if (cuenta_reg =106)then
                   
                        dato2_next<=(others=>'0');
                        
                        if(primer_ciclo_reg = '1')then
                   
                            sample_out <= std_logic_vector(dato2_reg);
                        end if;
                   end if;
   
        else
            
            if(cuenta_reg=299)then
            
                 cuenta_next<=(others=>'0');
                 primer_ciclo_next<='1';
            else
            
                cuenta_next<=cuenta_reg +1;    
            end if;
            
            if(micro_data='1')then
                dato2_next<=dato2_reg +1;
            end if;
            
            if(cuenta_reg = 256)then
                sample_out <= std_logic_vector(dato1_reg);
                dato1_next<=(others=>'0');
            end if;
        end if;

end case;
end process;

STATE_DECODE: process(reset,state,micro_data)
begin
case state is 
when idle =>
    if(reset='0')then
        next_state <= muestreo;
    else
        next_state <= idle;
    end if;
when others=>
    if(reset='1')then
        next_state <= idle;
    else
        next_state <= muestreo;
    end if;
end case;
end process;
--Combinational logic
with (cuenta_reg) select sample_out_ready<=
(enable_4_cycles and clk_12megas) when to_unsigned(256,cuenta_reg'length),
(enable_4_cycles and clk_12megas and primer_ciclo_reg)when to_unsigned(106,cuenta_reg'length),
'0' when others;



end Behavioral;
