library ieee;
use ieee.std_logic_1164.all;

entity testeWifi is
	port(
		-- de2i-150
		clock_50 : in std_logic;
		ledg : out std_logic_vector(8 downto 0);
		ledr : out std_logic_vector(17 downto 0);
		sw : in std_logic_vector(17 downto 0);
		GPIOGPIO : inout std_logic_vector(35 downto 0);

		FAN_CTRL : out std_logic
		
	);
end entity testeWifi;

architecture testeWifi_arch of testeWifi is

-----------------------------------------
--Component declaration
   component qsys_system is
        port (
            clk_clk       : in  std_logic                     := 'X'; -- clk
            pwms_export   : out std_logic_vector(31 downto 0);        -- export
            uart_wifi_rxd : in  std_logic                     := 'X'; -- rxd
            uart_wifi_txd : out std_logic                             -- txd
        );
    end component qsys_system;
-----------------------------------------


	--Wifi signals
	signal wifi_tx, wifi_rx : std_logic;
	-- Motor Matrix Control export signal => pwms
	signal pwms : std_logic_vector(31 downto 0);

	
begin
	
	
	FAN_CTRL <= '0';
	
	
	------------------------------------------
	--Component port map
	system : qsys_system
		port map(
			clk_clk => clock_50,
			
			-- matriz
			pwms_export => pwms,
			-- wifi
			uart_wifi_rxd => wifi_rx, -- uart_wifi.rxd
			uart_wifi_txd => wifi_tx  --  uart txd
			
		);
	------------------------------------------
	
		

	ledr(0) <= wifi_tx;
	ledr(1) <= wifi_rx;
   
	wifi_rx <= GPIOGPIO(13); --wifi
	GPIOGPIO(15) <= wifi_tx; --wifi	
	
	
	
	
end architecture testeWifi_arch;