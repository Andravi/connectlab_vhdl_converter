-- Testbench gerado automaticamente a partir de tabela verdade
-- Arquivo CSV: uploads/tabela_verdade_base.csv

library ieee;
use ieee.std_logic_1164.all;

entity flipflop_SR_tb is
end flipflop_SR_tb;

architecture sim of flipflop_SR_tb is
    signal input_84 : std_logic;
    signal input_82 : std_logic;
    signal input_86 : std_logic;
    signal output_0 : std_logic;
    signal output_2 : std_logic;
begin

    -- Instancia o componente
    UUT: entity work.flipflop_SR port map (
        input_84 => input_84,
        input_82 => input_82,
        input_86 => input_86,
        output_0 => output_0,
        output_2 => output_2
    );

    process
    begin
        -- Testa todas as combinações da tabela verdade
        -- ATENÇÃO: Apenas as entradas são atribuídas. As saídas são apenas verificadas.

        -- Teste 1: input_84=0 input_82=0 input_86=0 output_0=U output_2=U
        input_84 <= '0'; input_82 <= '0'; input_86 <= '0';
        wait for 10 ns;
        assert (output_0 = 'U')
            report "Falha no teste 1: output_0 deveria ser U mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = 'U')
            report "Falha no teste 1: output_2 deveria ser U mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 2: input_84=0 input_82=0 input_86=1 output_0=U output_2=U
        input_84 <= '0'; input_82 <= '0'; input_86 <= '1';
        wait for 10 ns;
        assert (output_0 = 'U')
            report "Falha no teste 2: output_0 deveria ser U mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = 'U')
            report "Falha no teste 2: output_2 deveria ser U mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 3: input_84=0 input_82=1 input_86=0 output_0=U output_2=U
        input_84 <= '0'; input_82 <= '1'; input_86 <= '0';
        wait for 10 ns;
        assert (output_0 = 'U')
            report "Falha no teste 3: output_0 deveria ser U mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = 'U')
            report "Falha no teste 3: output_2 deveria ser U mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 4: input_84=0 input_82=1 input_86=1 output_0=U output_2=U
        input_84 <= '0'; input_82 <= '1'; input_86 <= '1';
        wait for 10 ns;
        assert (output_0 = 'U')
            report "Falha no teste 4: output_0 deveria ser U mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = 'U')
            report "Falha no teste 4: output_2 deveria ser U mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 5: input_84=1 input_82=0 input_86=0 output_0=U output_2=U
        input_84 <= '1'; input_82 <= '0'; input_86 <= '0';
        wait for 10 ns;
        assert (output_0 = 'U')
            report "Falha no teste 5: output_0 deveria ser U mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = 'U')
            report "Falha no teste 5: output_2 deveria ser U mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 6: input_84=1 input_82=0 input_86=1 output_0=0 output_2=1
        input_84 <= '1'; input_82 <= '0'; input_86 <= '1';
        wait for 10 ns;
        assert (output_0 = '0')
            report "Falha no teste 6: output_0 deveria ser 0 mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = '1')
            report "Falha no teste 6: output_2 deveria ser 1 mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 7: input_84=1 input_82=0 input_86=0 output_0=0 output_2=1
        input_84 <= '1'; input_82 <= '0'; input_86 <= '0';
        wait for 10 ns;
        assert (output_0 = '0')
            report "Falha no teste 7: output_0 deveria ser 0 mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = '1')
            report "Falha no teste 7: output_2 deveria ser 1 mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 8: input_84=1 input_82=1 input_86=0 output_0=1 output_2=0
        input_84 <= '1'; input_82 <= '1'; input_86 <= '0';
        wait for 10 ns;
        assert (output_0 = '1')
            report "Falha no teste 8: output_0 deveria ser 1 mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = '0')
            report "Falha no teste 8: output_2 deveria ser 0 mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 9: input_84=1 input_82=0 input_86=0 output_0=1 output_2=0
        input_84 <= '1'; input_82 <= '0'; input_86 <= '0';
        wait for 10 ns;
        assert (output_0 = '1')
            report "Falha no teste 9: output_0 deveria ser 1 mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = '0')
            report "Falha no teste 9: output_2 deveria ser 0 mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 10: input_84=1 input_82=0 input_86=1 output_0=0 output_2=1
        input_84 <= '1'; input_82 <= '0'; input_86 <= '1';
        wait for 10 ns;
        assert (output_0 = '0')
            report "Falha no teste 10: output_0 deveria ser 0 mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = '1')
            report "Falha no teste 10: output_2 deveria ser 1 mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 11: input_84=1 input_82=0 input_86=0 output_0=0 output_2=1
        input_84 <= '1'; input_82 <= '0'; input_86 <= '0';
        wait for 10 ns;
        assert (output_0 = '0')
            report "Falha no teste 11: output_0 deveria ser 0 mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = '1')
            report "Falha no teste 11: output_2 deveria ser 1 mas foi " & std_logic'image(output_2)
            severity error;

        -- Teste 12: input_84=1 input_82=1 input_86=1 output_0=0 output_2=0
        input_84 <= '1'; input_82 <= '1'; input_86 <= '1';
        wait for 10 ns;  -- Último teste, espera antes de verificar
        assert (output_0 = '0')
            report "Falha no teste 12: output_0 deveria ser 0 mas foi " & std_logic'image(output_0)
            severity error;
        assert (output_2 = '0')
            report "Falha no teste 12: output_2 deveria ser 0 mas foi " & std_logic'image(output_2)
            severity error;

        report "Todos os testes passaram!";
        std.env.finish;
    end process;

end sim;