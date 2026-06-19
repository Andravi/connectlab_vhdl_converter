-- Testbench gerado automaticamente a partir de tabela verdade
-- Arquivo CSV: teste.csv

library ieee;
use ieee.std_logic_1164.all;

entity and_gate_tb is
end and_gate_tb;

architecture sim of and_gate_tb is
    signal a : std_logic;
    signal b : std_logic;
    signal y : std_logic;
begin

    -- Instancia o componente
    UUT: entity work.and_gate port map (
        a => a,
        b => b,
        y => y
    );

    process
    begin
        -- Testa todas as combinações da tabela verdade

        -- Teste 1: a=0 b=0 y=0
        a <= '0'; b <= '0';
        wait for 10 ns;
        assert (y = '0')
            report "Falha no teste 1: y deveria ser 0 mas foi " & std_logic'image(y)
            severity error;

        -- Teste 2: a=0 b=1 y=0
        a <= '0'; b <= '1';
        wait for 10 ns;
        assert (y = '0')
            report "Falha no teste 2: y deveria ser 0 mas foi " & std_logic'image(y)
            severity error;

        -- Teste 3: a=1 b=0 y=0
        a <= '1'; b <= '0';
        wait for 10 ns;
        assert (y = '0')
            report "Falha no teste 3: y deveria ser 0 mas foi " & std_logic'image(y)
            severity error;

        -- Teste 4: a=1 b=1 y=1
        a <= '1'; b <= '1';
        wait for 10 ns;
        assert (y = '1')
            report "Falha no teste 4: y deveria ser 1 mas foi " & std_logic'image(y)
            severity error;

        report "Todos os testes passaram!";
        std.env.finish;
    end process;

end sim;