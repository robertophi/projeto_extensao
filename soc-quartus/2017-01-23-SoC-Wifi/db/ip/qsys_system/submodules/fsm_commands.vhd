library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- FSM de controle que diz qual comando, como e quando serÃ¡ executado. TambÃ©m retorna interrupt = 1 quando termina um comando.
entity fsm_commands is
    generic (
        command_width : natural := 8;                                       -- Tamanho dos comandos
        row_col_width : natural := 8;                                       -- Tamanho da linha e coluna
        data_width : natural := 32;                                         -- Tamanho de dados
        rows : natural := 4;                                                -- NÃºmero total de linhas
        cols : natural := 4                                                 -- NÃºmero total de colunas
    );
    port (
        clock, reset : in std_logic;                                        -- Reset assÃ­ncrono que volta para wait_command
        enable : in std_logic;                                              -- Enable para verificar quando sai do estado de wait_command e realiza o comando
        acknowledge : in std_logic;                                         -- Sinal que reconhece que o comando terminado foi recebido
        command : in std_logic_vector(command_width-1 downto 0);            -- Comando a ser executado
        row, col : in std_logic_vector(row_col_width-1 downto 0);           -- NÃºmero da linha e coluna de entrada (comeÃ§a com 0, 1, 2, ..., n. 255 para todos)
        row_out, col_out : out std_logic_vector(row_col_width-1 downto 0);  -- NÃºmero da linha e coluna a ser alterado pelo comando em questÃ£o (comeÃ§a com 0, 1, 2, ..., n. 255 para todos)
        status : out std_logic_vector(data_width-1 downto 0);               -- SaÃ­da que informa os status. Ainda nada feito aqui
        sel_data_registers : out std_logic_vector(1 downto 0);              -- SaÃ­da que informa em qual registrador do motor deve ser salvo
        sel_input_data_registers : out std_logic_vector(1 downto 0);        -- SaÃ­da que informa qual entrada deve ser salva no registrador do motor em questÃ£o
        command_done : out std_logic;                                       -- SaÃ­da que avisa que terminou um comando
        new_command : out std_logic                                         -- SaÃ­da que informa que houve novo comando para o motor em questÃ£o
    );
end entity; -- fsm_commands


architecture behavioral of fsm_commands is
    
    type states is (
        wait_command, wait_acknowledge, 
        change_power, change_shift_amount, change_decay,
        copy_to_next_row_power, copy_to_next_row_shift_amount, copy_to_next_row_decay,
        copy_to_next_col_power, copy_to_next_col_shift_amount, copy_to_next_col_decay
    );

    signal current_state, next_state : states;


