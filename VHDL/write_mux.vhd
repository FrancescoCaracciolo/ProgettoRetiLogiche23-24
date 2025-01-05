library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    port(
        i_sel   : in std_logic;
        i_0     : in std_logic_vector(7 downto 0);
        i_1   : in std_logic_vector(7 downto 0);
        output  : out std_logic_vector(7 downto 0)
    );
end mux;

architecture mux_arch of mux is
begin
    process(i_sel, i_0, i_1)
    begin
       if i_sel = '0' then
           output <= i_0;
       elsif i_sel = '1' then
           output <= i_1;
       end if;
    end process;
end mux_arch;
