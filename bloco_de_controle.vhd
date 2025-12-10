library ieee;
use ieee.std_logic_1164.all;


entity bloco_de_controle is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        start   : in  std_logic;
        done    : out std_logic
    );
end entity bloco_de_controle;

architecture rtl of bloco_de_controle is
    type state_type is (inicial, espera, soma, subtracao, and_op, xor_op, multiplicacao, final);
    signal estado_atual, proximo_estado : std_logic_vector(3 downto 0);
begin -- processo de transicao de estados
    process(clk, reset)
    begin
        if reset = '1' then
            estado_atual <= "0000";
        elsif rising_edge(clk) then
            estado_atual <= proximo_estado;
        end if;
    end process;
 -- processo de logica combinacional para proximo estado
    process(estado_atual, start)
    begin
        case estado_atual is
            when "0000" =>  -- inicial
                if start = '1' then
                    proximo_estado <= "0001"; -- espera
                else
                    proximo_estado <= "0000"; -- inicial
                end if;
            when "0001" =>  -- espera
                proximo_estado <= "0010"; -- soma
            when "0010" =>  -- soma
                proximo_estado <= "0011"; -- subtracao
            when "0011" =>  -- subtracao
                proximo_estado <= "0100"; -- and_op
            when "0100" =>  -- and_op
                proximo_estado <= "0101"; -- xor_op
            when "0101" =>  -- xor_op
                proximo_estado <= "0110"; -- multiplicacao
            when "0110" =>  -- multiplicacao
                proximo_estado <= "0111"; -- final
            when "0111" =>  -- final
                proximo_estado <= "0000"; -- inicial
            when others =>
                proximo_estado <= "0000"; -- inicial
        end case;
    end process;

    done <= '1' when estado_atual = "0111" else '0';

end architecture rtl;
    
