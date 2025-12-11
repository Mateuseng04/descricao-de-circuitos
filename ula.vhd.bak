library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ula is
  generic (
    n : integer := 3
  );
  port (
    a, b, c, d, e, f, g, h      : in unsigned(3 downto 0);      -- Entradas de 4 bits
    cin          : in UNSIGNED(1 downto 0);            -- Carry-in para operações aritméticas
    op           : in std_logic_vector(2 downto 0);  -- Seleção da operação
    resultado    : out UNSIGNED(3 downto 0);          -- Resultado da operação
    saida_logica : out std_logic_vector(3 downto 0);  -- Resultado das operações lógicas
    cout         : out std_logic;            -- Carry-out para operações aritméticas
    display  : out std_logic_vector(6 downto 0);  -- Saída para display de 7 segmentos
    sel1, sel2, sel3 : in std_logic_vector (1 downto 0);
    soma : in std_logic_vector (3 downto 0);
    porta_xor_result, porta_and_result : in std_logic_vector (3 downto 0);
    entrada : in std_logic_vector(3 downto 0);
    saida : out std_logic_vector(6 downto 0);
    dezena, unidade : std_logic_vector(3 downto 0)
  );
end entity ula;

architecture comportamento of ula is
  signal a_temp, b_temp, c_temp, d_temp,resultado_temp : unsigned(4 downto 0);
  component porta_xor
    port (a, b: in std_logic_vector (3 downto 0);
          y: out std_logic_vector (3 downto 0)
         );
  end component;
  component porta_and
    port (a, b: in std_logic_vector (3 downto 0);
          y: out std_logic_vector (3 downto 0)
         );
  end component;
  component somador4bits
    port (a, b: in std_logic_vector (3 downto 0);
          cin: in std_logic;
          soma: out std_logic_vector (3 downto 0);
          cout: out std_logic
         );
  end component;
  component subtrator4bits
    port (a, b: in std_logic_vector (3 downto 0);
          resultado_subtracao: out std_logic_vector (3 downto 0);
          borrow: out std_logic
         );
  end component;
  component multiplicador4bits
    port (
        a, b : in unsigned(3 downto 0);  -- Entradas de 4 bits
        produto : out unsigned(7 downto 0) -- Produto de 8 bits
    );
  end component;
  signal resultado_soma, resultado_subtracao : std_logic_vector(3 downto 0);
  signal borrow : std_logic;
  signal produto : unsigned(7 downto 0);

  component mux
    port (a, b, c, d, f , e, g, h: in bit_vector;
            sel1, sel2, sel3: in std_logic_vector (1 downto 0);
            dout: out bit_vector
         );
  end component;
  component display7seg
    port (entrada: in std_logic_vector(3 downto 0);
          saida: out std_logic_vector(6 downto 0)
         );
  end component;

begin

ula: process(a_temp, b_temp, c_temp, d_temp, cin, op, sel1, sel2, sel3)
  begin
    case (sel1 & sel2 & sel3) is
        when "001" =>  -- Operação de soma
            resultado <= unsigned(soma);
            cout <= '0';
        when "010" =>  -- Operação de subtração
            resultado <= unsigned(resultado_subtracao);
            cout <= '0';
        when "011" =>  -- Operação de AND
            saida_logica <= porta_and_result;
            cout <= '0';
        when "100" =>  -- Operação de XOR
            saida_logica <= porta_xor_result;
            cout <= '0';
        when "101" =>  -- Operação de multiplicação
            resultado <= produto(7 downto 0);  -- Considerando apenas os 4 bits menos significativos
            cout <= '0';
        when "1011" =>  -- Operação de exibição no display
            resultado <= unsigned(entrada);
            cout <= '0';
        when others =>
            resultado <= (others => '0');
            cout <= '0';
    end case;
end process ula;


display_out: process (resultado) is
    variable display_out_var : std_logic_vector(6 downto 0);
begin
    case resultado is
        when "0000" => display_out_var := "0000001"; -- 0
        when "0001" => display_out_var := "1001111"; -- 1
        when "0010" => display_out_var := "0010010"; -- 2
        when "0011" => display_out_var := "0000110"; -- 3
        when "0100" => display_out_var := "1001100"; -- 4
        when "0101" => display_out_var := "0100100"; -- 5
        when "0110" => display_out_var := "0100000"; -- 6
        when "0111" => display_out_var := "0001111"; -- 7
        when "1000" => display_out_var := "0000000"; -- 8
        when "1001" => display_out_var := "0000100"; -- 9
        when others => display_out_var := "1111111"; -- off
    end case;
    display <= display_out_var;
    saida <= display_out_var;
end process display_out;

end architecture comportamento;
