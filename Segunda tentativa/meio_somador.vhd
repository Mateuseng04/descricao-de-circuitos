library ieee;
use ieee.std_logic_1164.all; -- Declaração da biblioteca padrão de lógica

-- Início do arquivo meio_somador.vhd
entity meio_somador is      -- Declaração da entidade meio_somador
    port (
        x : in std_logic;
        y : in std_logic;       -- Entradas do meio somador
        sum : out std_logic;
        cout : out std_logic     -- Saídas do meio somador
    );
end entity meio_somador;

architecture comportamento of meio_somador is  -- Arquitetura do meio somador
    component xor_gate                         -- Declaração do componente xor_gate, suas entradas e saídas
        port (
            a : in std_logic;
            b : in std_logic;
            f : out std_logic
        );
    end component;
    component and_gate                         -- Declaração do componente and_gate, suas entradas e saídas 
        port (
            a : in std_logic;
            b : in std_logic;
            f : out std_logic
        );
    end component;
    signal n1, n2 : std_logic;                 -- Sinais internos para conectar os componentes
begin
    U1: xor_gate port map (a => x, b => y, f => n1);    -- Instanciação do componente xor_gate
    U2: and_gate port map (a => x, b => y, f => n2);    -- Instanciação do componente and_gate
    sum <= n1;
    cout <= n2;                               -- Atribuição das saídas do meio somador
end architecture comportamento;
-- Fim do arquivo meio_somador.vhd

