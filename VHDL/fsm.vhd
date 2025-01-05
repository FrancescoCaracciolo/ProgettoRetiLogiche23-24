library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm is
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
end fsm;

architecture fsm_arch of fsm is
    type S is (IDLE, CHECK_ADDR, DONE,READ_MEM_DATA, 
                    SAVE_VALUE, CUR_INC,
                    MEM_WRITE_0, CUR_INC_0, WRITE_C);
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
    
    -- Signals managment
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
