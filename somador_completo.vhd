library ieee;
use ieee.std_logic_1164.all;

entity somador_completo is 
    port (a, b, cin: in std_logic;
          s, cout  : out std_logic);

end somador_completo;

architecture funcionamento of somador_completo is
    begin
        process (a, b, cin)
        begin
            s <= (a xor b) xor cin;
            cout <= (a and b) or (cin and (a xor b));
        end process;
end funcionamento;