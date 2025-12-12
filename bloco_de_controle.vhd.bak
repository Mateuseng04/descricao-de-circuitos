    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    entity bloco_de_controle is
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            start   : in  std_logic;  -- botão de confirmação

            opcode  : in  std_logic_vector(2 downto 0); -- sel1 sel2 sel3 vindo de fora
            numero  : in  std_logic_vector(3 downto 0); -- entrada da ULA

            sel1    : out std_logic_vector(1 downto 0);
            sel2    : out std_logic_vector(1 downto 0);
            sel3    : out std_logic_vector(1 downto 0);

            A_reg   : out std_logic_vector(3 downto 0);
            B_reg   : out std_logic_vector(3 downto 0);
            op_reg  : out std_logic_vector(2 downto 0);
            estado_dbg : out STD_LOGIC_VECTOR(2 downto 0);

            done    : out std_logic
        );
    end entity bloco_de_controle;

    architecture rtl of bloco_de_controle is
    
        --------------------------------------------------------------------
        -- DEFINIÇÃO DOS ESTADOS
        --------------------------------------------------------------------
        type state_type is (
            idle,
            sel_op,
            digita_A,
            digita_B,
            executa,
            mostra,
            resetando
        );

        signal estado_atual, proximo_estado : state_type;
        
        --------------------------------------------------------------------
        -- REGISTRADORES INTERNOS
        --------------------------------------------------------------------
        signal A_s, B_s : std_logic_vector(3 downto 0);
        signal op_s     : std_logic_vector(2 downto 0);

    begin
        estado_dbg <= STD_LOGIC_VECTOR(to_unsigned(state_type'pos(estado_atual), 3));
        --------------------------------------------------------------------
        -- PROCESSO SEQUENCIAL: REGISTRADOR DE ESTADOS
        --------------------------------------------------------------------
        process(clk, reset)
        begin
            if reset = '1' then
                estado_atual <= idle;
            elsif rising_edge(clk) then
                estado_atual <= proximo_estado;
            end if;
        end process;


        --------------------------------------------------------------------
        -- PROCESSO COMBINACIONAL: LÓGICA DE PRÓXIMO ESTADO
        --------------------------------------------------------------------
        process(estado_atual, start)
        begin
            proximo_estado <= estado_atual; -- padrão: permanecer no estado

            case estado_atual is

                when idle =>
                    if start = '1' then
                        proximo_estado <= sel_op;
                    end if;

                when sel_op =>
                    if start = '1' then
                        proximo_estado <= digita_A;
                    end if;

                when digita_A =>
                    if start = '1' then
                        proximo_estado <= digita_B;
                    end if;

                when digita_B =>
                    if start = '1' then
                        proximo_estado <= executa;
                    end if;

                when executa =>
                    if start = '1' then
                        proximo_estado <= mostra;
                    end if;

                when mostra =>
                    if start = '1' then
                        proximo_estado <= resetando;
                    end if;

                when resetando =>
                    if start = '1' then
                        proximo_estado <= idle;
                    end if;

            end case;
        end process;


        --------------------------------------------------------------------
        -- PROCESSO SEQUENCIAL: REGISTRADORES DE OPERANDO E OPERAÇÃO
        --------------------------------------------------------------------
        process(clk, reset)
        begin
            if reset = '1' then
                A_s  <= (others => '0');
                B_s  <= (others => '0');
                op_s <= (others => '0');

            elsif rising_edge(clk) then
                case estado_atual is

                    when sel_op =>
                        if start = '1' then
                            op_s <= opcode;   -- guarda operação
                        end if;

                    when digita_A =>
                        if start = '1' then
                            A_s <= numero;     -- guarda o primeiro número
                        end if;

                    when digita_B =>
                        if start = '1' then
                            B_s <= numero;     -- guarda o segundo número
                        end if;

                    when resetando =>
                        if start = '1' then
                            A_s  <= (others => '0');
                            B_s  <= (others => '0');
                            op_s <= (others => '0');
                        end if;

                    when others =>
                        null;
                end case;
            end if;
        end process;


        --------------------------------------------------------------------
        -- SAÍDAS PARA A ULA / OPERANDO / OPERAÇÃO
        --------------------------------------------------------------------
        A_reg  <= A_s;
        B_reg  <= B_s;
        op_reg <= op_s;

        --------------------------------------------------------------------
        -- SELETORES DA ULA → mapeados como no seu código original
        --------------------------------------------------------------------
        sel1 <= opcode(2 downto 1);
        sel2 <= "00";
        sel3 <= opcode(0) & '0';

        --------------------------------------------------------------------
        -- DONE É 1 SOMENTE NO ESTADO "mostra"
        --------------------------------------------------------------------
        done <= '1' when estado_atual = mostra else '0';

    end architecture rtl;