begin

    -- FSM principal
    memory_element :
        process(clock, reset)
        begin
            if (reset = '1') then
                current_state <= wait_command;
            elsif (rising_edge(clock)) then
                current_state <= next_state;
            end if;
        end process;

    next_state_logic :
        process(current_state, enable, command, acknowledge, row, col)
        begin
            case current_state is

                when wait_command =>                                -- Espera enable = 1 e ebÃ£o verificar qual comando foi enviado
                    if (enable = '1') then
                        case to_integer(unsigned(command)) is       -- "Decodificador" para decifrar qual comando foi enviado

                            when 0 =>
                                next_state <= change_power;

                            when 1 =>
                                next_state <= change_shift_amount;

                            when 2 =>
                                next_state <= change_decay;

                            when 3 =>
                                next_state <= copy_to_next_row_power;

                            when 4 =>
                                next_state <= copy_to_next_col_power;

                            when others =>
                                next_state <= wait_command;

                        end case;
                    else
                        next_state <= wait_command;
                    end if;

                when wait_acknowledge =>                            -- Espera o termino do comando ser reconhecido e volta a esperar comando
                    if (acknowledge = '1') then
                        next_state <= wait_command;
                    else
                        next_state <= wait_acknowledge;     
                    end if;

                when copy_to_next_row_power =>                      -- Comando copiar para a prÃ³xima linha. Um estado para cada registrador a ser alterado (potÃªncia, variaÃ§Ã£o, decaimento)
                    next_state <= copy_to_next_row_shift_amount;

                when copy_to_next_row_shift_amount =>
                    next_state <= copy_to_next_row_decay;

                when copy_to_next_col_power =>                      -- Comando copiar para a prÃ³xima linha. Um estado para cada registrador a ser alterado (potÃªncia, variaÃ§Ã£o, decaimento)
                    next_state <= copy_to_next_col_shift_amount;

                when copy_to_next_col_shift_amount =>
                    next_state <= copy_to_next_col_decay;

                when others =>                                      -- Todos os outros estados de comandos sempre vÃ£o para a espera do reconhecimento de termino de comando
                    next_state <= wait_acknowledge;

            end case;
        end process;

    output_logic :
        process(current_state, acknowledge, row, col)
        begin
            command_done <= '0';                        -- InÃ­cio do valor padrÃ£o das variÃ¡veis.
            new_command <= '0';
            row_out <= (0 => '0', others => '1');
            col_out <= (0 => '0', others => '1');
            sel_data_registers <= "00";
            sel_input_data_registers <= "00";
            case current_state is

                when wait_command =>
                    command_done <= '0';                -- Deixado para clareza do codigo

                when wait_acknowledge =>
                    command_done <= '1';

                when change_power =>                    -- Altera a potÃªncia de motores
                    sel_data_registers <= "00";
                    row_out <= row;
                    col_out <= col;
                    new_command <= '1';

                when change_shift_amount =>             -- Altera a variaÃ§Ã£o de motores
                    sel_data_registers <= "01";
                    row_out <= row;
                    col_out <= col;
                    new_command <= '1';

                when change_decay =>                    -- Altera o decaimento de motores
                    sel_data_registers <= "10";
                    row_out <= row;
                    col_out <= col;
                    new_command <= '1';

                when copy_to_next_row_power =>          -- Copia os valores de potÃªncia da linha indicada para a prÃ³xima linha
                    if row = "11111111" then
                        row_out <= row ;
                    else
                        row_out <= std_logic_vector(unsigned(row) + 1);
                    end if;
                    col_out <= (others => '1');
                    sel_input_data_registers <= "01";
                    sel_data_registers <= "00";
                    new_command <= '1';

                when copy_to_next_row_shift_amount =>   -- Copia os valores de variaÃ§Ã£o da linha indicada para a prÃ³xima linha
                    if row = "11111111" then
                        row_out <= row ;
                    else
                        row_out <= std_logic_vector(unsigned(row) + 1);
                    end if;
                    col_out <= (others => '1');
                    sel_input_data_registers <= "01";
                    sel_data_registers <= "01";
                    new_command <= '1';

                when copy_to_next_row_decay =>          -- Copia os valores de decaimento da linha indicada para a prÃ³xima linha
                  if row = "11111111" then
                        row_out <= row ;
                    else
                        row_out <= std_logic_vector(unsigned(row) + 1);
                    end if;
                    col_out <= (others => '1');
                    sel_input_data_registers <= "01";
                    sel_data_registers <= "10";
                    new_command <= '1';

                when copy_to_next_col_power =>          -- Copia os valores de potÃªncia da coluna indicada para a prÃ³xima coluna
                    if col = "11111111" then
                        col_out <= row ;
                    else
                        col_out <= std_logic_vector(unsigned(col) + 1);
                    end if;
                    row_out <= (others => '1');
                    sel_input_data_registers <= "10";
                    sel_data_registers <= "00";
                    new_command <= '1';

                when copy_to_next_col_shift_amount =>   -- Copia os valores de variaÃ§Ã£o da coluna indicada para a prÃ³xima coluna
                   if col = "11111111" then
                        col_out <= row ;
                    else
                        col_out <= std_logic_vector(unsigned(col) + 1);
                    end if;
                    row_out <= (others => '1');
                    sel_input_data_registers <= "10";
                    sel_data_registers <= "01";
                    new_command <= '1';

                when copy_to_next_col_decay =>          -- Copia os valores de decaimento da coluna indicada para a prÃ³xima coluna
                   if col = "11111111" then
                        col_out <= row ;
                    else
                        col_out <= std_logic_vector(unsigned(col) + 1);
                    end if;
                    row_out <= (others => '1');
                    sel_input_data_registers <= "10";
                    sel_data_registers <= "10";
                    new_command <= '1';

                when others =>

            end case;
        end process;

end architecture; -- behavioral