library ieee;
use ieee.std_logic_1164.all;

entity mux is
    port (a, b, c, d: in bit_vector;
            sel: in std_logic_vector (1 downto 0);
            dout: out bit_vector
         );
end mux;

architecture comportamento of mux is
begin
    with sel select
        dout <= a when "00",
                b when "01",
                c when "10",
                d when "11";
end comportamento;