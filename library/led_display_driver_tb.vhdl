----------------------------------------------------------------------------------------------------
-- Test bench for the LED display driver
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;


entity led_display_driver_tb is
end entity;


architecture test_bench of led_display_driver_tb is

    constant CLK_PERIOD : time := 50ns;

    component led_display_driver
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
    end component;

    signal CLK_TB    : std_logic := '0';
    signal DIGITS_TB : led_digits;
    signal POINTS_TB : std_logic_vector(7 downto 0);
    signal AN_TB     : std_logic_vector(7 downto 0);
    signal CA_TB     : std_logic;
    signal CB_TB     : std_logic;
    signal CC_TB     : std_logic;
    signal CD_TB     : std_logic;
    signal CE_TB     : std_logic;
    signal CF_TB     : std_logic;
    signal CG_TB     : std_logic;
    signal DP_TB     : std_logic;
    --signal RET_VALUE : integer;

    function set_digits_data (
        start_value : in integer;
        end_value   : in integer) return led_digits is
        variable digits_out : led_digits;
    begin
        for i in 0 to 7 loop
            digits_out(i) := '1' & std_logic_vector(to_unsigned(i, 4));
        end loop;
        return digits_out;
    end function;

    function check_output (
        digit_value    : std_logic_vector(4 downto 0);
        segments_value : std_logic_vector(6 downto 0)) return integer is
        variable ret_value : integer;
    begin
        ret_value := 1 when (
            (digit_value = "10000" and segments_value = "0000001") or
            (digit_value = "10001" and segments_value = "1001111") or
            (digit_value = "10010" and segments_value = "0010010") or
            (digit_value = "10011" and segments_value = "0000110") or
            (digit_value = "10100" and segments_value = "1001100") or
            (digit_value = "10101" and segments_value = "0100100") or
            (digit_value = "10110" and segments_value = "0100000") or
            (digit_value = "10111" and segments_value = "0001111") or
            (digit_value = "11000" and segments_value = "0000000") or
            (digit_value = "11001" and segments_value = "0000100") or
            (digit_value = "11010" and segments_value = "0001000") or
            (digit_value = "11011" and segments_value = "1100000") or
            (digit_value = "11100" and segments_value = "0110001") or
            (digit_value = "11101" and segments_value = "1000010") or
            (digit_value = "11110" and segments_value = "0110000") or
            (digit_value = "11111" and segments_value = "0111000") or
            (digit_value(4) = '0' and segments_value = "1111111")
        ) else 0;

        return ret_value;
    end function;

    begin
        DUT : led_display_driver port map(
            CLK_LDD    => CLK_TB,
            DIGITS_LDD => DIGITS_TB,
            POINTS_LDD => POINTS_TB,
            AN_LDD     => AN_TB,
            CA_LDD     => CA_TB,
            CB_LDD     => CB_TB,
            CC_LDD     => CC_TB,
            CD_LDD     => CD_TB,
            CE_LDD     => CE_TB,
            CF_LDD     => CF_TB,
            CG_LDD     => CG_TB,
            DP_LDD     => DP_TB
        );

        STIMULUS : process

        variable SEGMENTS : std_logic_vector(6 downto 0);

        begin
            wait for CLK_PERIOD;
            -- Check initial state, all displays off
            assert AN_TB = (an_TB'range => '1')
                report "Inital value of AN is not correct" severity failure;
            assert CA_TB = '1' report "Inital value of CA is not correct" severity failure;
            assert CB_TB = '1' report "Inital value of CB is not correct" severity failure;
            assert CC_TB = '1' report "Inital value of CC is not correct" severity failure;
            assert CD_TB = '1' report "Inital value of CD is not correct" severity failure;
            assert CE_TB = '1' report "Inital value of CE is not correct" severity failure;
            assert CF_TB = '1' report "Inital value of CF is not correct" severity failure;
            assert CG_TB = '1' report "Inital value of CG is not correct" severity failure;
            assert DP_TB = '1' report "Inital value of DP is not correct" severity failure;

            -- Set digits from 0 to 7
            DIGITS_TB <= set_digits_data(0, 7);
            -- Set digital points alternating
            POINTS_TB <= "01010101";
            -- Generate clock and check output on each clock
            for i in 0 to 7 loop
                CLK_TB <= not CLK_TB;
                wait for CLK_PERIOD / 2;
                -- Check output
                SEGMENTS := CA_TB & CB_TB & CC_TB & CD_TB & CE_TB & CF_TB & CG_TB;
                assert check_output(DIGITS_TB(i), SEGMENTS) = 1
                    report "Output is not correct for digit " & integer'image(i) severity failure;
                assert not POINTS_TB(i) = DP_TB
                    report "Decimal point is not correct for " & integer'image(i) severity failure;
                CLK_TB <= not CLK_TB;
                wait for CLK_PERIOD / 2;
            end loop;

            -- Set digits from 8 to 15 (F)
            DIGITS_TB <= set_digits_data(8, 15);
            -- Set digital points alternating
            POINTS_TB <= "10101010";
            -- Generate clock and check output on each clock
            for i in 0 to 7 loop
                CLK_TB <= not CLK_TB;
                wait for CLK_PERIOD / 2;
                -- Check output
                SEGMENTS := CA_TB & CB_TB & CC_TB & CD_TB & CE_TB & CF_TB & CG_TB;
                assert check_output(DIGITS_TB(i), SEGMENTS) = 1
                    report "Output is not correct for digit " & integer'image(i) severity failure;
                assert not POINTS_TB(i) = DP_TB
                    report "Decimal point is not correct for " & integer'image(i) severity failure;
                CLK_TB <= not CLK_TB;
                wait for CLK_PERIOD / 2;
            end loop;

            -- Test for digits off
            DIGITS_TB(0) <= "10001";
            DIGITS_TB(1) <= "00001";
            POINTS_TB <= "11111111";
            for i in 0 to 1 loop
                CLK_TB <= not CLK_TB;
                wait for CLK_PERIOD / 2;
                -- Check output
                SEGMENTS := CA_TB & CB_TB & CC_TB & CD_TB & CE_TB & CF_TB & CG_TB;
                assert check_output(DIGITS_TB(i), SEGMENTS) = 1
                    report "Output is not correct for digit " & integer'image(i) severity failure;
                assert (DIGITS_TB(i)(4) nand POINTS_TB(i)) = DP_TB
                    report "Decimal point is not correct for " & integer'image(i) severity failure;
                CLK_TB <= not CLK_TB;
                wait for CLK_PERIOD / 2;
            end loop;

            report "Test bench passed";
            wait;
        end process;

end architecture;
