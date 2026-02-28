----------------------------------------------------------------------------------------------------
-- Top level file for the temperature measurement
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity temperature_measurement is
    port (
        -- System clock: 100MHz
        clk_100mhz  : in  std_logic;

        -- Reset button
        btn_reset_n : in  std_logic;

        -- Debug outputs
        debug       : out std_logic_vector(7 downto 0)
    );
end entity;


architecture struct of temperature_measurement is

    component reset_controller is
        port(
            clk              : in  std_logic;
            btn_reset_n      : in  std_logic;
            reset_n          : out std_logic
        );
    end component;

    signal global_reset_n     : std_logic;
    signal btn_reset_synced_n : std_logic;

begin

    rst_controller : reset_controller
    port map(
        clk              => clk_100mhz,
        btn_reset_n      => btn_reset_n,
        reset_n          => global_reset_n
    );

    debug(0) <= clk_100mhz;
    debug(1) <= global_reset_n;
    debug(2) <= btn_reset_n;
    debug(7 downto 3) <= "00000";

end architecture;
