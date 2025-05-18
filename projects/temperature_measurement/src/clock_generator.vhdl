----------------------------------------------------------------------------------------------------
-- Clock generator
-- Generate required clocks.
-- CLK_SYS: system clock (input)
-- CLK_LDD: clock for the led display driver (800Hz)
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity clock_generator is
    port(
        CLK_SYS : in  std_logic;
        CLK_LDD : out std_logic
    );
end entity;


architecture behavior of clock_generator is
    constant CLK_LDD_DIV : integer range 0 to 2 ** 17 := 125000;

    signal clk_ldd_out : std_logic := '1';
    signal counter     : integer range 0 to 2 ** 17 := 0;
    
begin
    GENERATOR : process (CLK_SYS)
    begin
        if rising_edge(CLK_SYS) then
            if counter = (CLK_LDD_DIV / 2) - 1 then
                clk_ldd_out <= not clk_ldd_out;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    CLK_LDD <= clk_ldd_out;
    
end architecture;
