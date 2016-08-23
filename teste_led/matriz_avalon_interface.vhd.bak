library ieee;
use ieee.std_logic_1164.all;

entity matriz_avalon_interface is
	generic (
		rows : positive := 4;
		cols : positive := 8;
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
	
	component armazenaWritedata
	generic (
		rows : positive := 4;
		cols : positive := 4;
		data_width : positive := 32
	);
	port (
		clock : in std_logic;
		reset_n : in std_logic;
		
		readwrite : in std_logic_vector(1 downto 0);
		address : in std_logic;
		readdata : out std_logic_vector(data_width-1 downto 0);
		writedata : in std_logic_vector(data_width-1 downto 0);
		
		storedData : out std_logic_vector(data_width-1 downto 0)
	);
	end component MotorMatrixControl;
	
	signal readwrite : std_logic_vector(1 downto 0);
begin
	
    
    
	-- matriz
	armazenadorWritedata : armazenaWritedata
		generic map (
			rows => 4,
			cols => 4,
			dataWidth => 32
		)
		port map (
			 clock => csi_csink_clock,
             reset_n => rsi_rsink_resetn,
             readwrite => readwrite,
             address => avs_aslave_address,
             readdata =>  avs_aslave_readdata,
             writedata => avs_aslave_writedata
             storedData => coe_pwms_export
		);

	-- logica
	readwrite <= avs_aslave_read & avs_aslave_write;
	
end architecture matriz_avalon_interface_arch;