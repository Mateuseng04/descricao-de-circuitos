library ieee;
use ieee.std_logic_1164.all;

entity registrador4bits is
    port (I: in std_logic_vector (3 downto 0);
          clk: in std_logic;
          Q: out std_logic_vector (3 downto 0)
         );
end registrador4bits;


architecture comportamento of registrador4bits is
    begin
        process (clk)
        begin
            if rising_edge(clk) then
                Q <= I;
            end if;
        end process;
end comportamento;