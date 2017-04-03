library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Registrador geral de data_width bits com enable e reset assíncrono
entity register_data_width is
    generic (
        data_width : natural := 32
    );
    port (
        clock, reset : in std_logic;
        enable : in std_logic;
        inpt : in std_logic_vector(data_width-1 downto 0);
        outpt : out std_logic_vector(data_width-1 downto 0)
    );
end entity; -- register_data_width


architecture behavioral of register_data_width is

    signal current_state_reg, next_state_reg : std_logic_vector(data_width-1 downto 0);

begin

    -- Elemento de memória
    process(clock, reset)
    begin
        if (reset = '1') then
            current_state_reg <= (others => '0');
        elsif (rising_edge(clock)) then
            current_state_reg <= next_state_reg;
        end if;
    end process;

    -- Lógica de próximo estado
    next_state_reg <= inpt when (enable = '1') else
                      current_state_reg;

    -- Lógica de saída
    outpt <= current_state_reg;

end architecture; -- behavioral