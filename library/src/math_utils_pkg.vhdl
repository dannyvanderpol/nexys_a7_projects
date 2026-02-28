----------------------------------------------------------------------------------------------------
-- Package for caclulations
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


package math_utils_pkg is
  -- Maximum of two naturals
  function max_nat(a, b : natural) return natural;

  -- Ceiling log2 (number of bits needed for n values)
  function clog2(n : positive) return natural;

end package math_utils_pkg;


package body math_utils_pkg is

    -- Maximum of two naturals
    function max_nat(a, b : natural) return natural is
    begin
        if a > b then
            return a;
        else
            return b;
        end if;
    end function;

    -- Ceiling log2 (number of bits needed for n values)
    function clog2(n : positive) return natural is
        variable v : natural := 0;
        variable x : natural := n - 1;
    begin
        while x > 0 loop
            v := v + 1;
            x := x / 2;
        end loop;
        return v;
    end function;

end package body math_utils_pkg;
