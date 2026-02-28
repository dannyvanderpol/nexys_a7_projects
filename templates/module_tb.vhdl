----------------------------------------------------------------------------------------------------
-- Test bench template
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity module_under_test is
end entity;


architecture sim of module_under_test is

    constant CLK_PERIOD_NS          : time      := 10 ns;

    component module_under_test is
        port(
            clk     : in  std_logic;
            reset_n : in std_logic
        );
    end component;

    signal stop_clk_tb      : boolean       := false;
    signal clk_tb           : std_logic;
    signal reset_n_tb       : std_logic     := '0';

    begin
        dut : module_under_test
        port map(
            clk     => clk_tb,
            reset_n => reset_n_tb
        );

        -- Clock generation, runs always, test code must be synced with the clock when needed
        clk_gen : process
        begin
            while not stop_clk_tb loop
                clk_tb <= '1';
                wait for CLK_PERIOD_NS / 2;
                clk_tb <= '0';
                wait for CLK_PERIOD_NS / 2;
            end loop;
            wait;
        end process;

        -- Test bench process, generate and check signals
        test_bench : process
        begin
            -- Check initial state after a short delay (reset is active)
            wait for CLK_PERIOD_NS / 10;
            -- assert some_signal = state report "error" severity failure;

            -- Release reset
            reset_n_tb <= '1';

            -- Check module behaivior

            wait for CLK_PERIOD_NS;
            stop_clk_tb <= true;

            report "Test bench passed";
            wait;
        end process;

end architecture;
