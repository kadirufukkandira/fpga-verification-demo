library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- Vunit setup
library vunit_lib;
context vunit_lib.vunit_context;

-- Wrapper logic
entity tb_timer_vunit is
    generic (
        runner_cfg    : string;
        clk_freq_hz_g : natural := 100_000_000;
        delay_ns_g    : natural := 10000  -- Input from Python as Integer (ns)
    );
end entity;

architecture sim of tb_timer_vunit is

    component timer
        generic (
            clk_freq_hz_g : natural;
            delay_g       : time      -- RTL still uses TIME
        );
        port (
            clk_i   : in  std_ulogic;
            rst_i   : in  std_ulogic;
            start_i : in  std_ulogic;
            done_o  : out std_ulogic
        );
    end component;

    signal clk_i   : std_ulogic := '0';
    signal rst_i   : std_ulogic := '0';
    signal start_i : std_ulogic := '0';
    signal done_o  : std_ulogic;

	-- For Clock Generation
    constant clk_period_c : time := 1 sec / clk_freq_hz_g;

    -- Convert Integer to Time inside VHDL
    constant delay_c : time := delay_ns_g * 1 ns;

begin

    -- Clock Generation
    p_clk : process
    begin
        clk_i <= '0';
        wait for clk_period_c / 2;
        clk_i <= '1';
        wait for clk_period_c / 2;
    end process;

    -- Pass the Converted Time to the RTL
    uut : timer
    generic map (
        clk_freq_hz_g => clk_freq_hz_g,
        delay_g       => delay_c      -- Mapping: Time <= Time
    )
    port map (
        clk_i   => clk_i,
        rst_i   => rst_i,
        start_i => start_i,
        done_o  => done_o
    );

    -- Main Test Process
    p_main : process
    begin
        test_runner_setup(runner, runner_cfg);

        -- Reset
        rst_i <= '1';
        wait for 100 ns;
        wait until rising_edge(clk_i);
        rst_i <= '0';
        -- IDLE STATE
        wait for clk_period_c * 5;
        check(done_o = '1', "Error: Should be IDLE after reset");

        -- Start 
        start_i <= '1';
        wait until rising_edge(clk_i);
        start_i <= '0';

        wait for 1 ns; 
        check(done_o = '0', "Error: Should be BUSY after start");

        -- Wait for Completion : COUNTING STATE
        wait until done_o = '1' for delay_c * 1.1;

        if done_o = '0' then
            error("Timeout: Timer did not finish in time");
        else
            info("Success: Timer finished correctly");
        end if;
		-- Kill Switch
        test_runner_cleanup(runner);
    end process;

end architecture;