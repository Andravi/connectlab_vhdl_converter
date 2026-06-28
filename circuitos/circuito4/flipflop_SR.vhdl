library ieee;
use ieee.std_logic_1164.all;

entity flipflop_SR is
    Port (
        input_82 : in  std_logic;
        input_84 : in  std_logic;
        input_86 : in  std_logic;
        output_0 : out std_logic;
        output_2 : out std_logic
    );
end flipflop_SR;

architecture Behavioral of flipflop_SR is
    signal gate_68_out : STD_LOGIC;
    signal gate_72_out : STD_LOGIC;
    signal gate_92_out : STD_LOGIC;
    signal gate_96_out : STD_LOGIC;

begin
    gate_68_out <= input_86 AND input_84;
    gate_72_out <= input_84 AND input_82;
    gate_92_out <= NOT (gate_96_out OR gate_72_out);
    gate_96_out <= NOT (gate_68_out OR gate_92_out);
    output_0 <= gate_96_out;
    output_2 <= gate_92_out;

end Behavioral;
