/*

*/

entity and_gate_tb is
end and_gate_tb;

architecture sim of and_gate_tb is
    signal a, b, y : std_logic;

    -- Tabela verdade como array
    type test_vector is record
        a, b, expected : std_logic;
    end record;

    type test_array is array (natural range <>) of test_vector;
    constant tests : test_array := (
        (a => '0', b => '0', expected => '0'),
        (a => '0', b => '1', expected => '0'),
        (a => '1', b => '0', expected => '0'),
        (a => '1', b => '1', expected => '1')
    );
begin
    UUT: entity work.and_gate port map (a => a, b => b, y => y);

    process
    begin
        for i in tests'range loop
            -- Aplica estímulo
            a <= tests(i).a;
            b <= tests(i).b;
            wait for 10 ns;

            -- Verifica resultado
            assert (y = tests(i).expected)
                report "Falha no teste " & integer'image(i) &
                       ": " & std_logic'image(a) &
                       " AND " & std_logic'image(b) &
                       " deveria ser " & std_logic'image(tests(i).expected) &
                       " mas foi " & std_logic'image(y)
                severity error;
        end loop;

        report "Todos os " & integer'image(tests'length) & " testes passaram!";
        std.env.finish;
    end process;
end sim;
