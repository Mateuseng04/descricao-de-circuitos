library ieee;
use ieee.std_logic_1164.all;

entity oscilador is
    port (
        clk : out std_logic
    );
end entity oscilador;

architecture comportamento of oscilador is
begin
    process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
end architecture comportamento;