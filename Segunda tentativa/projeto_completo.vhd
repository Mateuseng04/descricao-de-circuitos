library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity projeto_completo is
    Port (
        -- Entradas dos DIP switches
        dip_A : in STD_LOGIC_VECTOR (3 downto 0);
        dip_B : in STD_LOGIC_VECTOR (3 downto 0);
        dip_Cin : in STD_LOGIC;
       
        -- Saídas para LEDs (resultado da soma)
        led_S : out STD_LOGIC_VECTOR (3 downto 0);
        led_Co : out STD_LOGIC;
       
        -- Saída para display de 7 segmentos
        display_7seg : out STD_LOGIC_VECTOR (6 downto 0)
    );
end projeto_completo;

architecture Behavioral of projeto_completo is
    signal soma_result : STD_LOGIC_VECTOR (3 downto 0);
    signal carry_out : STD_LOGIC;
   
    component somador_completo
        Port (
            A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            Cin : in STD_LOGIC;
            S : out STD_LOGIC_VECTOR (3 downto 0);
            Co : out STD_LOGIC
        );
    end component;
   
    component decoder_bcd_7seg
        Port (
            bcd_input : in STD_LOGIC_VECTOR (3 downto 0);
            seg_output : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
   
begin
    -- Instancia o somador de 4 bits
    U1: somador_completo
        port map (
            A => dip_A,
            B => dip_B,
            Cin => dip_Cin,
            S => soma_result,
            Co => carry_out
        );
   
    -- Instancia o decodificador para display de 7 segmentos
    U2: decoder_bcd_7seg
        port map (
            bcd_input => soma_result,
            seg_output => display_7seg
        );
   
    -- Conecta as saídas aos LEDs
    led_S <= soma_result;
    led_Co <= carry_out;
   
end Behavioral;