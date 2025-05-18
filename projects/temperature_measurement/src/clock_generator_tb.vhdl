----------------------------------------------------------------------------------------------------
-- Test bench for clock generator
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity clock_generator_tb is
end entity;


architecture behavior of clock_generator_tb is

    constant CLK_PERIOD : time := 10ns;

    component clock_generator is
        port(
            CLK_SYS : in  std_logic;
            CLK_LDD : out std_logic
        );
    end component;

    signal      CLK_TB     : std_logic := '0';
    signal      CLK_LDD_TB : std_logic;

    begin
        DUT : clock_generator port map(
            CLK_SYS => CLK_TB,
            CLK_LDD => CLK_LDD_TB
        );

        STIMULUS : process
        begin
            -- use small delay to initialize the clock generator
            wait for CLK_PERIOD;
            assert CLK_LDD_TB = '1' report "Output is not low" severity failure;
            -- generate clock and check the clock output for the expected behavior
            for i in 0 to 200000 loop
                -- Clock high
                CLK_TB <= '1';
                if (i >= 0) and (i < 62500) then
                    assert CLK_LDD_TB = '1' report "Output is not high" severity failure;
                end if;
                if (i >= 62500) and (i < 125000) then
                    assert CLK_LDD_TB = '0' report "Output is not low" severity failure;
                end if;
                if (i >= 125000) and (i < 187500) then
                    assert CLK_LDD_TB = '1' report "Output is not high" severity failure;
                end if;
                if i >= 187500 then
                    assert CLK_LDD_TB = '0' report "Output is not low" severity failure;
                end if;
                -- Finish clock
                wait for CLK_PERIOD / 2;
                -- Clock low
                CLK_TB <= '0';
                wait for CLK_PERIOD / 2;
            end loop;

            report "Test bench passed";
            wait;
        end process;

end architecture;
