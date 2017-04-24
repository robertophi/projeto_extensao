

library ieee;
use ieee.std_logic_1164.all;

entity SoC is
	port(
		-- de2i-150
		clock_50 : in std_logic;
		ledg : out std_logic_vector(8 downto 0);
		ledr : out std_logic_vector(17 downto 0);
		sw : in std_logic_vector(17 downto 0);
		GPIOGPIO : inout std_logic_vector(35 downto 0);
		FAN_CTRL : out std_logic
		
	);
end entity SoC;

architecture SoC_arch of SoC is

-----------------------------------------
--Component declaration
   component qsys_system is
        port (
            clk_clk     : in  std_logic                     := 'X'; -- clk
            esp8266_rxd : in  std_logic                     := 'X'; -- rxd
            esp8266_txd : out std_logic;                            -- txd
            pwms_export : out std_logic_vector(31 downto 0)         -- export
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
			-- wifi
			esp8266_rxd => wifi_rx,
			esp8266_txd => wifi_tx,
			-- matriz
			pwms_export => pwms
		);
	------------------------------------------
	
		

	ledr(17 downto 0) <= pwms(17 downto 0);
	ledg(7 downto 0)<= pwms(31 downto 24);
										
										
										
	--Mapping of MatrizControl to GPIO
	--M[LINHA][COLUNA]
	
	
	

	GPIOGPIO(0) <= pwms(28); --m34
	GPIOGPIO(1) <= pwms(22); --m26
	GPIOGPIO(2) <= pwms(31); --m37
	GPIOGPIO(3) <= pwms(20); --m24 
	GPIOGPIO(4) <= pwms(30); --m36
	GPIOGPIO(5) <= pwms(15); --m17
	GPIOGPIO(6) <= pwms(29); --m35
	GPIOGPIO(7) <= pwms(14); --m16

	GPIOGPIO(8) <= pwms(23);   --m27
	GPIOGPIO(9) <= pwms(13);   --m15
	GPIOGPIO(10) <= pwms(21); --m25
	GPIOGPIO(11) <= pwms(12); --m14
	GPIOGPIO(13) <= pwms(7); --m07
	GPIOGPIO(15) <= pwms(6); --m06
	GPIOGPIO(17) <= pwms(5); --m05
	GPIOGPIO(19) <= pwms(4); --m04

	
	GPIOGPIO(20) <= pwms(3); --m03
	GPIOGPIO(21) <= pwms(2); --m02
	GPIOGPIO(22) <= pwms(1); --m01
	GPIOGPIO(23) <= pwms(0); --m00
	GPIOGPIO(24) <= pwms(11); --m13
	GPIOGPIO(25) <= pwms(10); --m12
	GPIOGPIO(26) <= pwms(9); --m11
	GPIOGPIO(27) <= pwms(8); --m10

	GPIOGPIO(28) <= pwms(19); --m23
	GPIOGPIO(29) <= pwms(18); --m22
	GPIOGPIO(30) <= pwms(16); --m20
	GPIOGPIO(31) <= pwms(17); --m21
	GPIOGPIO(32) <= pwms(27); --m33
	GPIOGPIO(33) <= pwms(26); --m32
	GPIOGPIO(34) <= pwms(25); --m31
	GPIOGPIO(35) <= pwms(24); --m30




	GPIOGPIO(12) <= wifi_tx; --GPIO conectado ao RX do modulo wifi
	GPIOGPIO(14) <= '1';     --GPIO conectado ao RST do modulo wifi
	GPIOGPIO(16) <= '1';     --GPIO conectado ao EN do modulo wifi
	wifi_rx <= GPIOGPIO(18); --GPIO conectado ao TX do modulo wifi
	
	
	
end architecture SoC_arch;
