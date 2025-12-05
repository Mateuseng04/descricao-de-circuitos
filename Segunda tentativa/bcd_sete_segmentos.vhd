library ieee;
use ieee.std_logic_1164.all; -- Declaração da biblioteca padrão de lógica

entity decoder_bcd_7seg is
    port (
        bcd: in std_logic_vector(3 downto 0);  -- Entrada BCD de 4 bits
        seg: out std_logic_vector(6 downto 0)   -- Saída para os segmentos do display de 7 segmentos
    );
end entity decoder_bcd_7seg;

architecture Behavioral of decoder_bcd_7seg is
begin
    process(bcd)
    begin
        case bcd is
            when "0000" => seg <= "0000001"; -- 0
            when "0001" => seg <= "1001111"; -- 1
            when "0010" => seg <= "0010010"; -- 2
            when "0011" => seg <= "0000110"; -- 3
            when "0100" => seg <= "1001100"; -- 4
            when "0101" => seg <= "0100100"; -- 5
            when "0110" => seg <= "0100000"; -- 6
            when "0111" => seg <= "0001111"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0000100"; -- 9
            when others => seg <= "1111111"; -- Apagado para outros valores
        end case;
    end process;
end Behavioral;