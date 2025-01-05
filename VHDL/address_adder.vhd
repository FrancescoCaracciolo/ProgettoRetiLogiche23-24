library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder is
    Port (
        addr1 : in std_logic_vector(15 downto 0);
        addr2 : in std_logic_vector(15 downto 0);
        output: out std_logic_vector(15 downto 0)
    );
end adder;

architecture adder_arch of adder is
begin
    process(addr1, addr2)
    begin
        output <= addr1 + addr2;
    end process;
end adder_arch;
