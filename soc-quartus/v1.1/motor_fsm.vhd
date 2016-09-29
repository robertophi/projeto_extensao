library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Máquina de estados que controla a variação e o decaimento da potência do motor
entity motor_fsm is
    generic (
        motor_data_width : natural := 8                                         -- Tamanho dos dados
    );
    port (
        clock, reset : in std_logic;                                            -- Clock e reset assíncrono
        new_command_acknowledged : in std_logic;                                -- Novo comando reconhecido para este motor
        clock_timer : in std_logic;                                             -- Clock para dar o tempo de delay
        timer : in std_logic_vector(motor_data_width-1 downto 0);               -- Timer com motor_data_width bits para fazer o contador do PWM
        saved_power : in std_logic_vector(motor_data_width-1 downto 0);         -- Valor salvo de potência
        power_shift_amount : in std_logic_vector(motor_data_width-1 downto 0);  -- Valor salvo de variação
        power_decay : in std_logic_vector(motor_data_width-1 downto 0);         -- Valor salvo de decaimento
        power_wave : out std_logic                                              -- Onda de saída para ligar o motor
    );
end entity; -- motor_fsm


architecture behavioral of motor_fsm is

    type states is (test_shift_amount, be_equal_shift_amount, sum_shift_amount, sub_shift_amount, delay_shift_amount, set_acknowledge_shift_amount,
                    test_decay, be_zero_power, sub_decay, delay_decay, set_acknowledge_decay, wait_new_command);

    signal current_state, next_state : states;

    signal current_power, next_power : std_logic_vector(motor_data_width-1 downto 0) := (others => '0');    -- Sinal para sincronizar a atualização da potência com o clock
    signal current_acknowledge_delay, next_acknowledge_delay : std_logic;                                   -- Sinal para sincronizar o reconhecimento do delay com clock

begin

    -- Descrição da onda de saída dos motores. Define a potência em forma de PWM conforme a contagem do timer
    power_wave <= '1' when (unsigned(current_power) > unsigned(timer(motor_data_width-1 downto 0))) else
                  '0';

    -- Máquina de estados da velocidade de variação da potência e do decaimento da potência
    -- Elemento de memória para guardar os estados atuais
    memory_element_states :
        process (clock, reset, new_command_acknowledged)
        begin
            if ((reset = '1') or (new_command_acknowledged = '1')) then     -- Se receber novo comando, vai para o estado inicial de novo
                current_state <= test_shift_amount;
            elsif rising_edge(clock) then
                current_state <= next_state;
            end if;
        end process;

    -- Elemento de memória para guardar a potência atual entre as variações e o decaimento
    memory_element_power :
        process (clock, reset)
        begin
            if (reset = '1') then
                current_power <= (others => '0');
            elsif rising_edge(clock) then
                current_power <= next_power;
            end if;
        end process;

    -- Elemento de memória para guardar o reconhecimento do delay para fazer uma lógica e identificar se o clock do delay antes era 0 (para identificar a borda de transição)
    memory_element_counter :
        process (clock, reset)
        begin
            if rising_edge(clock) then
                current_acknowledge_delay <= next_acknowledge_delay;
            end if;
        end process;

    next_state_logic : 
        process (current_state, current_power, saved_power, power_shift_amount, power_decay, clock_timer, current_acknowledge_delay)
        begin
            case current_state is

                when test_shift_amount =>               -- Testa se há variação e vai para os estados adquados de soma, subtração ou para igualar, se não vai para test_decay
                    if (current_power = saved_power) then
                        next_state <= test_decay;
                    elsif (unsigned(power_shift_amount) = 0) then
                        next_state <= be_equal_shift_amount;
                    elsif (unsigned(current_power) > unsigned(saved_power)) then
                        if ((unsigned(current_power) - unsigned(saved_power)) <= unsigned(power_shift_amount)) then
                            next_state <= be_equal_shift_amount;
                        else
                            next_state <= sub_shift_amount;
                        end if;
                    else
                        if ((unsigned(saved_power) - unsigned(current_power)) <= unsigned(power_shift_amount)) then
                            next_state <= be_equal_shift_amount;
                        else
                            next_state <= sum_shift_amount;
                        end if;
                    end if;

                when be_equal_shift_amount =>           -- Iguala a potência atual ao valor salvo
                    next_state <= delay_shift_amount;

                when sum_shift_amount =>                -- Soma a variação salva a potência atual
                    next_state <= delay_shift_amount;

                when sub_shift_amount =>                -- Subtrai a variação salva da potência atual
                    next_state <= delay_shift_amount;

                when delay_shift_amount =>              -- Espera o delay. Há um teste para verificar se o timer era 0 antes e fazer um teste de borda
                    if (clock_timer = '1') then
                        if (current_acknowledge_delay = '1') then
                            next_state <= test_shift_amount;
                        else
                            next_state <= delay_shift_amount;
                        end if;
                    else
                        next_state <= set_acknowledge_shift_amount;
                    end if;

                when set_acknowledge_shift_amount =>    -- Atualiza o current_acknowledge_delay
                    next_state <= delay_shift_amount;

                when test_decay =>                      -- Testa se há decaimento e vai para os estados adquados de subtração ou para zerar, se não espera novo comando
                    if ((unsigned(power_decay) = 0) or (unsigned(current_power) = 0)) then
                        next_state <= wait_new_command;
                    elsif (unsigned(current_power) <= unsigned(power_decay)) then
                        next_state <= be_zero_power;
                    else
                        next_state <= sub_decay;
                    end if;

                when be_zero_power =>                   -- Zera a potência atual
                    next_state <= test_decay;

                when sub_decay =>                       -- Subtrai o decaimento salvo da potência atual
                    next_state <= delay_decay;

                when delay_decay =>                     -- Espera o delay. Há um teste para verificar se o timer era 0 antes e fazer um teste de borda
                    if (clock_timer = '1') then
                        if (current_acknowledge_delay = '1') then
                            next_state <= test_decay;
                        else
                            next_state <= delay_decay;
                        end if;
                    else
                        next_state <= set_acknowledge_decay;
                    end if;

                when set_acknowledge_decay =>           -- Atualiza o current_acknowledge_delay
                    next_state <= delay_decay;

                when wait_new_command =>                -- Último estado que somente espera novo comando
                    next_state <= wait_new_command;

            end case;
        end process;

    output_logic :
        process (current_state, current_power, saved_power, power_shift_amount, power_decay, current_acknowledge_delay)
        begin
            next_power <= current_power;
            next_acknowledge_delay <= current_acknowledge_delay;

            case current_state is

                when test_shift_amount =>
                    next_acknowledge_delay <= '0';

                when be_equal_shift_amount =>
                    next_power <= saved_power;

                when sum_shift_amount =>
                    next_power <= std_logic_vector(unsigned(current_power) + unsigned(power_shift_amount));

                when sub_shift_amount =>
                    next_power <= std_logic_vector(unsigned(current_power) - unsigned(power_shift_amount));

               when delay_shift_amount =>

                when set_acknowledge_shift_amount =>
                    next_acknowledge_delay <= '1';

                when test_decay =>
                    next_acknowledge_delay <= '0';
                when be_zero_power => 
                    next_power <= (others => '0');

                when sub_decay =>
                    next_power <= std_logic_vector(unsigned(current_power) - unsigned(power_decay));

                when delay_decay =>

                when set_acknowledge_decay =>
                    next_acknowledge_delay <= '1';

                when wait_new_command => 

            end case;
        end process;

end architecture; -- behavioral