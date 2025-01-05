library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_8 is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_value: in std_logic_vector(7 downto 0);
        i_overwrite: in std_logic;
        
        output: out std_logic_vector(7 downto 0)
    );
end reg_8;

architecture reg_8_arch of reg_8 is
signal stored_value : std_logic_vector(7 downto 0) := "00000000";
begin
    output <= stored_value;
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            stored_value <= (others => '0');
        elsif rising_edge(i_clk) then
            if i_overwrite = '1' then
                stored_value <= i_value;
            end if;
        end if;            
    end process;

end reg_8_arch;
