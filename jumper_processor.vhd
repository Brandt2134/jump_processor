library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jumper_processor is
    Port ( CLK      : in  STD_LOGIC;
           B        : in  STD_LOGIC;
           JmpPow   : in  STD_LOGIC_VECTOR(7 downto 0);
           Run      : out STD_LOGIC;
           Jmp      : out STD_LOGIC;
           YPos     : out STD_LOGIC_VECTOR(7 downto 0);
           testport : out STD_LOGIC_VECTOR(7 downto 0));
end jumper_processor;

architecture structural of jumper_processor is

    component jumper_controller is
        Port ( CLK       : in STD_LOGIC;
               B         : in STD_LOGIC;
               Y_eq_zero : in STD_LOGIC;
               Run       : out STD_LOGIC;
               Jmp       : out STD_LOGIC;
               ld_YVel   : out STD_LOGIC;
               clr_YVel  : out STD_LOGIC;
               ld_YPos   : out STD_LOGIC;
               clr_YPos  : out STD_LOGIC;
               init_YVel : out STD_LOGIC;
               testport  : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component jumper_datapath is
        Port ( CLK       : in STD_LOGIC;
               ld_YVel   : in STD_LOGIC;
               clr_YVel  : in STD_LOGIC;
               ld_YPos   : in STD_LOGIC;
               clr_YPos  : in STD_LOGIC;
               init_YVel : in STD_LOGIC;
               JmpPow    : in STD_LOGIC_VECTOR(7 downto 0);
               Y_eq_zero : out STD_LOGIC;
               Ypos      : out STD_LOGIC_VECTOR(7 downto 0);
               testport  : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    signal ld_YVel_wire   : STD_LOGIC;
    signal clr_YVel_wire  : STD_LOGIC;
    signal ld_YPos_wire   : STD_LOGIC;
    signal clr_YPos_wire  : STD_LOGIC;
    signal init_YVel_wire : STD_LOGIC;
    signal Y_eq_zero_wire : STD_LOGIC;
    signal ctrl_testport  : STD_LOGIC_VECTOR(7 downto 0);
    signal dp_testport    : STD_LOGIC_VECTOR(7 downto 0);

begin

    ctrl : jumper_controller
        port map (
            CLK => CLK, B => B, Y_eq_zero => Y_eq_zero_wire,
            Run => Run, Jmp => Jmp,
            ld_YVel => ld_YVel_wire, clr_YVel => clr_YVel_wire,
            ld_YPos => ld_YPos_wire, clr_YPos => clr_YPos_wire,
            init_YVel => init_YVel_wire, testport => ctrl_testport);

    dp : jumper_datapath
        port map (
            CLK => CLK,
            ld_YVel => ld_YVel_wire, clr_YVel => clr_YVel_wire,
            ld_YPos => ld_YPos_wire, clr_YPos => clr_YPos_wire,
            init_YVel => init_YVel_wire, JmpPow => JmpPow,
            Y_eq_zero => Y_eq_zero_wire, Ypos => YPos,
            testport => dp_testport);

    testport <= ctrl_testport;

end structural;
