library ieee;
use ieee.std_logic_1164.all;

entity bloco_de_controle is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        start   : in  std_logic;

        opcode  : in  std_logic_vector(2 downto 0); -- sel1 sel2 sel3 vindo de fora

        sel1    : out std_logic_vector(1 downto 0);
        sel2    : out std_logic_vector(1 downto 0);
        sel3    : out std_logic_vector(1 downto 0);

        done    : out std_logic
    );
end entity bloco_de_controle;

architecture rtl of bloco_de_controle is

    type state_type is (idle, exec, finish);
    signal estado_atual, proximo_estado : state_type;

begin

    --------------------------------------------
    -- PROCESSO SEQUENCIAL: ATUALIZAÇÃO DE ESTADO
    --------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            estado_atual <= idle;
        elsif rising_edge(clk) then
            estado_atual <= proximo_estado;
        end if;
    end process;


    --------------------------------------------
    -- PROCESSO COMBINACIONAL: PRÓXIMO ESTADO
    --------------------------------------------
    process(estado_atual, start)
    begin
        case estado_atual is
            
            when idle =>
                if start = '1' then
                    proximo_estado <= exec;
                else
                    proximo_estado <= idle;
                end if;

            when exec =>
                -- Executa a operação da ULA por 1 ciclo
                proximo_estado <= finish;

            when finish =>
                -- Indica que acabou e volta ao início
                proximo_estado <= idle;

        end case;
    end process;


    --------------------------------------------
    -- SAÍDAS DO CONTROLADOR
    --------------------------------------------

    -- repassa o opcode aos seletores da ULA
    sel1 <= opcode(2 downto 1);
    sel2 <= "00";                   -- se não usar, deixa fixo
    sel3 <= opcode(0) & '0';        -- ou mapeie como desejar

    -- done fica 1 somente no estado finish
    done <= '1' when estado_atual = finish else '0';

end architecture rtl;

    
