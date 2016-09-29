library ieee;
use ieee.std_logic_1164.all;

entity SystemExample is
	port(
		clock_50 : in std_logic;
		ledr : out std_logic_vector(15 downto 0)
	);
end entity SystemExample;

architecture SystemExample_arch of SystemExample is
	signal pwm_output : std_logic_vector(15 downto 0);
	 component QsysSystemExample is
        port (
            clk_clk           : in  std_logic                     := 'X'; 
            pwm_output_export : out std_logic_vector(15 downto 0)         
        );
    end component QsysSystemExample;
	
	
begin		
	systemPortMap: component QsysSystemExample
        port map (
            clk_clk           => clock_50,           
            pwm_output_export => pwm_output  
        );
	ledr(15 downto 0) <= pwm_output(15 downto 0);
	
end architecture SystemExample_arch;