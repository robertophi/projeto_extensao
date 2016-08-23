library verilog;
use verilog.vl_types.all;
entity qsys_system_esp8266_rxfifo is
    port(
        clk             : in     vl_logic;
        d1_rx_fifo_rd_strobe: in     vl_logic;
        d1_rx_rd_strobe : in     vl_logic;
        in_rx_data      : in     vl_logic_vector(7 downto 0);
        reset           : in     vl_logic;
        rx_data_b       : out    vl_logic_vector(7 downto 0);
        rx_empty        : out    vl_logic;
        rx_full         : out    vl_logic;
        rx_used         : out    vl_logic_vector(9 downto 0)
    );
end qsys_system_esp8266_rxfifo;
