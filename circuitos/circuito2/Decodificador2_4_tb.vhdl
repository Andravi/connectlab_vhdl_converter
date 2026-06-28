-- Testbench gerado automaticamente a partir de tabela verdade
-- Arquivo CSV: uploads/tabela_verdade_base.csv

library ieee;
use ieee.std_logic_1164.all;

entity Decodificador2_4_tb is
end Decodificador2_4_tb;

architecture sim of Decodificador2_4_tb is
    signal input_2 : std_logic;
    signal input_0 : std_logic;
    signal output_26 : std_logic;
    signal output_28 : std_logic;
    signal output_30 : std_logic;
    signal output_32 : std_logic;
begin

    -- Instancia o componente
    UUT: entity work.Decodificador2_4 port map (
        input_2 => input_2,
        input_0 => input_0,
        output_26 => output_26,
        output_28 => output_28,
        output_30 => output_30,
        output_32 => output_32
    );

    process
    begin
        -- Testa todas as combinações da tabela verdade
        -- ATENÇÃO: Apenas as entradas são atribuídas. As saídas são apenas verificadas.

        -- Teste 1: input_2=0 input_0=0 output_26=1 output_28=0 output_30=0 output_32=0
        input_2 <= '0'; input_0 <= '0';
        wait for 10 ns;
        assert (output_26 = '1')
            report "Falha no teste 1: output_26 deveria ser 1 mas foi " & std_logic'image(output_26)
            severity error;
        assert (output_28 = '0')
            report "Falha no teste 1: output_28 deveria ser 0 mas foi " & std_logic'image(output_28)
            severity error;
        assert (output_30 = '0')
            report "Falha no teste 1: output_30 deveria ser 0 mas foi " & std_logic'image(output_30)
            severity error;
        assert (output_32 = '0')
            report "Falha no teste 1: output_32 deveria ser 0 mas foi " & std_logic'image(output_32)
            severity error;

        -- Teste 2: input_2=0 input_0=1 output_26=0 output_28=1 output_30=0 output_32=0
        input_2 <= '0'; input_0 <= '1';
        wait for 10 ns;
        assert (output_26 = '0')
            report "Falha no teste 2: output_26 deveria ser 0 mas foi " & std_logic'image(output_26)
            severity error;
        assert (output_28 = '1')
            report "Falha no teste 2: output_28 deveria ser 1 mas foi " & std_logic'image(output_28)
            severity error;
        assert (output_30 = '0')
            report "Falha no teste 2: output_30 deveria ser 0 mas foi " & std_logic'image(output_30)
            severity error;
        assert (output_32 = '0')
            report "Falha no teste 2: output_32 deveria ser 0 mas foi " & std_logic'image(output_32)
            severity error;

        -- Teste 3: input_2=1 input_0=0 output_26=0 output_28=0 output_30=1 output_32=0
        input_2 <= '1'; input_0 <= '0';
        wait for 10 ns;
        assert (output_26 = '0')
            report "Falha no teste 3: output_26 deveria ser 0 mas foi " & std_logic'image(output_26)
            severity error;
        assert (output_28 = '0')
            report "Falha no teste 3: output_28 deveria ser 0 mas foi " & std_logic'image(output_28)
            severity error;
        assert (output_30 = '1')
            report "Falha no teste 3: output_30 deveria ser 1 mas foi " & std_logic'image(output_30)
            severity error;
        assert (output_32 = '0')
            report "Falha no teste 3: output_32 deveria ser 0 mas foi " & std_logic'image(output_32)
            severity error;

        -- Teste 4: input_2=1 input_0=1 output_26=0 output_28=0 output_30=0 output_32=1
        input_2 <= '1'; input_0 <= '1';
        wait for 10 ns;  -- Último teste, espera antes de verificar
        assert (output_26 = '0')
            report "Falha no teste 4: output_26 deveria ser 0 mas foi " & std_logic'image(output_26)
            severity error;
        assert (output_28 = '0')
            report "Falha no teste 4: output_28 deveria ser 0 mas foi " & std_logic'image(output_28)
            severity error;
        assert (output_30 = '0')
            report "Falha no teste 4: output_30 deveria ser 0 mas foi " & std_logic'image(output_30)
            severity error;
        assert (output_32 = '1')
            report "Falha no teste 4: output_32 deveria ser 1 mas foi " & std_logic'image(output_32)
            severity error;

        report "Todos os testes passaram!";
        std.env.finish;
    end process;

end sim;