-- Módulo 1: Divisor de Clock (Gera um clk_lento)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock_Divider is
    port (
        clk_in   : in  std_logic; -- Clock de entrada da FPGA (ex: 50 MHz)
        rst      : in  std_logic; -- Reset assíncrono (boa prática)
        clk_out  : out std_logic  -- Clock lento (ex: 1 Hz)
    );
end entity Clock_Divider;

architecture Behavioral of Clock_Divider is
    -- Para gerar 1 Hz a partir de 50 MHz, precisamos contar 25.000.000 (50M / 2)
    constant COUNT_MAX : integer := 25000000 - 1; 
    -- 25 milhões requerem 25 bits (2^24 < 25M < 2^25)
    signal counter     : natural range 0 to COUNT_MAX := 0;
    signal clk_temp    : std_logic := '0';

begin

    process (clk_in, rst)
    begin
        if rst = '1' then
            counter <= 0;
            clk_temp <= '0';
        elsif rising_edge(clk_in) then
            if counter = COUNT_MAX then
                counter <= 0;
                -- Alterna o clock lento a cada 25M ciclos, resultando em 1 Hz
                clk_temp <= not clk_temp; 
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_temp;

end architecture Behavioral;