library ieee;
use ieee.std_logic_1164.all;

entity Decodificador2_4 is
    Port (
        input_0 : in  std_logic;
        input_2 : in  std_logic;
        output_26 : out std_logic;
        output_28 : out std_logic;
        output_30 : out std_logic;
        output_32 : out std_logic
    );
end Decodificador2_4;

architecture Behavioral of Decodificador2_4 is
    signal gate_4_out : STD_LOGIC;
    signal gate_7_out : STD_LOGIC;
    signal gate_10_out : STD_LOGIC;
    signal gate_14_out : STD_LOGIC;
    signal gate_18_out : STD_LOGIC;
    signal gate_22_out : STD_LOGIC;

begin
    gate_4_out <= NOT input_0;
    gate_7_out <= NOT input_2;
    gate_10_out <= gate_4_out AND gate_7_out;
    gate_14_out <= input_0 AND gate_7_out;
    gate_18_out <= input_2 AND gate_4_out;
    gate_22_out <= input_0 AND input_2;
    output_26 <= gate_10_out;
    output_28 <= gate_14_out;
    output_30 <= gate_18_out;
    output_32 <= gate_22_out;

end Behavioral;
