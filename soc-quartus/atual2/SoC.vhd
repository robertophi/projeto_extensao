library ieee;
use ieee.std_logic_1164.all;

entity SoC is
	port(
		-- de2
		clock_50 : in std_logic;
		ledg : out std_logic_vector(8 downto 0);
		ledr : out std_logic_vector(17 downto 0);
		gpio_1 : inout std_logic_vector(1 downto 0);
		sw : in std_logic_vector(17 downto 0);
		FAN_CTRL : out std_logic
		
	);
end entity SoC;

architecture SoC_arch of SoC is
   component qsys_system is
        port (
            clk_clk     : in  std_logic                     := 'X'; -- clk
            esp8266_rxd : in  std_logic                     := 'X'; -- rxd
            esp8266_txd : out std_logic;                            -- txd
            pwms_export : out std_logic_vector(15 downto 0)         -- export
        );
    end component qsys_system;
	
	--Wi_fi modulo
	signal wifi_tx, wifi_rx : std_logic;
	-- pwms
	signal pwms : std_logic_vector(15 downto 0);
begin
	
	
	FAN_CTRL <= '0';
	
	system : qsys_system
		port map(
			clk_clk => clock_50,
			
	
			-- wifi
			esp8266_rxd => gpio_1(0),
			esp8266_txd => gpio_1(1),
			-- matriz
			pwms_export => pwms
			
	
			
			
		);
	
	ledr(15 downto 0) <= pwms(15 downto 0);
	
end architecture SoC_arch;