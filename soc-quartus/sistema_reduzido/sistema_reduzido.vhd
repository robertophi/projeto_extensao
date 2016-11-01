library ieee;
use ieee.std_logic_1164.all;

entity sistema_reduzido is
	port(
		clock_50 : in std_logic;
		ledr : out std_logic_vector(15 downto 0);
		pio_out_signal : out std_logic
	);
end entity sistema_reduzido;

architecture sistema_reduzido_arch of sistema_reduzido is	
	
	
	
	  component qsys_system_reduzido is
        port (
            clk_clk              : in  std_logic                     := 'X'; -- clk
            matriz_output_export : out std_logic_vector(15 downto 0);        -- export
            uart_output_rxd      : in  std_logic                     := 'X'; -- rxd
            uart_output_txd      : out std_logic                             -- txd
        );
    end component qsys_system_reduzido;
	 
	 
	 
	 
	 signal saida_matriz_motores : std_logic_vector(15 downto 0);
	 signal tx_nao_utilizado, rx_nao_utilizado : std_logic;
	 
	 
	
begin		
	
	
    u0 : component qsys_system_reduzido
        port map (
            clk_clk              => clock_50,              --           clk.clk
            matriz_output_export => saida_matriz_motores,  -- matriz_output.export
            uart_output_rxd      => rx_nao_utilizado,      --   uart_output.rxd
            uart_output_txd      => tx_nao_utilizado       --              .txd
        );
		  
		  
		  
	ledr(15 downto 0) <= saida_matriz_motores(15 downto 0);
	
end architecture sistema_reduzido_arch;