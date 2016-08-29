library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MotorMatrixControl is
    generic (
        rows : positive := 8;          -- Número de linhas da matriz de motores
        cols : positive := 8;          -- Número de colunas da matriz de motores
        dataWidth : positive := 32     -- Tamanho de cada entrada data
    );
    port (
        clock, reset : in std_logic;                                -- Sinais padrões de clock e reset
        enable : in std_logic;                                      -- Controla quando o sistema começa a funcionar
        acknowledge : in std_logic;                                 -- Reconhece quando recebe o interrupt = 1
        test : in std_logic;                                        -- Entrada para começar o teste
        bistIn : in std_logic;                                      -- Entrada serial de teste
        readwrite : in std_logic_vector(1 downto 0);                -- Indica se lê ("10") ou escreve ("01") nos registradores
        writedata : in std_logic_vector(dataWidth-1 downto 0);      -- Entrada que escreve no registrador de dados
        readdata : out std_logic_vector(dataWidth-1 downto 0);      -- Saída que envia o registrador de status
        interrupt : out std_logic;                                  -- Sinal que sinaliza que algum comando foi concluído
        bistOut : out std_logic;                                    -- Saída serial de teste
        motors_out : out std_logic_vector(rows*cols-1 downto 0)     -- Saída criada apesar de não estar nas especificações, para poder ligar os motores
    );
end entity; -- MotorMatrixControl


architecture structural of MotorMatrixControl is
    
    type motor_data_array is array (0 to rows*cols) of std_logic_vector(7 downto 0);        -- Vetor com as saídas para ligar os motores
    constant motor_data_width, row_col_width, command_width : natural := 8;                 -- Tamanho dos dados do motor, da linha e coluna e dos comandos
    signal reg_command_data_out, reg_status_in : std_logic_vector(dataWidth-1 downto 0);    -- Sinais internos dos registradores
    signal command : std_logic_vector(command_width-1 downto 0);                            -- Sinal para receber os comandos
    signal row, col : std_logic_vector(row_col_width-1 downto 0);                           -- Sinais para receber as linhas e colunas
    signal data : std_logic_vector(motor_data_width-1 downto 0);                            -- Sinal para receber os dados
    signal row_out, col_out : std_logic_vector(row_col_width-1 downto 0);                   -- Saída do controle com as linhas e colunas a serem modificadas
    signal timer : std_logic_vector(command_width-1 downto 0);                                -- Timer criado para fazer a contagem PWM de todos os motores e também para criar um atraso
    signal sel_data_registers, sel_input_data_registers : std_logic_vector(1 downto 0);     -- Seletores de qual registrador do motor deve ser escrito e de qual entrada pega o valor
    signal new_command, clock_timer : std_logic;                                            -- Sinal do controle que avisa que recebeu novo comando e sinal do clock que gera o delay
    signal motors_data : motor_data_array;                                                  -- Sinal de saída dos motores

    -- Timer que cria um contador compartilhado entre todos os motores para fazer o PWM e que gera um clock para o delay. O clock pode ser substituido por 1 externo.
    component timer_pwm
        generic (
            N : natural := 8
        );
        port (
            clock : in std_logic;
            timer : out std_logic_vector(N-1 downto 0)
        );
    end component;
	
	component temporizador
		generic (
			max_value_counter : natural:= 10000000      --50.000.000 = 1segundo / N = 50.000.000*tempo
			);
		port (
			clock,reset : in std_logic;
         clock_timer : out std_logic
		);
	end component;
	
    -- Registrador geral de data_width bits com enable e reset assíncrono
    component register_data_width            
        generic (
            data_width : natural := 32
        );
        port (
            clock, reset : in std_logic;
            enable : in std_logic;
            inpt : in std_logic_vector(dataWidth-1 downto 0);
            outpt : out std_logic_vector(dataWidth-1 downto 0)
        );
    end component;

    -- FSM de controle que diz qual comando, como e quando será executado. Também retorna interrupt = 1 quando termina um comando.
    component fsm_commands
        generic (
            command_width : natural := 8;
            row_col_width : natural := 8;
            data_width : natural := 32;
            rows : natural := 4;
            cols : natural := 4
        );
        port (
            clock, reset : in std_logic;
            enable : in std_logic;
            acknowledge : in std_logic;
            command : in std_logic_vector(command_width-1 downto 0);
            row, col : in std_logic_vector(row_col_width-1 downto 0);
            row_out, col_out : out std_logic_vector(row_col_width-1 downto 0);
            status : out std_logic_vector(data_width-1 downto 0);
            sel_data_registers : out std_logic_vector(1 downto 0);
            sel_input_data_registers : out std_logic_vector(1 downto 0);
            command_done : out std_logic;
            new_command : out std_logic
        );
    end component;

    -- Controle de um motor por PWM que recebe potência, variação e decay da entrada ou dos motores anteriores (cima ou esquerda)
    component motor
        generic (
            row_col_width : natural := 8;
            own_row, own_col : natural := 0;
            motor_data_width : natural := 8
         )  ;
        port (
            clock, reset : in std_logic;
            new_command : in std_logic;
            clock_timer : in std_logic;
            timer : in std_logic_vector(motor_data_width-1 downto 0);
            row, col : in std_logic_vector(row_col_width-1 downto 0);
            sel_data_registers : in std_logic_vector(1 downto 0);
            sel_input_data_registers : in std_logic_vector(1 downto 0);
            motor_data : in std_logic_vector(motor_data_width-1 downto 0);
            motor_up_data : in std_logic_vector(motor_data_width-1 downto 0);
            motor_left_data : in std_logic_vector(motor_data_width-1 downto 0);
            motor_data_out : out std_logic_vector(motor_data_width-1 downto 0);
            power_wave : out std_logic
        );
    end component;

