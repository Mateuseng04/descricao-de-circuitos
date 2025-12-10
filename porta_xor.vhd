library ieee;
use ieee.std_logic_1164.all;

entity porta_xor is
    port (a, b: in std_logic_vector (3 downto 0);
          y: out std_logic_vector (3 downto 0)
         );
end porta_xor;

architecture comportamento of porta_xor is
begin
    process (a, b)
    begin
        y <= a xor b;
    end process;
end comportamento;