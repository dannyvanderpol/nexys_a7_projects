----------------------------------------------------------------------------------------------------
-- Module template
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity module is
    -- generic (
    -- );
    port(
        clk     : in  std_logic;
        reset_n : in std_logic
    );
end entity;


architecture rtl of module is

begin

    reset_process : process (clk, reset_n)
    begin
        if reset_n = '0' then
            -- Asynchrone reset
        elsif rising_edge(clk) then
            -- Process logic
        end if;
    end process;

end architecture;
