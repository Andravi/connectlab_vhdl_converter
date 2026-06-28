library ieee;
use ieee.std_logic_1164.all;

entity mutiplex2 is
    Port (
        input_0 : in  std_logic;
        input_2 : in  std_logic;
        input_4 : in  std_logic;
        output_26 : out std_logic
    );
end mutiplex2;

architecture Behavioral of mutiplex2 is
    signal gate_6_out : STD_LOGIC;
    signal gate_9_out : STD_LOGIC;
    signal gate_13_out : STD_LOGIC;
    signal gate_17_out : STD_LOGIC;

begin
    gate_6_out <= NOT input_0;
    gate_9_out <= gate_6_out AND input_2;
    gate_13_out <= gate_9_out OR gate_17_out;
    gate_17_out <= input_0 AND input_4;
    output_26 <= gate_13_out;

end Behavioral;
