library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
  port (
    a, b  : in unsigned(3 downto 0);
    cin   : in std_logic;

    sel1, sel2, sel3 : in std_logic_vector(1 downto 0);

    resultado : out unsigned(4 downto 0);
    cout      : out std_logic;
    y         : out STD_LOGIC_VECTOR (4 downto 0);

    -- LEDs de entrada e lógicas
    led_a        : out std_logic_vector(3 downto 0);
    led_b        : out std_logic_vector(3 downto 0);
    led_logica   : out std_logic_vector(3 downto 0);

    -- Display 7 segmentos (unidades + dezenas)
    disp_unid    : out std_logic_vector(6 downto 0);
    disp_dez     : out std_logic_vector(6 downto 0)
  );
end entity ula;

architecture estrutural of ula is

  
  -- COMPONENTES
  
  component somador4bits is
    port(a,b: in unsigned(3 downto 0); cin: in std_logic;
         soma: out unsigned(3 downto 0); cout: out std_logic);
  end component;

  component subtrator4bits is
    port(a,b: in unsigned(3 downto 0);
         resultado: out unsigned(3 downto 0); borrow: out std_logic);
  end component;

  component porta_nand is
    port(a,b: in unsigned(3 downto 0); y: out unsigned(3 downto 0));
  end component;

  component porta_xor is
    port(a,b: in unsigned(3 downto 0); y: out unsigned(3 downto 0));
  end component;

  component multiplicador4bits is
    port(a,b: in unsigned(3 downto 0); produto: out unsigned(7 downto 0));
  end component;

  component display_7seg is
        port (
            num       : in  std_logic_vector(3 downto 0);
            seg_unid  : out std_logic_vector(6 downto 0);
            seg_dez   : out std_logic_vector(6 downto 0)
        );
  end component;

  
  -- SINAIS INTERNOS
  
  signal soma_r     : unsigned(3 downto 0);
  signal soma_cout  : std_logic;

  signal sub_r      : unsigned(3 downto 0);
  signal sub_borrow : std_logic;

  signal nand_r     : unsigned(3 downto 0);
  signal xor_r      : unsigned(3 downto 0);
  signal mult_r     : unsigned(7 downto 0);

  signal resultado_s : unsigned(4 downto 0);

  signal op_sel : std_logic_vector(5 downto 0);

begin

  
  -- Mostrar os números de entrada nos LEDs
  
  led_a <= std_logic_vector(a);
  led_b <= std_logic_vector(b);

  resultado <= resultado_s;

  
  -- Instâncias
  
  somador_inst : somador4bits
    port map(a => a, b => b, cin => cin, soma => soma_r, cout => soma_cout);

  subtrator_inst : subtrator4bits
    port map(a => a, b => b, resultado => sub_r, borrow => sub_borrow);

  nand_inst : porta_nand port map(a => a, b => b, y => nand_r);
  xor_inst  : porta_xor  port map(a => a, b => b, y => xor_r);

  mult_inst : multiplicador4bits
    port map(a => a, b => b, produto => mult_r);

  op_sel <= sel1 & sel2 & sel3;

  
  -- Seleção de operações
  
  process(op_sel, soma_r, sub_r, nand_r, xor_r, mult_r, soma_cout, sub_borrow)
  begin
    resultado_s  <= (others => '0');
    led_logica   <= (others => '0');
    cout         <= '0';

    case op_sel is
      
      -- SOMA
      when "000001" =>
        resultado_s <= ('0' & soma_r);
        cout        <= soma_cout;

      -- SUBTRAÇÃO
      when "000010" =>
        resultado_s <= ('0' & sub_r);
        cout        <= sub_borrow;

      -- AND (usando NAND invertido)
      when "000011" =>
        led_logica <= std_logic_vector(nand_r);

      -- XOR
      when "000100" =>
        led_logica <= std_logic_vector(xor_r);

      -- MULTIPLICAÇÃO (5 LSB)
      when "000101" =>
        resultado_s <= mult_r(4 downto 0);

      when others =>
        resultado_s <= (others => '0');
    end case;
  end process;

  
  -- DISPLAY DO RESULTADO
  display_inst : display_7seg
    port map (
      num      => std_logic_vector(resultado_s(3 downto 0)),
      seg_unid => disp_unid,
      seg_dez  => disp_dez
    );

end architecture;
