library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jumper_controller is
    Port ( CLK       : in  STD_LOGIC;
           B         : in  STD_LOGIC;
           Y_eq_zero : in  STD_LOGIC;
           Run       : out STD_LOGIC;
           Jmp       : out STD_LOGIC;
           ld_YVel   : out STD_LOGIC;
           clr_YVel  : out STD_LOGIC;
           ld_YPos   : out STD_LOGIC;
           clr_YPos  : out STD_LOGIC;
           init_YVel : out STD_LOGIC;
           testport  : out STD_LOGIC_VECTOR(7 downto 0));
end jumper_controller;

architecture structural of jumper_controller is

    component dff
        Port ( CLK : in STD_LOGIC;
               D   : in STD_LOGIC;
               Q   : out STD_LOGIC);
    end component;

    component notgate
        Port ( A : in STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component andgate
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component orgate
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    -- S = current state (0 = Run, 1 = Jump), NS = next state
    signal S, NS    : STD_LOGIC;
    signal S_not    : STD_LOGIC;
    signal Yeq_not  : STD_LOGIC;
    signal S_term1  : STD_LOGIC; -- Run state, button pressed -> start jump
    signal S_term2  : STD_LOGIC; -- Jump state, not yet landed -> stay jumping

begin

    U_not_S   : notgate  port map (A => S, Y => S_not);
    U_not_Yeq : notgate  port map (A => Y_eq_zero, Y => Yeq_not);

    U_and1 : andgate port map (A => S_not, B => B,       Y => S_term1);
    U_and2 : andgate port map (A => S,     B => Yeq_not, Y => S_term2);

    U_or  : orgate port map (A => S_term1, B => S_term2, Y => NS);
    U_dff : dff    port map (CLK => CLK, D => NS, Q => S);

    Run <= not NS;
    Jmp <= NS;

    ld_YVel   <= '1';
    clr_YVel  <= '0';
    ld_YPos   <= NS;
    clr_YPos  <= not NS;
    init_YVel <= S_term1;

    testport <= "0000000" & NS;

end structural;
