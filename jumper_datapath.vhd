library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity jumper_datapath is
    Port (
        CLK       : in  STD_LOGIC;
        ld_YVel   : in  STD_LOGIC;
        clr_YVel  : in  STD_LOGIC;
        ld_YPos   : in  STD_LOGIC;
        clr_YPos  : in  STD_LOGIC;
        init_YVel : in  STD_LOGIC;
        JmpPow    : in  STD_LOGIC_VECTOR(7 downto 0);
        Y_eq_zero : out STD_LOGIC;
        Ypos      : out STD_LOGIC_VECTOR(7 downto 0);
        testport  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end jumper_datapath;

architecture structural of jumper_datapath is

    component reg8
        Port ( CLK : in STD_LOGIC;
               ld  : in STD_LOGIC;
               clr : in STD_LOGIC;
               D   : in STD_LOGIC_VECTOR(7 downto 0);
               Q   : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component mux8
        Port ( A   : in STD_LOGIC_VECTOR(7 downto 0);
               B   : in STD_LOGIC_VECTOR(7 downto 0);
               sel : in STD_LOGIC;
               Y   : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component adder8
        Port ( A : in STD_LOGIC_VECTOR(7 downto 0);
               B : in STD_LOGIC_VECTOR(7 downto 0);
               S : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component eq8
        Port ( A  : in STD_LOGIC_VECTOR(7 downto 0);
               B  : in STD_LOGIC_VECTOR(7 downto 0);
               EQ : out STD_LOGIC);
    end component;

    signal YVelReg_Q   : STD_LOGIC_VECTOR(7 downto 0);
    signal YPosReg_Q   : STD_LOGIC_VECTOR(7 downto 0);
    signal YVel_dec    : STD_LOGIC_VECTOR(7 downto 0);
    signal YVel_mux_out: STD_LOGIC_VECTOR(7 downto 0);
    signal YPos_sum    : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- Decrement current velocity by 1 (gravity)
    U_YVel_adder : adder8
        port map (A => YVelReg_Q, B => x"FF", S => YVel_dec);

    -- On jump init, load JmpPow instead of the decremented velocity
    U_YVel_mux : mux8
        port map (A => YVel_dec, B => JmpPow, sel => init_YVel, Y => YVel_mux_out);

    U_YVelReg : reg8
        port map (CLK => CLK, ld => ld_YVel, clr => clr_YVel, D => YVel_mux_out, Q => YVelReg_Q);

    -- Y position accumulates velocity each cycle
    U_YPos_adder : adder8
        port map (A => YPosReg_Q, B => YVel_mux_out, S => YPos_sum);

    U_YPosReg : reg8
        port map (CLK => CLK, ld => ld_YPos, clr => clr_YPos, D => YPos_sum, Q => YPosReg_Q);

    -- Detect ground contact (Y position back to zero)
    U_eq : eq8
        port map (A => YPosReg_Q, B => x"00", EQ => Y_eq_zero);

    Ypos     <= YPosReg_Q;
    testport <= YVelReg_Q;

end structural;
