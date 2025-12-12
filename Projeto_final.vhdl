library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Projeto_final is
    port (
        clk    : in std_logic;
        reset  : in std_logic;
        start  : in std_logic;

        numero : in std_logic_vector(3 downto 0);

        leds   : out std_logic_vector(7 downto 0);
        estado_atual2 : out std_logic_vector(2 downto 0)
    );
end entity;


architecture comportamento of Projeto_final is

    -- sinais internos
    signal sel1_s, sel2_s, sel3_s : std_logic_vector(1 downto 0);
    signal A_s, B_s               : std_logic_vector(3 downto 0);
    signal opcode_s               : std_logic_vector(2 downto 0);
    signal done_s                 : std_logic;
    signal resultado_s            : unsigned(4 downto 0);
    signal display_s              : std_logic_vector(6 downto 0);

begin

    --------------------------------------------------------------------
    -- BLOCO DE CONTROLE
    --------------------------------------------------------------------
    controle_inst : entity work.bloco_de_controle
        port map (
            clk    => clk,
            reset  => reset,
            start  => start,
            opcode => numero(2 downto 0),   -- usuário escolhe operação
            numero => numero,               -- entrada de A e B

            sel1   => sel1_s,
            sel2   => sel2_s,
            sel3   => sel3_s,

            A_reg  => A_s,
            B_reg  => B_s,
            op_reg => opcode_s,

            estado_dbg => estado_atual2,
            done   => done_s
        );


    --------------------------------------------------------------------
    -- ULA
    --------------------------------------------------------------------
    ula_inst : entity work.ula
        port map (
            a      => unsigned(A_s),
            b      => unsigned(B_s),
            cin    => '0',

            sel1   => sel1_s,
            sel2   => sel2_s,
            sel3   => sel3_s,

            resultado     => resultado_s,
            led_logica    => open,
            y             => open,
            cout          => open

        
        );


    --------------------------------------------------------------------
    -- LEDs DE DEBUG E RESULTADO
    --------------------------------------------------------------------
    leds(2 downto 0) <= estado_atual2;                 -- estado da FSM
    leds(7) <= done_s;                                 -- operação concluída
    leds(6 downto 3) <= std_logic_vector(resultado_s(4 downto 1)); 
    leds(0) <= resultado_s(0);

end architecture;


