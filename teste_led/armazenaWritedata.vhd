library ieee;
use ieee.std_logic_1164.all;

entity armazenaWritedata is
	generic (
		rows : positive := 4;
		cols : positive := 8;
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
end entity armazenaWritedata;

architecture armazenaWritedata_arch of armazenaWritedata is

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
	 
	 signal from_data_reg: std_logic_vector(data_width-1 downto 0);
	 signal enable: std_logic;
	 
begin

	-- reg para salvar o comando + mais controle
	armazenaWritedata: reg
		generic map (
			data_width => 32
		)
		port map(
			clock => clock,
			reset_n => reset_n,
			enable => enable,
			d => writedata,
			q => from_data_reg
		);
	enable <= readwrite(0);
	
    storedData <= from_data_reg;
    
    
	

end architecture armazenaWritedata_arch;