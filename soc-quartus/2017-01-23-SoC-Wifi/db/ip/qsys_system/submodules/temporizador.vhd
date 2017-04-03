library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity temporizador is
    generic (
        max_value_counter : natural := 10000000                           
    );
    port (
        clock, reset : in std_logic;
        clock_timer : out std_logic                
    );
end entity ; -- temporizador


architecture behavioral of temporizador is

    signal current_timer, next_timer : integer := 0;   -- Estados de tempo atual e próximo tempo

begin
    

    memory_element :
        process(clock)
        begin
				if reset = '1' then
					current_timer <= 0;
            elsif rising_edge(clock) then
                current_timer <= next_timer;
            end if;
        end process;
    
    -- Sempre soma 1 no next_timer até chegar ao máximo e zerar
    next_state_logic : 
        next_timer <= 0 when (current_timer = max_value_counter) else
                      current_timer + 1;
    
    -- Coloca o valor em 1 durante metade do tempo e zero no resto
    output_logic :
        clock_timer <= '1' when (current_timer = max_value_counter) else
                       '0';

end architecture ; -- behavioral