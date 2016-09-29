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
		
		-- sdram
		dram_clk : out std_logic;
		dram_cke : out std_logic;
		dram_addr : out std_logic_vector(11 downto 0);
		dram_ba_0 : buffer std_logic;
		dram_ba_1 : buffer std_logic;
		dram_cs_n : out std_logic;
		dram_cas_n : out std_logic;
		dram_ras_n : out std_logic;
		dram_we_n : out std_logic;
		dram_dq : inout std_logic_vector(15 downto 0);
		dram_udqm : buffer std_logic;
		dram_ldqm : buffer std_logic
	);
end entity SoC;

architecture SoC_arch of SoC is
	component qsys_system
		port (
			clk_clk : in std_logic;
			
			-- sdram
			sdram_clk_clk : out std_logic;
			sdram_wire_addr : out std_logic_vector(11 downto 0);
			sdram_wire_ba : buffer std_logic_vector(1 downto 0);
			sdram_wire_cas_n : out std_logic;
			sdram_wire_cke : out std_logic;
			sdram_wire_cs_n : out std_logic;
			sdram_wire_dq : inout std_logic_vector(15 downto 0);
			sdram_wire_dqm : buffer std_logic_vector(1 downto 0);
			sdram_wire_ras_n : out std_logic;
			sdram_wire_we_n : out std_logic;
			
			-- matriz
			pwms_export : out std_logic_vector(15 downto 0);
			
			-- wifi
			esp8266_rxd : in std_logic;
         esp8266_txd : out std_logic
		);
	end component qsys_system;
	
	-- sdram
	signal dqm : std_logic_vector(1 downto 0);
	signal ba : std_logic_vector(1 downto 0);
	--Wi_fi modulo
	signal wifi_tx, wifi_rx : std_logic;
	-- pwms
	signal pwms : std_logic_vector(15 downto 0);
begin
	
	-- sdram
	dram_ba_0 <= ba(0);
	dram_ba_1 <= ba(1);
	dram_ldqm <= dqm(0);
	
	system : qsys_system
		port map(
			clk_clk => clock_50,
			
			-- sdram
			sdram_clk_clk => dram_clk,
			sdram_wire_addr => dram_addr,
			sdram_wire_ba => ba,
			sdram_wire_cas_n => dram_cas_n,
			sdram_wire_cke => dram_cke,
			sdram_wire_cs_n => dram_cs_n,
			sdram_wire_dq => dram_dq,
			sdram_wire_dqm => dqm,
			sdram_wire_ras_n => dram_ras_n,
			sdram_wire_we_n => dram_we_n,
			
			-- matriz
			pwms_export => pwms,
			
	
			
			-- wifi
			esp8266_rxd => gpio_1(0),
			esp8266_txd => gpio_1(1)
		);
	
	ledr(15 downto 0) <= pwms(15 downto 0);
	
end architecture SoC_arch;