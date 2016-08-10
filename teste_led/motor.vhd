library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Controle de um motor por PWM que recebe potência, variação e decay da entrada ou dos motores anteriores (cima ou esquerda)
entity motor is
    generic (
        row_col_width : natural := 8;                                       -- Tamanho da linha e coluna
        own_row, own_col : natural := 0;                                    -- Linha e coluna onde este motor se encontra
        motor_data_width : natural := 8                                     -- Tamanho dos dados
     );
    port (
        clock, reset : in std_logic;                                        -- Clock e reset assíncrono que zera todos os registradores internos e também volta para o estado inicial do PWM
        new_command : in std_logic;                                         -- Novo comando recebido do controle
        clock_timer : in std_logic;                                         -- Clock do delay que pode ser o interno pelo timer ou externo
        timer : in std_logic_vector(motor_data_width-1 downto 0);           -- Sinal dos motor_data_width primeiros bits do timer para fazer o PWM
        row, col : in std_logic_vector(row_col_width-1 downto 0);           -- Linha e coluna atual onde se pretende enviar dados ou ligar motores
        sel_data_registers : in std_logic_vector(1 downto 0);               -- Seletor dos registradores internos de potência, variação e decaimento
        sel_input_data_registers : in std_logic_vector(1 downto 0);         -- Seletor de qual entrada salva nos registradores internos
        motor_data : in std_logic_vector(motor_data_width-1 downto 0);      -- Valor de dados de entrada
        motor_up_data : in std_logic_vector(motor_data_width-1 downto 0);   -- Valor de dados do motor de cima
        motor_left_data : in std_logic_vector(motor_data_width-1 downto 0); -- Valor de dados do motor da esquerda
        motor_data_out : out std_logic_vector(motor_data_width-1 downto 0); -- Saída de dados para ir para o próximo motor
        power_wave : out std_logic                                          -- Onda de saída que liga ou desliga o motor conforme a potência
    );
end entity; -- motor


architecture structural of motor is
    
    signal saved_power, power_shift_amount, power_decay : std_logic_vector(motor_data_width-1 downto 0) := (others => '0'); -- Sinais internos dos registradores
    signal acknowledge_motor, new_command_acknowledged : std_logic := '0';                                                  -- Reconhece novo comando e reconhece se este é o motor a ser modificado
    signal enable_power_register, enable_power_decay, enable_power_shift_amount : std_logic := '0';                         -- Enable dos registradores internos
    signal motor_data_selected : std_logic_vector(motor_data_width-1 downto 0) := (others => '0');                          -- Valor selecionado das entradas de dados a ser salvo nos registradores internos

    -- Registrador de data_width bits para salvar os valores de potência, decaimento e velocidade de transição
    component register_data_width            
        generic (
            data_width : natural := 32
        );
        port (
            clock, reset : in std_logic;
            enable : in std_logic;
            inpt : in std_logic_vector(data_width-1 downto 0);
            outpt : out std_logic_vector(data_width-1 downto 0)
        );
    end component;

    -- FSM que controla o PWM do motor e as variações e decaimento
    component motor_fsm is
        generic (
            motor_data_width : natural := 8
        );
        port (
            clock, reset : in std_logic;
            clock_timer : in std_logic;
            new_command_acknowledged : in std_logic;
            timer : in std_logic_vector(motor_data_width-1 downto 0);
            saved_power : in std_logic_vector(motor_data_width-1 downto 0);
            power_shift_amount : in std_logic_vector(motor_data_width-1 downto 0);
            power_decay : in std_logic_vector(motor_data_width-1 downto 0);
            power_wave : out std_logic
        );
    end component;

begin
    
    -- Verifica se a comunicação está sendo feita com este motor (enable do decodificador abaixo)
    acknowledge_motor <= '1' when ((to_integer(unsigned(col)) = own_col or to_integer(unsigned(col)) = 255) and 
                                   (to_integer(unsigned(row)) = own_row or to_integer(unsigned(row)) = 255)) else
                         '0';

    -- Sinal com a lógica para o reset do motor fsm, ou seja, quando reset ou quando chega novo comando para este motor
    new_command_acknowledged <= acknowledge_motor and new_command;

    -- Decodificador com enable que identifica o que o sinal motor_data representa
    enable_power_register <= '1' when (acknowledge_motor = '1') and (sel_data_registers = "00") else
                             '0';
    enable_power_shift_amount <= '1' when (acknowledge_motor = '1') and (sel_data_registers = "01") else
                                 '0';
    enable_power_decay <= '1' when (acknowledge_motor = '1') and (sel_data_registers = "10") else
                          '0';

    -- MUX para selecionar qual entrada vai nos registradores
    with sel_input_data_registers select motor_data_selected <=
        motor_up_data   when "01",
        motor_left_data when "10",
        motor_data      when others;

    -- MUX para colocar motor_data correto na saída
    with sel_data_registers select motor_data_out <=
        power_shift_amount  when "01",
        power_decay         when "10",
        saved_power         when others;
     
    -- Registrador para salvar a potência do motor
    reg_power : register_data_width
        generic map (
            data_width => motor_data_width
        )
        port map (
            clock => clock,
            reset => reset,
            enable => enable_power_register,
            inpt => motor_data_selected,
            outpt => saved_power
        );

    -- Registrador para salvar a velocidade de variação da potência do motor
    reg_power_shift_amount : register_data_width
        generic map (
            data_width => motor_data_width
        )
        port map (
            clock => clock,
            reset => reset,
            enable => enable_power_shift_amount,
            inpt => motor_data_selected,
            outpt => power_shift_amount
        );

    -- Registrador para salvar o decaimento da potência do motor
    reg_power_decay : register_data_width
        generic map (
            data_width => motor_data_width
        )
        port map (
            clock => clock,
            reset => reset,
            enable => enable_power_decay,
            inpt => motor_data_selected,
            outpt => power_decay
        );

    -- Máquina de estados que controla a variação e o decaimento da potência do motor
    fsm_motor : motor_fsm
        generic map (
            motor_data_width => motor_data_width
        )
        port map (
            clock => clock, 
            reset => reset,
            new_command_acknowledged => new_command_acknowledged,
            clock_timer => clock_timer,
            timer => timer(motor_data_width-1 downto 0),
            saved_power => saved_power,
            power_shift_amount => power_shift_amount,
            power_decay => power_decay,
            power_wave => power_wave
        );

end architecture; -- structural