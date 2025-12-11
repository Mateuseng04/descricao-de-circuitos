library ieee;
use ieee.std_logic_1164.all;

entity mux is
    port (a, b, c, d, e, f, g , h: in bit_vector;
            sel1, sel2, sel3: in std_logic_vector (1 downto 0);
            dout: out bit_vector
         );
end mux;

architecture comportamento of mux is
begin
    with (sel1 & sel2 & sel3) select
        dout <= a when "000",
                b when "001",
                c when "010",
                d when "011",
                e when "100",
                f when "101",
                a when others;
end comportamento;