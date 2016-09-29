library verilog;
use verilog.vl_types.all;
entity qsys_system_esp8266_txfifo is
    port(
        clk             : in     vl_logic;
        d1_tx_wr_strobe : in     vl_logic;
        reset           : in     vl_logic;
        tx_fifo_wr_strobe: in     vl_logic;
        writedata       : in     vl_logic_vector(31 downto 0);
        tx_empty        : out    vl_logic;
        tx_fifo_q       : out    vl_logic_vector(7 downto 0);
        tx_full         : out    vl_logic;
        tx_used         : out    vl_logic_vector(9 downto 0)
    );
end qsys_system_esp8266_txfifo;
