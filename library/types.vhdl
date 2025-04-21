----------------------------------------------------------------------------------------------------
-- Types
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package types is
    -- 8 digits, 5 bits per digit. Bit 0...3: digit value 0...9, A...F, bit 4: display on (1) or off (0)
    type led_digits is array(0 to 7) of std_logic_vector(4 downto 0);
end package;
