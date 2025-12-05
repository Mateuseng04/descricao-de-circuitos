-- Módulo 2: Conversor Binário (8-bits) para BCD (3 dígitos)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCD_Converter is
    port (
        D_in  : in  std_logic_vector(7 downto 0); -- Valor acumulado (8 bits)
        C_out : out std_logic_vector(3 downto 0); -- Centena (0 a 2)
        H_out : out std_logic_vector(3 downto 0); -- Dezena
        U_out : out std_logic_vector(3 downto 0)  -- Unidade
    );
end entity BCD_Converter;

architecture Behavioral of BCD_Converter is
    -- O valor máximo é 255, então 3 BCDs (Centena, Dezena, Unidade) são suficientes.
    -- O BCD_Register armazena os 3 dígitos BCD (3 * 4 = 12 bits) e o valor de entrada (8 bits)
    signal BCD_Register : std_logic_vector(11 downto 0) := (others => '0');
    signal Data_Register : std_logic_vector(7 downto 0) := (others => '0');

    -- Função auxiliar para o algoritmo "shift and add 3"
    function add_three (bcd_digit : std_logic_vector(3 downto 0)) return std_logic_vector is
    begin
        if unsigned(bcd_digit) > 4 then
            return std_logic_vector(unsigned(bcd_digit) + 3);
        else
            return bcd_digit;
        end if;
    end function add_three;

begin

    process (D_in)
    begin
        -- Inicializa os registradores com o valor de entrada
        BCD_Register <= (others => '0');
        Data_Register <= D_in;

        -- Oito iterações do algoritmo "Double Dabble"
        for i in 0 to 7 loop
            
            -- Adiciona 3 aos dígitos BCD se o valor for maior que 4
            BCD_Register(3 downto 0)   <= add_three(BCD_Register(3 downto 0));   -- Unidade
            BCD_Register(7 downto 4)   <= add_three(BCD_Register(7 downto 4));   -- Dezena
            BCD_Register(11 downto 8)  <= add_three(BCD_Register(11 downto 8));  -- Centena
            
            -- Realiza o SHIFT (desloca BCD_Register e Data_Register como um único registrador)
            BCD_Register(11 downto 1) <= BCD_Register(10 downto 0);
            BCD_Register(0) <= Data_Register(7);
            Data_Register(7 downto 1) <= Data_Register(6 downto 0);

        end loop;
        
        -- Atribui as saídas
        C_out <= BCD_Register(11 downto 8); -- Centena
        H_out <= BCD_Register(7 downto 4);  -- Dezena
        U_out <= BCD_Register(3 downto 0);  -- Unidade
    end process;
end architecture Behavioral;