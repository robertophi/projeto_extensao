-- Quartus II VHDL Template
-- Signed Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testeWifi is
	port 
	(
		reset,clock	   : in std_logic;
		wifi_rx	   : in std_logic;
		wifi_tx : out std_logic;
		leds : out std_logic_vector(31 downto 0)
	);

end entity;

architecture arch of testeWifi is
component wifiSystem is
        port (
            clk_clk           : in  std_logic                     := 'X'; -- clk
            reset_reset_n     : in  std_logic                     := 'X'; -- reset_n
            output_pio_export : out std_logic_vector(31 downto 0);        -- export
            output_uart_rxd   : in  std_logic                     := 'X'; -- rxd
            output_uart_txd   : out std_logic                             -- txd
        );
    end component wifiSystem;
begin

    

    u0 : component wifiSystem
        port map (
            clk_clk           => clock,           --         clk.clk
            reset_reset_n     => reset,     --       reset.reset_n
            output_pio_export => leds, --  output_pio.export
            output_uart_rxd   => wifi_rx,   -- output_uart.rxd
            output_uart_txd   => wifi_tx    --            .txd
        );


end arch;
