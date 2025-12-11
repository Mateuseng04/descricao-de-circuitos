library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Projeto_final is
    port (
        clk    : in std_logic;
        reset  : in std_logic;
        start  : in std_logic;
        leds   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture comportamento of Projeto_final is

    signal sel1_s, sel2_s, sel3_s : std_logic_vector(1 downto 0);
    signal done_s                 : std_logic;
    signal resultado_s            : unsigned (4 downto 0);

begin

    controle_inst : entity work.bloco_de_controle
        port map (
            clk    => clk,
            reset  => reset,
            start  => start,
            opcode => "101",   -- exemplo
            sel1   => sel1_s,
            sel2   => sel2_s,
            sel3   => sel3_s,
            done   => done_s
        );

    ula_inst : entity work.ula
        port map (
            a => "0101",
            b => "0011",
            cin => '0',
            sel1 => sel1_s,
            sel2 => sel2_s,
            sel3 => sel3_s,
            resultado => resultado_s,
            display_out => open
        );
    leds(4 downto 0) <= std_logic_vector(resultado_s);
    leds(7) <= done_s;

end architecture;

