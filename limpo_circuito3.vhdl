library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Teste is
    Port (
        input_0 : in  STD_LOGIC;
        input_2 : in  STD_LOGIC;
        input_4 : in  STD_LOGIC;
        output_26 : out STD_LOGIC
    );
end Teste;

architecture Behavioral of Teste is
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
