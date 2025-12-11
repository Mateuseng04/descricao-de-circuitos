library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fsm is
  port (
    clk   : in std_logic;
    reset : in std_logic;
    start : in std_logic;
    done  : out std_logic;
    a, b, c, d, e, f, g, h            : in unsigned(3 downto 0); -- Entradas de 4 bits
    cin                                : in UNSIGNED(1 downto 0); -- Carry-in para operações aritméticas
      op                                 : in std_logic_vector(2 downto 0); -- Seleção da operação
      resultado                          : out UNSIGNED(3 downto 0); -- Resultado da operação
      saida_logica                       : out std_logic_vector(3 downto 0); -- Resultado das operações lógicas
      cout                               : out std_logic; -- Carry-out para operações aritméticas
      display                            : out std_logic_vector(6 downto 0); -- Saída para display de 7 segmentos
      sel1, sel2, sel3                   : in std_logic_vector (1 downto 0);
      soma                               : in std_logic_vector (3 downto 0);
      porta_xor_result, porta_and_result : in std_logic_vector (3 downto 0);
      entrada                            : in std_logic_vector(3 downto 0);
      saida                              : out std_logic_vector(6 downto 0);
      dezena, unidade                    : std_logic_vector(3 downto 0)

  );
end entity fsm;

architecture rtl of fsm is
  component bloco_de_controle
    port (
      clk   : in std_logic;
      reset : in std_logic;
      start : in std_logic;
      done  : out std_logic
      
    );
  end component;
  component ula
    port (
      a, b, c, d, e, f, g, h             : in unsigned(3 downto 0); -- Entradas de 4 bits
      cin                                : in UNSIGNED(1 downto 0); -- Carry-in para operações aritméticas
      op                                 : in std_logic_vector(2 downto 0); -- Seleção da operação
      resultado                          : out UNSIGNED(3 downto 0); -- Resultado da operação
      saida_logica                       : out std_logic_vector(3 downto 0); -- Resultado das operações lógicas
      cout                               : out std_logic; -- Carry-out para operações aritméticas
      display                            : out std_logic_vector(6 downto 0); -- Saída para display de 7 segmentos
      sel1, sel2, sel3                   : in std_logic_vector (1 downto 0);
      soma                               : in std_logic_vector (3 downto 0);
      porta_xor_result, porta_and_result : in std_logic_vector (3 downto 0);
      entrada                            : in std_logic_vector(3 downto 0);
      saida                              : out std_logic_vector(6 downto 0);
      dezena, unidade                    : std_logic_vector(3 downto 0)
    );
  end component;
  type state_type is (inicial, espera, somatorio, subtracao, and_op, xor_op, multiplicacao, final);
  signal estado_atual, proximo_estado : state_type;
  -- Processo de transicao de estados
begin
  controle : bloco_de_controle
  port map
  (
    clk   => clk,
    reset => reset,
    start => start,
    done  => done
  );
  bloco_de_operacoes : ula
  port map
  (
    a => a,
    b => b,
    c => c,
    d => d,
    e => e,
    f => f,
    g => g,
    h => h,
    cin => "00",
    op => "000",
    resultado => open,
    saida_logica => open,
    cout => open,
    display => open,
    sel1 => "00",
    sel2 => "00",
    sel3 => "00",
    soma => soma,
    porta_xor_result => porta_xor_result,
    porta_and_result => porta_and_result,
    entrada => entrada,
    dezena => dezena,
    unidade => unidade
    );
    inicializacao: process(reset)
    begin
    if reset = '1' then
      estado_atual <= inicial;
    end if;
    end process inicializacao; 

end architecture rtl;
