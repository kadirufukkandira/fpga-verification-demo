--  Designer: Kadir Ufuk Kandira
--	Manuel Test with Vivado for Task 1
--  Tests 3 different Multi-Instance Testbench Timer configurations SIMULTANEOUSLY in one simulation.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_timer_vivado is
    
end entity tb_timer_vivado;

architecture sim of tb_timer_vivado is

    -- Component Declaration
    component timer
        generic (
            clk_freq_hz_g : natural;
            delay_g       : time
        );
        port (
            clk_i   : in  std_ulogic;
            rst_i   : in  std_ulogic;
            start_i : in  std_ulogic;
            done_o  : out std_ulogic
        );
    end component;


    -- CONFIGURATION 1: High Speed (100 MHz), Short Delay (10 us)
    constant FREQ_1   : natural := 100_000_000;
    constant DELAY_1  : time    := 10 us;
    constant PERIOD_1 : time    := 1 sec / FREQ_1; -- Auto Calc
    
    signal clk_1   : std_ulogic := '0';
    signal done_1  : std_ulogic;


    -- CONFIGURATION 2: Low Speed (10 MHz), Same Delay (10 us)
    constant FREQ_2   : natural := 10_000_000;
    constant DELAY_2  : time    := 10 us;
    constant PERIOD_2 : time    := 1 sec / FREQ_2; -- Auto Calc

    signal clk_2   : std_ulogic := '0';
    signal done_2  : std_ulogic;

    -- CONFIGURATION 3: Medium Speed (50 MHz), Long Delay (20 us)
    constant FREQ_3   : natural := 50_000_000;
    constant DELAY_3  : time    := 20 us;
    constant PERIOD_3 : time    := 1 sec / FREQ_3; -- Auto Calc

    signal clk_3   : std_ulogic := '0';
    signal done_3  : std_ulogic;

    -- Common Control Signals
    signal rst_common   : std_ulogic := '0';
    signal start_common : std_ulogic := '0';

begin
    -- INSTANCE 1: High Speed (100 MHz), Short Delay (10 us)
    uut_1 : timer
    generic map (
        clk_freq_hz_g => FREQ_1,
        delay_g       => DELAY_1
    )
    port map (
        clk_i   => clk_1,
        rst_i   => rst_common,
        start_i => start_common,
        done_o  => done_1
    );

    -- INSTANCE 2: Low Speed (10 MHz), Same Delay (10 us)
    uut_2 : timer
    generic map (
        clk_freq_hz_g => FREQ_2,
        delay_g       => DELAY_2
    )
    port map (
        clk_i   => clk_2,
        rst_i   => rst_common,
        start_i => start_common,
        done_o  => done_2
    );

    -- INSTANCE 3: Medium Speed (50 MHz), Long Delay (20 us)
    uut_3 : timer
    generic map (
        clk_freq_hz_g => FREQ_3,
        delay_g       => DELAY_3
    )
    port map (
        clk_i   => clk_3,
        rst_i   => rst_common,
        start_i => start_common,
        done_o  => done_3
    );

    -- CLOCK GENERATORS
    p_clk_1 : process begin
        clk_1 <= '0'; wait for PERIOD_1 / 2;
        clk_1 <= '1'; wait for PERIOD_1 / 2;
    end process;

    p_clk_2 : process begin
        clk_2 <= '0'; wait for PERIOD_2 / 2;
        clk_2 <= '1'; wait for PERIOD_2 / 2;
    end process;

    p_clk_3 : process begin
        clk_3 <= '0'; wait for PERIOD_3 / 2;
        clk_3 <= '1'; wait for PERIOD_3 / 2;
    end process;
	
    -- MAIN STIMULUS
    p_stim : process
    begin
        -- 1. Reset All
        rst_common   <= '1';
        start_common <= '0';
        wait for 100 ns;
        rst_common   <= '0';
        wait for 200 ns;

        -- 2. Start All Simultaneously
        start_common <= '1';
        wait for 100 ns; -- Long enough pulse for the slowest clock (10MHz = 100ns period)
        start_common <= '0';

        -- 3. Wait and Observe > Just wait long enough for the longest test (Instance 3 = 20 us)
        wait for 30 us;

        -- 4. Check Results
        assert done_1 = '1' report "Test 1 Failed" severity error;
        assert done_2 = '1' report "Test 2 Failed" severity error;
        assert done_3 = '1' report "Test 3 Failed" severity error;

        report "ALL 3 CONFIGURATIONS PASSED!";
        assert false report "Simulation Finished" severity failure;
    end process;

end architecture;