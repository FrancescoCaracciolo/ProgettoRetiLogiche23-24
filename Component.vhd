-- Prova finale di Reti Logiche 2023/2024
-- Francesco Caracciolo

-- File: project_reti_logiche.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
    port(
        i_clk     : in std_logic;
        i_rst     : in std_logic;
        i_start   : in std_logic;
        i_add     : in std_logic_vector(15 downto 0);
        i_k       : in std_logic_vector(9 downto 0);
        
        o_done    : out std_logic;
        
        o_mem_addr : out std_logic_vector(15 downto 0);
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_data : out std_logic_vector(7 downto 0);
        o_mem_we   : out std_logic;
        o_mem_en   : out std_logic
    );
end project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is

component adder is
    Port (
        addr1  : in std_logic_vector(15 downto 0);
        addr2  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(15 downto 0)
    );
end component adder;

component splitter is
    port(
        input : in std_logic_vector(10 downto 0);
        
        o_10  : out std_logic_vector(9 downto 0);
        o_16  : out std_logic_vector(15 downto 0)
    );
end component splitter;

component confidence_countdown is
    port(
        i_clk  : in std_logic;
        i_rst  : in std_logic;
        i_dec  : in std_logic;
        i_max  : in std_logic;
        o_C    : out std_logic_vector(7 downto 0)
    );
end component confidence_countdown;

component counter is
    port(
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        increment   : in std_logic;
        
        output      : out std_logic_vector(10 downto 0)
    );
end component counter;

component reg_8 is
    port(
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        i_value     : in std_logic_vector(7 downto 0);
        i_overwrite : in std_logic;
        
        output : out std_logic_vector(7 downto 0)
    );
end component reg_8;

component mux is
    port(
        i_sel   : in std_logic;
        i_0     : in std_logic_vector(7 downto 0);
        i_1     : in std_logic_vector(7 downto 0);
        output  : out std_logic_vector(7 downto 0)
    );
end component mux;

component fsm is 
    Port ( 
        -- Main component in
        i_clk                 : in std_logic;
        i_rst                 : in std_logic;
        i_start               : in std_logic;
        i_k                   : in std_logic_vector(9 downto 0);
        i_mem_data            : in std_logic_vector(7 downto 0);
        -- Component in
        i_w_count             : in std_logic_vector(9 downto 0);
        -- Main component out
        o_done                : out std_logic;
        o_mem_we              : out std_logic;
        o_mem_en              : out std_logic;
        -- Components controllers
        o_max_C              : out std_logic;
        o_decrement_C        : out std_logic;
        o_select_mux         : out std_logic;
        o_overwrite_last     : out std_logic;
        o_increment_address  : out std_logic;
        o_rst                : out std_logic
    );
end component fsm;
-- Signals for connections
signal counter_out: std_logic_vector(10 downto 0);
signal counter_out_10: std_logic_vector(9 downto 0);
signal counter_out_16: std_logic_vector(15 downto 0);
signal increment: std_logic;
signal overwrite: std_logic;
signal last: std_logic_vector(7 downto 0);
signal max: std_logic;
signal decrement: std_logic;
signal confidence: std_logic_vector(7 downto 0);
signal mux_select: std_logic;
signal rst: std_logic;
signal address_out: std_logic_vector(15 downto 0);

begin
    address_cursor: counter port map(
        i_clk => i_clk,
        i_rst => rst,
        increment => increment,
        output => counter_out
    );
    address_adder: adder port map(
        addr1 => counter_out_16,
        addr2 => i_add,
        output => o_mem_addr
    );
    counter_splitter: splitter port map(
        input => counter_out,
        o_10 => counter_out_10,
        o_16 => counter_out_16
    );
    last_w: reg_8 port map(
        i_clk => i_clk,
        i_rst => rst,
        i_value => i_mem_data,
        i_overwrite => overwrite,
        output => last
    );
    confidence_cd: confidence_countdown port map(
        i_clk => i_clk,
        i_rst => rst,
        i_max => max,
        i_dec => decrement,
        o_C => confidence
    );
    write_mux: mux port map(
        i_sel => mux_select,
        i_0 => confidence,
        i_1 => last,
        output => o_mem_data
    );
    fsm1: fsm port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_start => i_start,
        i_k => i_k,
        i_mem_data => i_mem_data,
        i_w_count => counter_out_10,
        o_done => o_done,
        o_mem_we => o_mem_we,
        o_mem_en => o_mem_en,
        o_max_C => max,
        o_decrement_C => decrement,
        o_select_mux => mux_select,
        o_overwrite_last => overwrite,
        o_increment_address => increment,
        o_rst => rst
    );
end project_reti_logiche_arch;

-- File: counter.vhd
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

-- File: adder.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder is
    Port (
        addr1  : in std_logic_vector(15 downto 0);
        addr2  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(15 downto 0)
    );
end adder;

architecture adder_arch of adder is
begin
    process(addr1, addr2)
    begin
        output <= addr1 + addr2;
    end process;
end adder_arch;

-- File: splitter.vhd 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity splitter is
    port(
        input : in std_logic_vector(10 downto 0);
        
        o_10  : out std_logic_vector(9 downto 0);
        o_16  : out std_logic_vector(15 downto 0)
    );
