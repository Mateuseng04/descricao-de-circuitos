library ieee;
use ieee.std_logic_1164.all; -- Declaração da biblioteca padrão de lógica

entity somador_4bits is
    port (
        A: in std_logic_vector (3 downto 0);
        B: in std_logic_vector (3 downto 0);       -- Entradas do somador de 4 bits
        Cin: in std_logic;
        sum: out std_logic_vector (3 downto 0);
        co: out std_logic    -- Saídas do somador de 4 bits

    );
end entity somador_4bits;

architecture comportamento of somador_4bits is -- Arquitetura do somador de 4 bits
    component somador_completo                 -- Declaração do componente somador_completo, suas entradas e saídas
        port (
            x : in std_logic;
            y : in std_logic;
            cin : in std_logic;
            sum : out std_logic;
            cout : out std_logic
        );
    end component;
    signal c1, c2, c3 : std_logic;             -- Sinais internos para conectar os componentes

begin
    U1: somador_completo port map (x => A(0), y => B(0), cin => Cin, sum => sum(0), cout => c1); -- Instanciação do primeiro somador completo
    U2: somador_completo port map (x => A(1), y => B(1), cin => c1, sum => sum(1), cout => c2); -- Instanciação do segundo somador completo
    U3: somador_completo port map (x => A(2), y => B(2), cin => c2, sum => sum(2), cout => c3); -- Instanciação do terceiro somador completo
    U4: somador_completo port map (x => A(3), y => B(3), cin => c3, sum => sum(3), cout => co);  -- Instanciação do quarto somador completo
end architecture comportamento;
