library ieee;
use ieee.std_logic_1164.all;

entity matriz is
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
		
		pwms : out std_logic_vector((rows*cols)-1 downto 0)
	);
end entity matriz;

architecture matriz_arch of matriz is

	component reg
		generic (
			data_width : positive := 32
		);
		port (
			clock : in std_logic;
			reset_n : in std_logic;
			enable: in std_logic;
			d : in std_logic_vector(data_width-1 downto 0);
			q : out std_logic_vector(data_width-1 downto 0)
		);
    end component;
	 
	 signal to_data_reg: std_logic_vector(data_width-1 downto 0);
	 signal from_data_reg: std_logic_vector(data_width-1 downto 0);
	 signal status: std_logic_vector(data_width-1 downto 0);
	 signal enable: std_logic;
	 
begin

	-- reg para salvar o comando + mais controle
	data_reg: reg
		generic map (
			data_width => 32
		)
		port map(
			clock => clock,
			reset_n => reset_n,
			enable => enable,
			d => to_data_reg,
			q => from_data_reg
		);
	enable <= readwrite(0);
	
	-- um status que depende do data_reg
	status <= from_data_reg(data_width-2 downto 0) & '0'; -- multiplica o data_reg por 2
	
	-- export para testes
	pwms(cols-1 downto 0) <= from_data_reg(cols-1 downto 0);
	pwms((cols*2)-1 downto cols) <= status(cols-1 downto 0);
	
	-- logica de enderecamento
	with address select to_data_reg <=
		writedata when '0',
		from_data_reg when '1';
	with address select readdata <=
		status when '1',
		from_data_reg when '0';

end architecture matriz_arch;