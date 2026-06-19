library ieee;
use ieee.std_logic_1164.all;

entity and_gate_tb is
end and_gate_tb;

architecture sim of and_gate_tb is
    signal a, b, y : std_logic;
begin
    -- Component instantiation
    UUT: entity work.and_gate port map (a => a, b => b, y => y);
    process
    begin
        -- Testing all combinations
        a <= '0'; b <= '0'; wait for 10 ns;
        a <= '0'; b <= '1'; wait for 10 ns;
        a <= '1'; b <= '0'; wait for 10 ns;
        a <= '1'; b <= '1'; wait for 10 ns;

        -- Forces GTKWave to display the last interval.
        a <= '0'; b <= '0'; wait for 10 ns;

        std.env.finish; -- VHDL-2008 feature to end the simulation
    end process;
end sim;
library ieee;
use ieee.std_logic_1164.all;
