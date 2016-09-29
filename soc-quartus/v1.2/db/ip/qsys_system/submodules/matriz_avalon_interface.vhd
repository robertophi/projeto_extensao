library ieee;
use ieee.std_logic_1164.all;

entity matriz_avalon_interface is
	generic (
		rows : positive := 4;
		cols : positive := 4;
		data_width : positive := 32
	);
	port (
		-- clock and reset
		csi_csink_clock : in std_logic;
		rsi_rsink_resetn : in std_logic;
		
		-- avalon slave
		avs_aslave_read : in std_logic;
		avs_aslave_write : in std_logic;
		avs_aslave_address : in std_logic;
		avs_aslave_writedata : in std_logic_vector(data_width-1 downto 0);
		avs_aslave_readdata : out std_logic_vector(data_width-1 downto 0);
		
		-- export
		coe_pwms_export : out std_logic_vector((rows*cols)-1 downto 0)
	);
end entity matriz_avalon_interface;

architecture matriz_avalon_interface_arch of matriz_avalon_interface is
	
	component MotorMatrixControl
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
	end component MotorMatrixControl;
	
	signal readwrite : std_logic_vector(1 downto 0);
	signal data : std_logic_vector(data_width-1 downto 0);
	signal acknowledge, test, bistIn, interrupt, bistOut : std_logic;
	signal enable : std_logic_vector(2 downto 0):=(others=>'0');
	begin
	
    
    acknowledge <= '1';
    bistIn <= '0';
    test <= '0';
	-- matriz
	matriz_inst : MotorMatrixControl
		generic map (
			rows => 4,
			cols => 4,
			dataWidth => 32
		)
		port map (
				clock => csi_csink_clock, --ok
				reset => not(rsi_rsink_resetn), --ok
				enable => enable(2), --?????
				acknowledge => acknowledge,
            test => test,
            bistIn => bistIn,
            readwrite => readwrite, --ok
            writedata => avs_aslave_writedata, --ok
            readdata => avs_aslave_readdata, --ok
            interrupt => interrupt,
            bistOut => bistOut,
            motors_out => coe_pwms_export 
		);
	
	-- logica
	readwrite <= avs_aslave_read & avs_aslave_write;
	--Sinal enable que avisa para o motormatrixControl que ha um novo comando
	--´E o sinal avs_aslave_write com um delay de alguns ciclos ( 2 )
	enableProcess:
	process(csi_csink_clock,avs_aslave_write)
	begin
		if rising_edge(csi_csink_clock) then
			enable <= enable(1 downto 0) & avs_aslave_write;			
		end if;
	end process;
end architecture matriz_avalon_interface_arch;