begin

    -- Atribuição dos valores de command_data
    command <= reg_command_data_out(dataWidth-1 downto dataWidth-8);    -- Comando a ser executado
    row <= reg_command_data_out(dataWidth-9 downto dataWidth-16);       -- Número da linha (começa com 0, 1, 2, ..., n. 255 para todos)
    col <= reg_command_data_out(dataWidth-17 downto dataWidth-24);      -- Número da coluna (começa com 0, 1, 2, ..., n. 255 para todos)
    data <= reg_command_data_out(dataWidth-25 downto dataWidth-32);     -- Valor de potência
    
    -- Timer de timer_width bits
    timer_8_bits : timer_pwm
        generic map (
            N => 8
        )
        port map (
            clock => clock,
            timer => timer
        );
   gerador_delay : temporizador
        generic map (
            max_value_counter => 5000000 --5.000.000 -> 10 variations/decays every 1second
        )
        port map (
            clock => clock,
				reset => reset,
            clock_timer => clock_timer
        );
		  
    -- Registrador de comandos, dados, linha e coluna
    reg_command_data : register_data_width
        generic map (
            data_width => dataWidth
        )
        port map (
            clock => clock,
            reset => reset,
            enable => readwrite(0),
            inpt => writedata,
            outpt => reg_command_data_out
        );

    -- Registrador de status ainda não utilizado
    reg_status : register_data_width
        generic map (
            data_width => dataWidth
        )
        port map (
            clock => clock,
            reset => reset,
            enable => readwrite(1),
            inpt => reg_status_in,
            outpt => readdata
        );

    -- FSM de controle dos comandos
    commands_control : fsm_commands
        generic map (
            command_width => command_width,
            row_col_width => row_col_width,
            data_width => dataWidth,
            rows => rows,
            cols => cols
        )
        port map (
            clock => clock, 
            reset => reset,
            enable => enable,
            acknowledge => acknowledge,
            command => command,
            row => row,
            col => col,
            row_out => row_out,
            col_out => col_out,
            status => reg_status_in,
            sel_data_registers => sel_data_registers,
            sel_input_data_registers => sel_input_data_registers,
            command_done => interrupt,
            new_command => new_command
        );

    -- Todos os motores estão descritos abaixo.
    -- Foi necessário utilizar 4 for generates pois a primeira linha e a prmieira coluna recebe 0 na entrada dos motores anteriores.
    motor_0x0 : motor
        generic map(
               row_col_width => row_col_width,
               own_row => 0,
               own_col => 0,
               motor_data_width => motor_data_width
          )
          port map(
               clock => clock,
               reset => reset,
               new_command => new_command,
               clock_timer => clock_timer,
               timer => timer(motor_data_width-1 downto 0),
               row => row_out,
               col => col_out,
               sel_data_registers => sel_data_registers,
               sel_input_data_registers => sel_input_data_registers,
               motor_data => data,
               motor_up_data => (others => '0'),
               motor_left_data => (others => '0'),
               motor_data_out => motors_data(0),
               power_wave => motors_out(0)
          );

    motors_0xi : 
        for i in 1 to cols-1 generate
            n_motors_0xi : motor
                generic map(
                    row_col_width => row_col_width,
                    own_row => 0,
                    own_col => i,
                    motor_data_width => motor_data_width
                )
                port map(
                    clock => clock,
                    reset => reset,
                    new_command => new_command,
                    clock_timer => clock_timer,
                    timer => timer(motor_data_width-1 downto 0),
                    row => row_out,
                    col => col_out,
                    sel_data_registers => sel_data_registers,
                    sel_input_data_registers => sel_input_data_registers,
                    motor_data => data,
                    motor_up_data => (others => '0'),
                    motor_left_data => motors_data(i-1),
                    motor_data_out => motors_data(i),
                    power_wave => motors_out(i)
                );
        end generate;

    motors_ix0 : 
        for i in 1 to rows-1 generate
            n_motors_ix0 : motor
                generic map(
                    row_col_width => row_col_width,
                    own_row => i,
                    own_col => 0,
                    motor_data_width => motor_data_width
                )
                port map(
                    clock => clock,
                    reset => reset,
                    new_command => new_command,
                    clock_timer => clock_timer,
                    timer => timer(motor_data_width-1 downto 0),
                    row => row_out,
                    col => col_out,
                    sel_data_registers => sel_data_registers,
                    sel_input_data_registers => sel_input_data_registers,
                    motor_data => data,
                    motor_up_data => motors_data((i-1)*cols),
                    motor_left_data => (others => '0'),
                    motor_data_out => motors_data(i*cols),
                    power_wave => motors_out(i*cols)
                );
        end generate;

    motors_ixj : 
        for i in 1 to rows-1 generate
            i_motors_ixj : 
            for j in 1 to cols-1 generate
                j_motors_ixj : motor
                    generic map(
                        row_col_width => row_col_width,
                        own_row => i,
                        own_col => j,
                        motor_data_width => motor_data_width
                    )
                    port map(
                        clock => clock,
                        reset => reset,
                        new_command => new_command,
                        clock_timer => clock_timer,
                        timer => timer(motor_data_width-1 downto 0),
                        row => row_out,
                        col => col_out,
                        sel_data_registers => sel_data_registers,
                        sel_input_data_registers => sel_input_data_registers,
                        motor_data => data,
                        motor_up_data => motors_data((i-1)*cols + j),
                        motor_left_data => motors_data(i*cols + (j-1)),
                        motor_data_out => motors_data(i*cols + j),
                        power_wave => motors_out(i*cols + j)
                    );
            end generate;
        end generate;

end architecture; -- structural      