----------------------------------------------------------------------------------------------------
-- LED display driver
-- Displays the value of the digits from the DIGITS input on the LED display
-- CLK: clock for multiplexing the digits, a frequency of about 800Hz should be used.
-- DIGITS: array of 8 digit values ( "xxxxx", "xxxxx", ... ). First element is the right digit.
-- Digit value: 5 bits:
--   Bit 0...3: value for LED display 0...9, a...f
--   Bit 4    : display on (1) or off (0)
-- Show 9:  digit value: 11001
-- Show c:  digit value: 11100
-- Digit off: 0xxxx
-- POINTS: 8 digits determining if the decimal point of the respective display is on off.
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;


entity led_display_driver is
    port(
        CLK_LDD    : in  std_logic;
        DIGITS_LDD : in  led_digits;
        POINTS_LDD : in  std_logic_vector(7 downto 0);
        AN_LDD     : out std_logic_vector(7 downto 0);
        CA_LDD     : out std_logic;
        CB_LDD     : out std_logic;
        CC_LDD     : out std_logic;
        CD_LDD     : out std_logic;
        CE_LDD     : out std_logic;
        CF_LDD     : out std_logic;
        CG_LDD     : out std_logic;
        DP_LDD     : out std_logic
    );
end entity;


architecture behavior of led_display_driver is
    signal an_out   : std_logic_vector(7 downto 0) := (others => '0');
    signal ca_out   : std_logic_vector(6 downto 0) := (others => '0');
    signal dp_out   : std_logic := '0';
    signal index    : integer range 0 to 7 := 0;

begin
    DISPLAY_DRIVER : process (CLK_LDD)
    begin
        if rising_edge(CLK_LDD) then
            -- Anode digit select
            if an_out = (an_out'range => '0') or an_out(7) = '1' then
                an_out(0) <= '1';
                an_out(7) <= '0';
            else
                an_out <= an_out sll 1;
            end if;

            -- BCD to 7 segment conversion
            -- Digit is 5 bits: 0...3: digit, 4: on / off
            -- ca_out: segments (a, b, c, d, e, f, g)
            case DIGITS_LDD(index) is
                when "10000" => ca_out <= "0111111"; -- 0
                when "10001" => ca_out <= "0000110"; -- 1
                when "10010" => ca_out <= "1011011"; -- 2
                when "10011" => ca_out <= "1001111"; -- 3
                when "10100" => ca_out <= "1100110"; -- 4
                when "10101" => ca_out <= "1101101"; -- 5
                when "10110" => ca_out <= "1111101"; -- 6
                when "10111" => ca_out <= "0000111"; -- 7
                when "11000" => ca_out <= "1111111"; -- 8
                when "11001" => ca_out <= "1101111"; -- 9
                when "11010" => ca_out <= "1110111"; -- a
                when "11011" => ca_out <= "1111100"; -- b
                when "11100" => ca_out <= "0111001"; -- c
                when "11101" => ca_out <= "1011110"; -- d
                when "11110" => ca_out <= "1111001"; -- e
                when "11111" => ca_out <= "1110001"; -- f
                when others  => ca_out <= "0000000"; -- off
            end case;

            -- Decimal point select, only show decimal point if digit is on
            if DIGITS_LDD(index)(4) = '1' then
                dp_out <= POINTS_LDD(index);
            else
                dp_out <= '0';
            end if;

            -- Update index
            if index = 7 then
                index <= 0;
            else
                index <= index + 1;
            end if;
        end if;
    end process;

    -- All outputs are active low
    AN_LDD <= not an_out;
    CA_LDD <= not ca_out(0);
    CB_LDD <= not ca_out(1);
    CC_LDD <= not ca_out(2);
    CD_LDD <= not ca_out(3);
    CE_LDD <= not ca_out(4);
    CF_LDD <= not ca_out(5);
    CG_LDD <= not ca_out(6);
    DP_LDD <= not dp_out;

end architecture;
