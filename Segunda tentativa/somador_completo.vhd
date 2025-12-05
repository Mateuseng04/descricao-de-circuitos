library ieee;
use ieee.std_logic_1164.all; -- Declaração da biblioteca padrão de lógica

entity somador_completo is
    port (
        x : in std_logic;
        y : in std_logic;       -- Entradas do somador completo
        cin : in std_logic;
        sum : out std_logic;
        cout : out std_logic     -- Saídas do somador completo
    );
end entity somador_completo;

architecture comportamento of somador_completo is  -- Arquitetura do somador completo
    component meio_somador                     -- Declaração do componente meio_somador, suas entradas e saídas
        port (
            x : in std_logic;
            y : in std_logic;
            sum : out std_logic;
            cout : out std_logic
        );
    end component;
    signal s1, c1, c2 : std_logic;             -- Sinais internos para conectar os componentes
begin 
    U1: meio_somador port map (x => x, y => y, sum => s1, cout => c1);    -- Instanciação do primeiro meio somador
    U2: meio_somador port map (x => s1, y => cin, sum => sum, cout => c2); -- Instanciação do segundo meio somador
    cout <= c1 or c2;                         -- Atribuição da saída de carry do somador completo
end architecture comportamento;
