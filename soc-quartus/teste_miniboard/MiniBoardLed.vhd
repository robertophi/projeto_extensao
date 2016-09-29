-- Quartus II VHDL Template
-- Basic Shift Register

library ieee;
use ieee.std_logic_1164.all;

entity miniBoardLed is

	generic
	(
		max_value_counter : integer := 10000000
	);

	port 
	(
		clock		: in std_logic;
		reset	: in std_logic; --Quando aperta o reset, ele vai pra zero
		output	: out std_logic_vector(7 downto 0)
	);

end entity;

architecture topFileArch of miniBoardLed is

	    signal current_timer, next_timer : integer := 0;   -- Estados de tempo atual e próximo tempo
		 signal led : std_logic_vector(2 downto 0):="000";
begin
    

    memory_element :
        process(clock)
        begin
				
            if rising_edge(clock) then
                current_timer <= next_timer;
            end if;
        end process;
    
    -- Sempre soma 1 no next_timer até chegar ao máximo e zerar
        next_timer <= 0 when (current_timer >= max_value_counter) or (current_timer<0) else
                      current_timer + 1;
    
 changeLed:
	 process(clock,current_timer)
	 begin
		if current_timer>5000000 then
		led <= (others=>'0');
		else
		led<=(others=>'1');
		end if;

	end process;
	--Led_out(2~1~0) - pins 9 7 3
	output(0) <= reset;
	output(7 downto 1) <= (others=>led(1));
	 

end topFileArch;
