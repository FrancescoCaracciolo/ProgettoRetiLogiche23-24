library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity confidence_countdown is
    port(
        i_clk  : in std_logic;
        i_rst : in std_logic;
        i_dec : in std_logic;
        i_max : in std_logic;
        o_C   : out std_logic_vector(7 downto 0)
    );
end confidence_countdown;

architecture confindence_countdown_arch of confidence_countdown is
signal stored_value : std_logic_vector(4 downto 0) := "00000";
begin
  o_C <= "000" & stored_value;
  process (i_clk, i_rst, i_max)
  begin
      if i_rst = '1' then
          stored_value <= (others => '0');
      elsif rising_edge(i_clk) then
        if i_max = '1' then
            stored_value <= (others => '1');
        elsif i_dec = '1' then
            if stored_value /= "00000" then
                stored_value <= stored_value - 1;
            end if;
        end if;
      end if;
    end process;
end confindence_countdown_arch;
