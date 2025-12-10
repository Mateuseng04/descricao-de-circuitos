library ieee;
use ieee.std_logic_1164.all;

entity porta_nand is
    port (
        a, b : in STD_LOGIC_VECTOR (3 downto 0);
        y : out std_logic_vector (3 downto 0)
    );
end entity porta_nand;

architecture comportamento of porta_nand is
begin
    y <= not (a and b);
end architecture comportamento;
