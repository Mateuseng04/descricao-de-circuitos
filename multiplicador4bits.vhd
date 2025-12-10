library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplicador4bits is
    port (
        a, b : in unsigned(3 downto 0);  -- Entradas de 4 bits
        produto : out unsigned(7 downto 0) -- Produto de 8 bits
    );
end multiplicador4bits;

architecture comportamento of multiplicador4bits is
    begin
        process(a, b)
        begin
            produto <= unsigned(a) * unsigned(b);
        end process;
end comportamento;