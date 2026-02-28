----------------------------------------------------------------------------------------------------
-- Reset controller
-- - Generate a power on reset (POR)
-- - Generate a reset when the reset button is pressed
-- The reset signal is active high
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.math_utils_pkg.all;


entity reset_controller is
    generic (
        POR_RESET_COUNTS : natural := 100;
        DEBOUNCE_COUNTS  : natural := 500_000
    );
    port(
        clk              : in  std_logic;
        btn_reset_n      : in  std_logic;
        reset_n          : out std_logic
    );
end entity;


architecture rtl of reset_controller is
    constant COUNTER_WIDTH : natural := clog2(max_nat(1,
                                              max_nat(POR_RESET_COUNTS, DEBOUNCE_COUNTS)));

    signal reset_state      : std_logic := '1';
    signal por_state        : std_logic := '1';
    signal counter          : unsigned(COUNTER_WIDTH downto 0) := (others => '0');
    signal btn_sync_ff      : std_logic_vector(1 downto 0) := (others => '0');
    signal btn_sync_state_n : std_logic := '0';
    signal btn_deb_state_n  : std_logic := '0';
    signal btn_state        : std_logic := '0';

begin
    reset_process : process (clk)
    begin
        if rising_edge(clk) then
            -- Always keep button state in sync with clock
            btn_sync_ff <= btn_sync_ff(0) & btn_reset_n;
            btn_sync_state_n <= btn_sync_ff(1);

            -- POR mode
            if por_state = '1' then
                if reset_state = '1' then
                    if counter = POR_RESET_COUNTS - 1 then
                        por_state <= '0';
                        counter <= (others => '0');
                    else
                        counter <= counter + 1;
                    end if;
                end if;
            else
                -- Reset can be initiated by button
                -- First debounce the button
                if btn_sync_state_n = btn_deb_state_n then
                    -- button is not bouncing, let's count
                    if counter = DEBOUNCE_COUNTS - 1 then
                        -- Button stable, implement reset, active low
                        btn_state <= not btn_sync_state_n;
                    else
                        counter <= counter + 1;
                    end if;
                else
                    -- Button is bounching, reset counter
                    counter <= (others => '0');
                    btn_deb_state_n <= btn_sync_state_n;
                end if;
            end if;
        end if;
    end process;

    -- Reset state is either form POR or button
    reset_state <= por_state or btn_state;

    -- Output is inverted
    reset_n <= not reset_state;

end architecture;
