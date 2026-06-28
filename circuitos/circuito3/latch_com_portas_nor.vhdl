library ieee;
use ieee.std_logic_1164.all;

entity latch_com_portas_nor is
    Port (
        input_28 : in  std_logic;
        input_30 : in  std_logic;
        output_0 : out std_logic;
        output_2 : out std_logic
    );
end latch_com_portas_nor;

architecture Behavioral of latch_com_portas_nor is
    signal gate_16_out : STD_LOGIC;
    signal gate_20_out : STD_LOGIC;

begin
    gate_16_out <= NOT (input_30 OR gate_20_out);
    gate_20_out <= NOT (gate_16_out OR input_28);
    output_0 <= gate_16_out;
    output_2 <= gate_20_out;

end Behavioral;
