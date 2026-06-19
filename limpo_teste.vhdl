library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Teste is
    Port (
        input_4 : in  STD_LOGIC;
        input_6 : in  STD_LOGIC;
        output_10 : out STD_LOGIC
    );
end Teste;

architecture Behavioral of Teste is

begin
    output_10 <= input_4 OR input_6;

end Behavioral;
