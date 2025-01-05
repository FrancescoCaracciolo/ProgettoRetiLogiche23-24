library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
    port(
        i_clk :     in std_logic;
        i_rst :     in std_logic;
        i_start :   in std_logic;
        i_add :     in std_logic_vector(15 downto 0);
        i_k :       in std_logic_vector(9 downto 0);
        
        o_done:     out std_logic;
        
        o_mem_addr: out std_logic_vector(15 downto 0);
        i_mem_data: in std_logic_vector(7 downto 0);
        o_mem_data: out std_logic_vector(7 downto 0);
        o_mem_we:   out std_logic;
        o_mem_en:   out std_logic
    );
end project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is

component adder is
    Port (
        addr1 : in std_logic_vector(15 downto 0);
        addr2 : in std_logic_vector(15 downto 0);
        output: out std_logic_vector(15 downto 0)
    );
end component adder;

component splitter is
    port(
        input: in std_logic_vector(10 downto 0);
        
        o_10: out std_logic_vector(9 downto 0);
        o_16: out std_logic_vector(15 downto 0)
    );
end component splitter;

component confidence_countdown is
    port(
        i_clk  : in std_logic;
        i_rst : in std_logic;
        i_dec : in std_logic;
        i_max : in std_logic;
        o_C   : out std_logic_vector(7 downto 0)
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
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_value: in std_logic_vector(7 downto 0);
        i_overwrite: in std_logic;
        
        output: out std_logic_vector(7 downto 0)
    );
end component reg_8;

component mux is
    port(
        i_sel   : in std_logic;
        i_0     : in std_logic_vector(7 downto 0);
        i_1   : in std_logic_vector(7 downto 0);
        output  : out std_logic_vector(7 downto 0)
    );
end component mux;

component fsm is 
    Port ( 
        -- Main component in
        i_clk :                 in std_logic;
        i_rst:                  in std_logic;
        i_start:                in std_logic;
        i_k:                    in std_logic_vector(9 downto 0);
        i_mem_data:             in std_logic_vector(7 downto 0);
        -- Component in
        i_w_count:             in std_logic_vector(9 downto 0);
        -- Main component out
        o_done:                 out std_logic;
        o_mem_we:               out std_logic;
        o_mem_en:               out std_logic;
        -- Components controllers
        o_max_C:                out std_logic;
        o_decrement_C:          out std_logic;
        o_select_mux:           out std_logic;
        o_overwrite_last:       out std_logic;
        o_increment_address:    out std_logic;
        o_rst:                  out std_logic
    
    );
end component fsm;

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
