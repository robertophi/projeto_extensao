     
     
library ieee;
use ieee.std_logic_1164.all;

entity FFT_dummy_interface is

	port (
		-- clock and reset
		csi_csink_clock : in std_logic;
		rsi_rsink_resetn : in std_logic;
		
		-- avalon slave
		avs_aslave_read : in std_logic; 
		avs_aslave_write : in std_logic;
		avs_aslave_address : in std_logic;
		avs_aslave_writedata : in std_logic_vector(31 downto 0);
		avs_aslave_readdata : out std_logic_vector(31 downto 0)
		
	);
end entity FFT_dummy_interface;

architecture FFT_dummy_interface_arch of FFT_dummy_interface is
signal data : std_logic_vector(31 downto 0);
begin




registrador: 
process(csi_csink_clock,rsi_rsink_resetn)
begin
    if(rsi_rsink_resetn='0') then
	data <= (others=>'0');
    elsif rising_edge(csi_csink_clock) then
	if avs_aslave_write = '1' then
	    data <= avs_aslave_writedata;
	end if;
    end if;    
end process;

avs_aslave_readdata <= data;

    
    
		
	
end architecture FFT_dummy_interface_arch;