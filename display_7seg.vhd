library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity display_7seg is
    port (
        num : in  std_logic_vector(3 downto 0);           -- Entrada de 4 bits
        seg_unid : out std_logic_vector(6 downto 0);      -- Saída das unidades
        seg_dezenas : out STD_LOGIC_VECTOR (6 downto 0)
    );
end entity display_7seg;

architecture comportamento of display_7seg is
    signal valor : integer range 0 to 15;
    signal unidade : integer range 0 to 9;
    signal dezena : integer range 0 to 1;
    
begin

    valor <= to_integer(unsigned(num));
    
dezena <= 1 when valor >= 10 else 0;
unidade <= valor - 10 when valor >= 10 else valor;


with unidade select 
        seg_unid <=
            "0000001" when 0,
            "1001111" when 1,
            "0010010" when 2,
            "0000110" when 3,
            "1001100" when 4,
            "0100100" when 5,
            "0100000" when 6,
            "0001111" when 7,
            "0000000" when 8,
            "0000100" when 9,
            "1111111" when others;

    with dezena select
        seg_dezenas <=
            "0000001" when 0,  -- mostra 0 quando < 10 (pode ser apagado se quiser)
            "1001111" when 1,  -- mostra 1
            "1111111" when others; -- apagado
end architecture comportamento;