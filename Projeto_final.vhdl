library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Projeto_final is
  port (
    clk         : in std_logic;
    reset       : in std_logic;
    start       : in std_logic; -- botão de confirmação
    numero      : in std_logic_vector(3 downto 0); -- entrada (DIP switches / botões)
    leds        : out std_logic_vector(7 downto 0); -- LEDs da placa
    seg_unid    : out std_logic_vector(6 downto 0); -- display unidades
    seg_dezenas : out std_logic_vector(6 downto 0) -- display dezenas
  );
end entity;

architecture comportamento of Projeto_final is

  -- sinais entre controle e ULA
  signal sel1_s, sel2_s, sel3_s : std_logic_vector(1 downto 0);
  signal A_s, B_s               : std_logic_vector(3 downto 0);
  signal op_s                   : std_logic_vector(2 downto 0);
  signal estado_dbg_s           : std_logic_vector(2 downto 0);
  signal done_s                 : std_logic;

  -- resultado da ULA
  signal resultado_s : unsigned(4 downto 0);

  -- sinais de display vindos da ULA
  signal seg_unid_s : std_logic_vector(6 downto 0);
  signal seg_dez_s  : std_logic_vector(6 downto 0);

begin

  -- INSTÂNCIA: BLOCO DE CONTROLE
  -- opcode é lido pelos switches (numero(2 downto 0)) na fase sel_op
  -- numero é a entrada que o usuário digita; o controle grava A_s e B_s
  controle_inst : entity work.bloco_de_controle
    port map
    (
      clk    => clk,
      reset  => reset,
      start  => start,
      opcode => numero(2 downto 0), -- usuário seleciona opcode via switches
      numero => numero, -- entrada para nascimento de A/B

      sel1 => sel1_s,
      sel2 => sel2_s,
      sel3 => sel3_s,

      A_reg  => A_s,
      B_reg  => B_s,
      op_reg => op_s,

      estado_dbg => estado_dbg_s,
      done       => done_s
    );
  -- INSTÂNCIA: ULA
  -- recebe A_s/B_s armazenados no controle e seletores gerados a partir de op_s
  ula_inst : entity work.ula
    port map
    (
      a   => unsigned(A_s),
      b   => unsigned(B_s),
      cin => '0',

      sel1 => sel1_s,
      sel2 => sel2_s,
      sel3 => sel3_s,

      resultado => resultado_s,
      cout      => open,

      disp_unid => seg_unid_s,
      disp_dez  => seg_dez_s
    );

  -- SAÍDA PARA O DISPLAY (liga saídas internas da ULA para as portas
  -- físicas do FPGA)
  
  seg_unid    <= seg_unid_s;
  seg_dezenas <= seg_dez_s;
  -- MAPEAMENTO DOS LEDS (multiplexagem simples por estado)
  --
  -- Estratégia:
  --  - Estado sel_op   : LEDs[3:0] mostram opcode escolhido (op_s)
  --  - Estado digita_A : LEDs[3:0] mostram A_s (valor sendo gravado)
  --  - Estado digita_B : LEDs[3:0] mostram B_s (valor sendo gravado)
  --  - Estado mostra   : LEDs[4:0] mostram resultado_s, LEDs[7] = done
  --  - Outros estados  : LEDs mostram estado_dbg (bits baixos)
  process (estado_dbg_s, A_s, B_s, op_s, resultado_s, done_s)
  begin
    -- default: zero
    leds <= (others => '0');

    case estado_dbg_s is
      when "000" => -- idle (ou outro código dependendo do seu bloco)
        leds(2 downto 0) <= estado_dbg_s; -- mostra o estado (baixo)
        leds(7)          <= '0';
      when "001" => -- sel_op
        leds(3 downto 0) <= "0" & op_s; -- op_s(2 downto 0) -> LEDs[2:0], deixei 4 bits
        leds(7)          <= '0';
      when "010" => -- digita_A
        leds(3 downto 0) <= A_s;
        leds(7)          <= '0';
      when "011" => -- digita_B
        leds(3 downto 0) <= B_s;
        leds(7)          <= '0';
      when "100" => -- executa
        -- indicar que ULA está processando: acenda LED6 por exemplo
        leds(6) <= '1';
        leds(7) <= '0';
      when "101" => -- mostra (resultado)
        -- resultado_s tem 5 bits; mostramos nos LEDs 4:0
        leds(4 downto 0) <= std_logic_vector(resultado_s);
        leds(7)          <= done_s;
      when "110" => -- resetando (ou outro, caso exista)
        leds <= "10000000"; -- só exemplo: LED7 aceso
      when others =>
        leds(2 downto 0) <= estado_dbg_s;
        leds(7)          <= done_s;
    end case;
  end process;

end architecture comportamento;
