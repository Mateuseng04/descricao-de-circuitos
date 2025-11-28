library ieee;
use ieee.std_logic_1164.all;

entity Reg16 is
  port (
    clk : in std_logic;
    d   : in std_logic_vector(15 downto 0);
    q   : out std_logic_vector(15 downto 0));
end Reg16;

architecture Behavioral of Reg16 is
begin
  process (clk)
  begin
    if rising_edge(clk) then
      q <= d;
    end if;
  end process;
end Behavioral;