end splitter;

architecture splitter_arch of splitter is

begin
    o_10 <= input(10 downto 1);
    o_16 <= "00000" & input;
end splitter_arch;

-- File: reg_8.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_8 is
    port(
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        i_value     : in std_logic_vector(7 downto 0);
        i_overwrite : in std_logic;
        
        output : out std_logic_vector(7 downto 0)
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

-- File: confidence_countdown.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity confidence_countdown is
    port(
        i_clk  : in std_logic;
        i_rst  : in std_logic;
        i_dec  : in std_logic;
        i_max  : in std_logic;
        o_C    : out std_logic_vector(7 downto 0)
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

-- File: mux.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    port(
        i_sel   : in std_logic;
        i_0     : in std_logic_vector(7 downto 0);
        i_1     : in std_logic_vector(7 downto 0);
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

-- File: fsm.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm is
    Port ( 
        -- Main component in
        i_clk                 : in std_logic;
        i_rst                 : in std_logic;
        i_start               : in std_logic;
        i_k                   : in std_logic_vector(9 downto 0);
        i_mem_data            : in std_logic_vector(7 downto 0);
        -- Component in
        i_w_count             : in std_logic_vector(9 downto 0);
        -- Main component out
        o_done                : out std_logic;
        o_mem_we              : out std_logic;
        o_mem_en              : out std_logic;
        -- Components controllers
        o_max_C              : out std_logic;
        o_decrement_C        : out std_logic;
        o_select_mux         : out std_logic;
        o_overwrite_last     : out std_logic;
        o_increment_address  : out std_logic;
        o_rst                : out std_logic
    );
end fsm;

architecture fsm_arch of fsm is
    type S is (IDLE, CHECK_ADDR, DONE,READ_MEM_DATA, 
                     SAVE_VALUE, CUR_INC,
                     MEM_WRITE_0, CUR_INC_0,
                     WRITE_C);
    signal curr_state : S := IDLE;
begin
    -- State transitions
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            curr_state <= IDLE;
        elsif rising_edge(i_clk) then
            case curr_state is
                when IDLE => 
                    if i_start = '1' then
                        curr_state <= CHECK_ADDR;
                    else
                        curr_state <= IDLE;
                    end if;
                when CHECK_ADDR =>
                    if i_w_count /= i_k then
                        curr_state <= READ_MEM_DATA;
                    else
                        curr_state <= DONE;
                    end if;
                when READ_MEM_DATA =>
                    if i_mem_data = "00000000" then
                        curr_state <= MEM_WRITE_0;
                    else
                        curr_state <= SAVE_VALUE;
                    end if;
                -- Case found a value > 0
                when SAVE_VALUE =>
                    curr_state <= CUR_INC;
                when CUR_INC =>
                    curr_state <= WRITE_C;
                -- Case found a 0
                when MEM_WRITE_0 => 
                    curr_state <= CUR_INC_0;
                when CUR_INC_0 =>
                    curr_state <= WRITE_C;
                when WRITE_C =>
                    curr_state <= CHECK_ADDR;
                when DONE =>
                    if i_start = '1' then
                        curr_state <= DONE;
                    else
                        curr_state <= IDLE;
                    end if;
            end case;
       end if;
    end process;
    
    -- Signals management
    process(curr_state)
    begin
        o_mem_we <= '0';
        o_mem_en <= '0';
        o_done <= '0';
        o_max_C <= '0';
        o_decrement_C <= '0';
        o_select_mux <= '0';
        o_overwrite_last <= '0';
        o_increment_address <= '0';
        o_rst <= '0';
        case curr_state is
            when IDLE =>
                -- Set default values
                o_rst <= '1';
            when CHECK_ADDR =>
                -- Setup memory
                o_mem_we <= '0';
                o_mem_en <= '1';
                -- Fix increments
                o_max_C <= '0';
                -- Stop ad_cur
                o_increment_address <= '0';
            when DONE =>
                o_done <= '1';
                o_mem_en <= '0';
                o_mem_we <= '0';
            when READ_MEM_DATA =>
                o_increment_address <= '0';
            when SAVE_VALUE =>
                -- Maximize confidence
                o_max_C <= '1';
                -- Save W in reg_8
                o_overwrite_last <= '1';
                o_mem_en <= '1';
            when CUR_INC =>
                -- Stop confidence maximizing
                o_max_C <= '0';
                -- Stop W saving
                o_overwrite_last <= '0';
                -- Increase memory cursor
                o_increment_address <= '1';
            when MEM_WRITE_0 =>
                -- Write value of register (last W) in memory
                o_select_mux <= '1';
                o_mem_we <= '1';
                o_mem_en <= '1';
                -- Decrease Confidence
                o_decrement_C <= '1';
            when CUR_INC_0 =>
                -- Stop writing
                o_mem_we <= '0';
                o_mem_en <= '0';
                -- Increase address cursor
                o_increment_address <= '1';
                -- Stop confidence decrement
                o_decrement_C <= '0';
            when WRITE_C =>
                -- Write confidence
                o_select_mux <= '0';
                o_mem_we <= '1';
                o_mem_en <= '1';
                -- Increase address
                o_increment_address <= '1';
        end case;
    end process;
end fsm_arch;

