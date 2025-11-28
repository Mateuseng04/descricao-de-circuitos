library ieee;
use ieee.std_logic_1164.all;
entity somador_completo4bits is
  port (
    dip_x    : in std_logic_vector (3 downto 0);
    dip_y    : in std_logic_vector (3 downto 0);
    dip_cin  : in std_logic;
    led_s    : out std_logic_vector (3 downto 0);
    led_cout : out std_logic);

end somador_completo4bits;

architecture estrutural of somador_completo4bits is
  component somador_completo
    port (
      a, b, cin : in std_logic;
      s, cout   : out std_logic
    );
  end component;
  signal c1, c2, c3          : std_logic;
  signal cout1, cout2, cout3 : std_logic;
  signal a, b                : std_logic_vector (3 downto 0);
begin
  SomadorCompletol : somador_completo
  port map
  (
    dip_x(0), dip_y(0), dip_cin,
    led_s(0), cout1
  );

  SomadorCompleto2 : somador_completo
  port map
  (
    dip_x(1), dip_y(1), cout1,
    led_s(1), cout2
  );

  SomadorCompleto3 : somador_completo
  port map
  (
    dip_x(2), dip_y(2), cout2,
    led_s(2), cout3
  );

  SomadorCompleto4 : somador_completo
  port map
  (
    dip_x(3), dip_y(3), cout3,
    led_s(3), led_cout
  );
end estrutural;