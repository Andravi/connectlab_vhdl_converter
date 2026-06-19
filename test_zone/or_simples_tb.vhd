-- Testbench gerado automaticamente a partir de tabela verdade
-- Arquivo CSV: teste.csv

library ieee;
use ieee.std_logic_1164.all;

entity or_simples_tb is
end or_simples_tb;

architecture sim of or_simples_tb is
    signal input_2 : std_logic;
    signal input_4 : std_logic;
    signal input_0 : std_logic;
    signal output_26 : std_logic;
begin

    -- Instancia o componente
    UUT: entity work.or_simples port map (
        input_2 => input_2,
        input_4 => input_4,
        input_0 => input_0,
        output_26 => output_26
    );

    process
    begin
        -- Testa todas as combinações da tabela verdade

        -- Teste 1: input_2=0 input_4=0 input_0=0 output_26=0
        input_2 <= '0'; input_4 <= '0'; input_0 <= '0';
        wait for 10 ns;
        assert (output_26 = '0')
            report "Falha no teste 1: output_26 deveria ser 0 mas foi " & std_logic'image(output_26)
            severity error;

        -- Teste 2: input_2=1 input_4=0 input_0=0 output_26=1
        input_2 <= '1'; input_4 <= '0'; input_0 <= '0';
        wait for 10 ns;
        assert (output_26 = '1')
            report "Falha no teste 2: output_26 deveria ser 1 mas foi " & std_logic'image(output_26)
            severity error;

        -- Teste 3: input_2=0 input_4=1 input_0=0 output_26=0
        input_2 <= '0'; input_4 <= '1'; input_0 <= '0';
        wait for 10 ns;
        assert (output_26 = '0')
            report "Falha no teste 3: output_26 deveria ser 0 mas foi " & std_logic'image(output_26)
            severity error;

        -- Teste 4: input_2=1 input_4=0 input_0=1 output_26=0
        input_2 <= '1'; input_4 <= '0'; input_0 <= '1';
        wait for 10 ns;
        assert (output_26 = '0')
            report "Falha no teste 4: output_26 deveria ser 0 mas foi " & std_logic'image(output_26)
            severity error;

        -- Teste 5: input_2=0 input_4=1 input_0=1 output_26=1
        input_2 <= '0'; input_4 <= '1'; input_0 <= '1';
        wait for 10 ns;
        assert (output_26 = '1')
            report "Falha no teste 5: output_26 deveria ser 1 mas foi " & std_logic'image(output_26)
            severity error;

        -- Teste 6: input_2=1 input_4=1 input_0=0 output_26=1
        input_2 <= '1'; input_4 <= '1'; input_0 <= '0';
        wait for 10 ns;
        assert (output_26 = '1')
            report "Falha no teste 6: output_26 deveria ser 1 mas foi " & std_logic'image(output_26)
            severity error;

        -- Teste 7: input_2=1 input_4=1 input_0=1 output_26=1
        input_2 <= '1'; input_4 <= '1'; input_0 <= '1';
        wait for 10 ns;
        assert (output_26 = '1')
            report "Falha no teste 7: output_26 deveria ser 1 mas foi " & std_logic'image(output_26)
            severity error;

        report "✅ Todos os testes passaram!";
        std.env.finish;
    end process;

end sim;