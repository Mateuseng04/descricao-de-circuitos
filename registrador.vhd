library ieee;
use ieee.std_logic_1164.all;

entity Reg4 is
    port (clk: in std_logic;
          d: in std_logic_vector(3 downto 0);
          q: out std_logic_vector(3 downto 0));
end Reg4;

architecture Behavioral of Reg4 is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            q <= d;
        end if;
    end process;
end Behavioral;