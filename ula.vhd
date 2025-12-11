library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
  port (
    a, b  : in unsigned(3 downto 0);
    cin   : in std_logic;

    sel1, sel2, sel3 : in std_logic_vector(1 downto 0);

    resultado    : out unsigned(4 downto 0);
    saida_logica : out std_logic_vector(3 downto 0);
    cout         : out std_logic;

    display      : out std_logic_vector(6 downto 0)
  );
end entity ula;


architecture estrutural of ula is

  --------------------------------------------------------------------
  -- DECLARAÇÃO DOS COMPONENTES EXTERNOS
  --------------------------------------------------------------------

  component somador4bits is
    port (
      a, b   : in unsigned(3 downto 0);
      cin    : in std_logic;
      soma   : out unsigned(3 downto 0);
      cout   : out std_logic
    );
  end component;

  component subtrator4bits is
    port (
      x, y        : in unsigned(3 downto 0);
      resultado   : out unsigned(3 downto 0);
      borrow      : out std_logic
    );
  end component;

  component porta_and is
    port (
      a, b : in unsigned(3 downto 0);
      y    : out unsigned(3 downto 0)
    );
  end component;

  component porta_xor is
    port (
      a, b : in unsigned(3 downto 0);
      y    : out unsigned(3 downto 0)
    );
  end component;

  component multiplicador4bits is
    port (
      a, b    : in unsigned(3 downto 0);
      produto : out unsigned(7 downto 0)
    );
  end component;


  --------------------------------------------------------------------
  -- SINAIS INTERNOS
  --------------------------------------------------------------------

  signal soma_r     : unsigned(3 downto 0);
  signal soma_cout  : std_logic;

  signal sub_r      : unsigned(3 downto 0);
  signal sub_borrow : std_logic;

  signal and_r      : unsigned(3 downto 0);
  signal xor_r      : unsigned(3 downto 0);
  signal mult_r     : unsigned(7 downto 0);

  signal op_sel     : std_logic_vector(5 downto 0);

begin


  --------------------------------------------------------------------
  -- INSTÂNCIAS DOS MÓDULOS
  --------------------------------------------------------------------

  somador_inst : somador4bits
    port map(
      a      => a,
      b      => b,
      cin    => cin,
      soma   => soma_r,
      cout   => soma_cout
    );

  subtrator_inst : subtrator4bits
    port map(
      x        => a,
      y        => b,
      resultado => sub_r,
      borrow   => sub_borrow
    );

  and_inst : porta_and
    port map(
      a => a,
      b => b,
      y => and_r
    );

  xor_inst : porta_xor
    port map(
      a => a,
      b => b,
      y => xor_r
    );

  mult_inst : multiplicador4bits
    port map(
      a => a,
      b => b,
      produto => mult_r
    );


  --------------------------------------------------------------------
  -- SELETOR DE OPERAÇÕES
  --------------------------------------------------------------------
  op_sel <= sel1 & sel2 & sel3;  -- 6 bits (2+2+2)


  process(op_sel, soma_r, soma_cout, sub_r, and_r, xor_r, mult_r)
  begin
    resultado    <= (others => '0');
    saida_logica <= (others => '0');
    cout         <= '0';

    case op_sel is

      -- SOMA
      when "000001" =>
        resultado <= ('0' & soma_r);
        cout      <= soma_cout;

      -- SUBTRAÇÃO
      when "000010" =>
        resultado <= ('0' & sub_r);
        cout      <= sub_borrow;

      -- AND
      when "000011" =>
        saida_logica <= std_logic_vector(and_r);

      -- XOR
      when "000100" =>
        saida_logica <= std_logic_vector(xor_r);

      -- MULTIPLICAÇÃO (LSB)
      when "000101" =>
        resultado <= mult_r(4 downto 0);

      when others =>
        null;
    end case;
  end process;


  --------------------------------------------------------------------
  -- DISPLAY DE 7 SEGMENTOS
  --------------------------------------------------------------------
  process(resultado)
    variable r4 : std_logic_vector(3 downto 0);
  begin
    r4 := std_logic_vector(resultado(3 downto 0));

    case r4 is
      when "0000" => display <= "0000001"; --0
      when "0001" => display <= "1001111"; --1
      when "0010" => display <= "0010010"; --2
      when "0011" => display <= "0000110"; --3
      when "0100" => display <= "1001100"; --4
      when "0101" => display <= "0100100"; --5
      when "0110" => display <= "0100000"; --6
      when "0111" => display <= "0001111"; --7
      when "1000" => display <= "0000000"; --8
      when "1001" => display <= "0000100"; --9
      when others => display <= "1111111";
    end case;
  end process;

end architecture estrutural;
