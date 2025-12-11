library ieee;
use ieee.std_logic_1164.all;

entity somador4bits is
    port (a, b: in std_logic_vector (3 downto 0);
          cin: in std_logic;
          soma: out std_logic_vector (3 downto 0);
          cout: out std_logic
         );
end somador4bits;

architecture comportamento of somador4bits is
    component somador_completo
        port (a, b, cin: in std_logic;
              soma, cout: out std_logic
             );
    end component;
    signal cout1, cout2, cout3: std_logic;
begin
    Unidade1: somador_completo
        port map (a(0), b(0), cin, soma(0), cout1);
    Unidade2: somador_completo
        port map (a(1), b(1), cout1, soma(1), cout2);
    Unidade3: somador_completo
        port map (a(2), b(2), cout2, soma(2), cout3);
    Unidade4: somador_completo
        port map (a(3), b(3), cout3, soma(3), cout);
end comportamento;
