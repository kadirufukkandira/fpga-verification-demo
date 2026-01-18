--	Designer: Kadir Ufuk Kandira
--	Parametic timer to count based on the input clock frequency and a time generic.
--	Synthesis-ready > Adjust generic parameters and connect ports to representetive fpga ports and good to go

--	Internally calculates the target cycle count based on the generic frequency and delay.
--	Starts counting on a 'start_i' pulse, but ignores the input if already busy.
--	'done_o' stays High (asserted) whenever the timer is idle or has finished.
--	Fully synchronous logic with support for synchronous reset.



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.math_real.all;   

entity timer is
    generic (
        clk_freq_hz_g : natural := 100_000_000; -- Clock frequency in Hz (assigned initial values to prevent initial X states in simulation)
        delay_g       : time    := 1 ms         -- Delay duration , e.g. , 100 ms
    );
    port (
        clk_i   : in  std_ulogic;
        rst_i 	: in  std_ulogic;	-- synchronous reset replaced "arst_i"
        start_i : in  std_ulogic;	-- No effect if not done_o
        done_o  : out std_ulogic	-- '1 ' when not counting (" not busy ")
    );
end entity timer;

architecture rtl of timer is

    -- Math: (Target Time / 1 sec) * Frequency -> Convert the time into ticks
    -- Convert time to nanoseconds first to avoid integer division returning zero
	-- Internally calculates the target cycle count based on the generic frequency and delay.
    constant c_target_cycles : integer := integer( real(delay_g / 1 ns) * (real(clk_freq_hz_g) / 1.0e9) );


    signal counter : integer range 0 to c_target_cycles;
	-- States definition
    type t_state is (IDLE, COUNTING);
    signal state : t_state;

begin

    p_main : process(clk_i)
    begin
        -- Fully synchronous logic
        if rising_edge(clk_i) then
            
            -- synchronous reset
            if rst_i = '1' then
                state   <= IDLE;
                counter <= 0;
                done_o  <= '1';

            -- FSM:IDLE
			-- '1' when not counting (" not busy ")
            else
                case state is
                    when IDLE =>
                        done_o <= '1';
                        -- Starts counting on a 'start_i' pulse, if not already busy (COUNTING)
						-- No effect if not done_o
                        if start_i = '1' then
                            state   <= COUNTING;
                            counter <= 1;
                            done_o  <= '0';
                        end if;
					-- FSM:COUNTING
                    when COUNTING =>
                        done_o <= '0';
                        --	'done_o' stays High (asserted) whenever the timer is idle or has finished.
                        if counter = c_target_cycles then
                            state  <= IDLE;
                            done_o <= '1';
                        else
                            counter <= counter + 1;
                        end if;

                    when others =>
                        state <= IDLE;
                end case;
            end if; 
            
        end if; 
    end process;

-- Formal Verification (PSL)
-- psl default clock is rising_edge(clk_i);

-- Reset behavior: output high, counter zero
-- psl assert always (rst_i = '1' -> next(done_o = '1' and counter = 0));

-- Idle state: output stays high if not starting
-- psl assert always (state = IDLE and start_i = '0' -> done_o = '1');

-- Start transition: if starting, output goes low next cycle
-- psl assert always (state = IDLE and start_i = '1' -> next(done_o = '0'));

-- Counting state: output must remain low
-- psl assert always (state = COUNTING -> done_o = '0');

-- Cycle check: counter must increment exactly by 1
-- psl assert always (state = COUNTING and counter < c_target_cycles -> next(counter) = counter + 1);

-- Completion: output goes high when target reached
-- psl assert always (counter = c_target_cycles -> next(done_o = '1'));

-- eventually finishes
-- psl assert always (start_i = '1' -> eventually! done_o = '1');	

end architecture;