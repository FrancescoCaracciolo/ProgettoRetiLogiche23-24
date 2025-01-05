----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2024 08:31:01 PM
-- Design Name: 
-- Module Name: splitter - splitter_arch
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

entity splitter is
    port(
        input: in std_logic_vector(10 downto 0);
        
        o_10: out std_logic_vector(9 downto 0);
        o_16: out std_logic_vector(15 downto 0)
    );
end splitter;

architecture splitter_arch of splitter is

begin
    o_10 <= input(10 downto 1);
    o_16 <= "00000" & input;
end splitter_arch;
