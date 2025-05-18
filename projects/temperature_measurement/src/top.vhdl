----------------------------------------------------------------------------------------------------
-- Top level file for the project
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.types.all;


entity top is
    port(
        -- System clock input 100MHz
        SYS_CLK : in std_logic;
        -- Cathodes of the segments A...G and decimal point
        CA      : out std_logic;
        CB      : out std_logic;
        CC      : out std_logic;
        CD      : out std_logic;
        CE      : out std_logic;
        CF      : out std_logic;
        CG      : out std_logic;
        DP      : out std_logic;
        -- Common annode of each digit
        AN      : out std_logic_vector(7 downto 0);
        -- Debug output: diplay clock (800Hz)
        JD1     : out std_logic
    );
end entity;


architecture structure of top is

    component clock_generator is
        port(
            CLK_SYS : in  std_logic;
            CLK_LDD : out std_logic
        );
    end component;

    component led_display_driver is
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

    signal ldd_clock  : std_logic;
    signal ldd_digits : led_digits;
    signal ldd_points : std_logic_vector(7 downto 0);

begin
    GENERATOR : clock_generator port map(
        CLK_SYS => SYS_CLK,
        CLK_LDD => ldd_clock
    );

    LED_DISPLAY : led_display_driver port map(
        CLK_LDD    => ldd_clock,
        DIGITS_LDD => ldd_digits,
        POINTS_LDD => ldd_points,
        AN_LDD     => AN,
        CA_LDD     => CA,
        CB_LDD     => CB,
        CC_LDD     => CC,
        CD_LDD     => CD,
        CE_LDD     => CE,
        CF_LDD     => CF,
        CG_LDD     => CG,
        DP_LDD     => DP
    );

    -- Fixed output, will be replace by temperature
    ldd_points <= "01010010";
    ldd_digits(0) <= "10001";
    ldd_digits(1) <= "10010";
    ldd_digits(2) <= "10011";
    ldd_digits(3) <= "10100";
    ldd_digits(4) <= "10101";
    ldd_digits(5) <= "10110";
    ldd_digits(6) <= "10111";
    ldd_digits(7) <= "11000";

    JD1 <= ldd_clock;

end architecture;
