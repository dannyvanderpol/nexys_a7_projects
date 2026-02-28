----------------------------------------------------------------------------------------------------
-- Test bench for the reset controller
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity reset_controller_tb is
end entity;


architecture sim of reset_controller_tb is
    constant CLK_PERIOD_NS          : time      := 10 ns;
    constant POR_RESET_COUNTS_TB    : natural   := 10;
    constant DEBOUNCE_COUNTS_TB     : natural   := 20;
    constant POR_TIMEOUT_NS         : time      := POR_RESET_COUNTS_TB * CLK_PERIOD_NS * 1.5;
    constant BTN_TIMEOUT_NS         : time      := DEBOUNCE_COUNTS_TB * CLK_PERIOD_NS * 1.5;

    component reset_controller is
        generic (
            POR_RESET_COUNTS : natural;
            DEBOUNCE_COUNTS  : natural
        );
        port(
            clk              : in  std_logic;
            btn_reset_n      : in  std_logic;
            reset_n          : out std_logic
        );
    end component;

    signal stop_clk_tb         : boolean   := false;
    signal counter_tb          : integer := 0;
    signal reset_counter_tb    : boolean   := false;
    signal clk_tb              : std_logic;
    signal btn_reset_n_tb      : std_logic := '1';
    signal reset_n_tb          : std_logic;

    begin
        dut : reset_controller
        generic map (
            POR_RESET_COUNTS => POR_RESET_COUNTS_TB,
            DEBOUNCE_COUNTS  => DEBOUNCE_COUNTS_TB
        )
        port map(
            clk              => clk_tb,
            btn_reset_n      => btn_reset_n_tb,
            reset_n          => reset_n_tb
        );

        -- Clock generation, runs always, test code must be synced with the clock when needed
        clk_gen : process
        begin
            while not stop_clk_tb loop
                clk_tb <= '1';
                wait for CLK_PERIOD_NS / 2;
                clk_tb <= '0';
                wait for CLK_PERIOD_NS / 2;
                if reset_counter_tb then
                    counter_tb <= 0;
                else
                    counter_tb <= counter_tb + 1;
                end if;
            end loop;
            wait;
        end process;

        -- Test bench process, generate and check signals
        test_bench : process
        begin
            -- Check initial state after a short delay
            wait for CLK_PERIOD_NS / 10;
            assert reset_n_tb = '0' report "Initial state of reset is not low" severity failure;

            -- Press button, should not have any effect
            wait for CLK_PERIOD_NS * 1;
            btn_reset_n_tb <= '0';
            wait for CLK_PERIOD_NS * 3;
            btn_reset_n_tb <= '1';

            wait on reset_n_tb for POR_TIMEOUT_NS;
            assert reset_n_tb = '1' report "Reset did not go high" severity failure;
            assert counter_tb = POR_RESET_COUNTS_TB report "Reset was high at the wrong time" severity failure;

            -- Make sure the reset controller is in sync with the button
            wait for BTN_TIMEOUT_NS;

            -- Press button async
            wait until falling_edge(clk_tb);
            wait for CLK_PERIOD_NS / 5;
            btn_reset_n_tb <= '0';

            -- Reset should still be inactive
            wait for CLK_PERIOD_NS;
            assert reset_n_tb = '1' report "Reset is low" severity failure;

            -- Simulate some bouncing
            wait for CLK_PERIOD_NS * 5;
            btn_reset_n_tb <= '1';
            wait for CLK_PERIOD_NS * 5;
            btn_reset_n_tb <= '0';

            -- Reset should still be inactive
            wait for CLK_PERIOD_NS;
            assert reset_n_tb = '1' report "Reset is low" severity failure;

            wait for CLK_PERIOD_NS * 10;
            btn_reset_n_tb <= '1';
            wait for CLK_PERIOD_NS * 10;
            btn_reset_n_tb <= '0';

            -- Reset should still be inactive
            wait for CLK_PERIOD_NS;
            assert reset_n_tb = '1' report "Reset is low" severity failure;

            -- Reset counter
            reset_counter_tb <= true;
            wait for CLK_PERIOD_NS;
            reset_counter_tb <= false;

            -- Wait for reset
            wait on reset_n_tb for BTN_TIMEOUT_NS;
            assert reset_n_tb = '0' report "Reset is not low" severity failure;
            -- Number of counts is not exact depending on the moment the button is pressed
            assert (counter_tb >= DEBOUNCE_COUNTS_TB - 2) and (counter_tb <= DEBOUNCE_COUNTS_TB + 2)
                report "Reset was low at the wrong time" severity failure;

            -- Release reset button async
            wait until rising_edge(clk_tb);
            wait for CLK_PERIOD_NS / 5;
            btn_reset_n_tb <= '1';

            -- Reset should still be active
            wait for CLK_PERIOD_NS;
            assert reset_n_tb = '0' report "Reset is high" severity failure;

            -- Simulate some bouncing
            wait for CLK_PERIOD_NS * 5;
            btn_reset_n_tb <= '0';
            wait for CLK_PERIOD_NS * 5;
            btn_reset_n_tb <= '1';

            -- Reset should still be active
            wait for CLK_PERIOD_NS;
            assert reset_n_tb = '0' report "Reset is high" severity failure;

            wait for CLK_PERIOD_NS * 10;
            btn_reset_n_tb <= '0';
            wait for CLK_PERIOD_NS * 10;
            btn_reset_n_tb <= '1';

            -- Reset should still be active
            wait for CLK_PERIOD_NS;
            assert reset_n_tb = '0' report "Reset is high" severity failure;

            -- Reset counter
            reset_counter_tb <= true;
            wait for CLK_PERIOD_NS;
            reset_counter_tb <= false;

            -- Wait for reset
            wait on reset_n_tb for BTN_TIMEOUT_NS;
            assert reset_n_tb = '1' report "Reset is not high" severity failure;
            -- Number of counts is not exact depending on the moment the button is pressed
            assert (counter_tb >= DEBOUNCE_COUNTS_TB - 2) and (counter_tb <= DEBOUNCE_COUNTS_TB + 2)
                report "Reset was low at the wrong time" severity failure;

            wait for CLK_PERIOD_NS;
            stop_clk_tb <= true;

            report "Test bench passed";
            wait;
        end process;

end architecture;
