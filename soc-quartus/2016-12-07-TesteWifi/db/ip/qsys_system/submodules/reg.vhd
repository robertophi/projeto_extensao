library ieee;
use ieee.std_logic_1164.all;

entity reg is
	generic (
		data_width : positive := 32
	);
	port(
		clock : in std_logic;
		reset_n : in std_logic;
		enable: in std_logic;
		d : in std_logic_vector(data_width-1 downto 0);
		q : out std_logic_vector(data_width-1 downto 0) );
end entity reg;

architecture reg_arch of reg is
begin
    process
    begin
        wait until clock'event and clock='1';
        if reset_n = '0' then
            q <= (others=>'0');
        elsif enable = '1' then
            q <= d;
        end if;
    end process;
end architecture reg_arch;
