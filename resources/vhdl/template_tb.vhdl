----------------------------------------------------------------------------------------------------
-- Template test bench
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity template_tb is
end entity;


architecture test_bench of template_tb is

    constant CLK_PERIOD : time := 50ns;

    component template
        port(
            CLK_ : in std_logic
        );
    end component;

    signal CLK_TB : std_logic := '0';
    
    begin
        DUT : template port map(
            CLK_ => CLK_TB
        );

        STIMULUS : process

        begin
            wait for CLK_PERIOD;
            

            report "Test bench passed";
            wait;
        end process;

end architecture;
