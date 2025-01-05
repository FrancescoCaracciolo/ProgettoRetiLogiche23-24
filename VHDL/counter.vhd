library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
    port(
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        increment   : in std_logic;
        
        output      : out std_logic_vector(10 downto 0)
    );
end counter;

architecture counter_arch of counter is
signal stored_value: std_logic_vector(10 downto 0) := "00000000000";
begin
    output <= stored_value;
    process (i_clk, i_rst)
    begin
    if i_rst = '1' then
        stored_value <= (others => '0');
    elsif rising_edge(i_clk) then
        if increment = '1' then
            stored_value <= stored_value + 1;
        end if;
    end if;
    end process;

end counter_arch;
