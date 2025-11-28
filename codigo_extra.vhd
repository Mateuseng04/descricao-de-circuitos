-- Somador de 4 bits com Decodificação para 2 Displays de 7 Segmentos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Usado para conversão para números (unsigned)

entity top_display_adder is
    Port (
        A_in         : in  STD_LOGIC_VECTOR (3 downto 0); -- 1a Entrada (4 bits)
        B_in         : in  STD_LOGIC_VECTOR (3 downto 0); -- 2a Entrada (4 bits)
        Cin_in       : in  STD_LOGIC;                     -- Carry In (Geralmente 0)

        -- Saídas para os 2 displays (Unidade e Dezena)
        -- DEZ_OUT: Saída para o display da Dezena
        -- UNI_OUT: Saída para o display da Unidade
        DEZ_OUT      : out STD_LOGIC_VECTOR (6 downto 0);
        UNI_OUT      : out STD_LOGIC_VECTOR (6 downto 0);
        
        -- Saída do Carry Out do somador de 4 bits
        Co_out       : out STD_LOGIC
    );
end entity top_display_adder;

architecture Structural of top_display_adder is
    
    -- Componente 1: Somador de 4 bits
    component ripple_carry_adder_4bit
        Port (
            A    : in  STD_LOGIC_VECTOR (3 downto 0);
            B    : in  STD_LOGIC_VECTOR (3 downto 0);
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC_VECTOR (3 downto 0);
            Co   : out STD_LOGIC
        );
    end component;
    
    -- Componente 2: Decodificador BCD para 7 Segmentos (Cátodo Comum)
    component seven_segment_decoder_cc
        Port (
            bcd_input      : in  STD_LOGIC_VECTOR (3 downto 0);
            segment_output : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    -- Sinais internos para conectar os componentes
    signal S_sum    : STD_LOGIC_VECTOR (3 downto 0); -- Saída S do Somador
    signal Co_carry : STD_LOGIC;                     -- Saída Co do Somador
    
    -- Sinais para a conversão Decimal
    signal total_sum_unsigned : unsigned(4 downto 0); -- Soma de 5 bits (S_sum + Co)
    signal S_dezena_bcd       : STD_LOGIC_VECTOR (3 downto 0); -- BCD da Dezena
    signal S_unidade_bcd      : STD_LOGIC_VECTOR (3 downto 0); -- BCD da Unidade

begin
    -- Conexão direta do Carry Out para a porta de saída
    Co_out <= Co_carry;
    
    -- 1. INSTANCIAÇÃO DO SOMADOR DE 4 BITS
    U_ADDER_4BIT : ripple_carry_adder_4bit
        port map (
            A    => A_in,
            B    => B_in,
            Cin  => Cin_in,
            S    => S_sum,
            Co   => Co_carry
        );

    -- 2. LÓGICA DE EXTRAÇÃO DE DEZENA E UNIDADE
    
    -- Converte o resultado de 5 bits para unsigned para fazer a operação de divisão/resto
    total_sum_unsigned <= unsigned(Co_carry & S_sum);
    
    -- Processo para calcular a Dezena e a Unidade
    -- A soma pode ir de 0 (0+0) a 31 (15+15+1)
    
    -- Unidade = Resto da divisão por 10 (total_sum mod 10)
    -- A operação "mod" é uma função matemática. 
    -- Para VHDL, fazemos a conversão para inteiro e depois para BCD.
    
    -- Converte para BCD (4 bits)
    S_unidade_bcd <= STD_LOGIC_VECTOR(to_unsigned(total_sum_unsigned mod 10, 4));
    
    -- Dezena = Divisão inteira por 10 (total_sum / 10)
    -- Converte para BCD (4 bits)
    S_dezena_bcd <= STD_LOGIC_VECTOR(to_unsigned(total_sum_unsigned / 10, 4));
    
    -- 3. INSTANCIAÇÃO DOS DECODIFICADORES DE 7 SEGMENTOS
    
    -- Decodificador da UNIDADE
    U_DECODER_UNI : seven_segment_decoder_cc
        port map (
            bcd_input      => S_unidade_bcd,
            segment_output => UNI_OUT
        );
        
    -- Decodificador da DEZENA
    U_DECODER_DEZ : seven_segment_decoder_cc
        port map (
            bcd_input      => S_dezena_bcd,
            segment_output => DEZ_OUT
        );

end architecture Structural;