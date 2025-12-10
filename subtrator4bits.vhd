library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtrator4bits is
    port (a, b: in std_logic_vector (3 downto 0);
          resultado: out std_logic_vector (3 downto 0);
          borrow: out std_logic
         );
end subtrator4bits;

architecture comportamento of subtrator4bits is
    begin
        resultado <= std_logic_vector(signed('0' &a) - signed('0' &b));
        borrow <= '1' when unsigned(a) < unsigned(b) else '0';
end comportamento;