library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Timer genérico de N bits que conta até o máximo e cria um clock com período de um timer e duty 50%
entity timer_N_bits is
    generic (
        N : natural := 20                           -- Tamanho do timer. Conta sempre até o final
    );
    port (
        clock : in std_logic;
        timer : out std_logic_vector(N-1 downto 0); -- Valor de saída com o tempo atual, funcionando como um timer de um microprocessador.
        clock_timer : out std_logic                 -- Clock de saída com período de um timer e duty 50%.
    );
end entity ; -- timer_N_bits


architecture behavioral of timer_N_bits is

    signal current_timer, next_timer : std_logic_vector(N-1 downto 0) := (others => '0');   -- Estados de tempo atual e próximo tempo
    constant max_timer : std_logic_vector(N-1 downto 0) := (others => '1');                 -- Tempo máximo de contagem
    constant half_timer : std_logic_vector(N-1 downto 0) := (N-1 => '0', others => '1');    -- Meio período para criar o clock

begin
    
    timer <= current_timer;

    memory_element :
        process(clock)
        begin
            if rising_edge(clock) then
                current_timer <= next_timer;
            end if;
        end process;
    
    -- Sempre soma 1 no next_timer até chegar ao máximo e zerar
    next_state_logic : 
        next_timer <= (others => '0') when (current_timer = max_timer) else
                      std_logic_vector(unsigned(current_timer) + 1);
    
    -- Coloca o valor em 1 durante metade do tempo e zero no resto
    output_logic :
        clock_timer <= '1' when (current_timer >= half_timer) else
                       '0';

end architecture ; -- behavioral