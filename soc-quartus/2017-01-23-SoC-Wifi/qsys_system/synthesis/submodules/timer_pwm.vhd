library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Timer genérico de N bits que conta até o máximo e cria um clock com período de um timer e duty 50%
entity timer_pwm is
    generic (
        N : natural := 8;                          -- Tamanho do timer. Conta sempre até o final
        DIVIDER : natural := 1
    );
    port (
        clock : in std_logic;
        timer : out std_logic_vector(N-1 downto 0) -- Valor de saída com o tempo atual, funcionando como um timer de um microprocessador.
    );
end entity ; -- timer_N_bits


architecture behavioral of timer_pwm is

    signal current_timer, next_timer : std_logic_vector(N-1 downto 0) := (others => '0');   -- Estados de tempo atual e próximo tempo
    constant max_timer : std_logic_vector(N-1 downto 0) := (others => '1');                 -- Tempo máximo de contagem
    signal counter : integer := 0;
    signal clock_divided : std_logic := '0';

 begin
    
    timer <= current_timer;

    
    frequency_divider:
      process(clock)
      begin
	if rising_edge(clock) then
	  if(counter >= DIVIDER) then
	    clock_divided <= NOT(clock_divided);
	    counter <= 0;
	  else
	    counter <= counter + 1;
	  end if;
	  
	end if;
      end process;
      
    memory_element :
        process(clock_divided)
        begin
            if rising_edge(clock_divided) then
                current_timer <= next_timer;
            end if;
        end process;
    
    -- Sempre soma 1 no next_timer até chegar ao máximo e zerar
    next_state_logic : 
        next_timer <= (others => '0') when (current_timer = max_timer) else
                      std_logic_vector(unsigned(current_timer) + 1);
    
    

end architecture ; -- behavioral