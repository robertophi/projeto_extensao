library verilog;
use verilog.vl_types.all;
entity qsys_system_esp8266_tx is
    port(
        baud_divisor    : in     vl_logic_vector(8 downto 0);
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        do_force_break  : in     vl_logic;
        reset_n         : in     vl_logic;
        tx_data         : in     vl_logic_vector(7 downto 0);
        tx_wr_strobe    : in     vl_logic;
        tx_ready        : out    vl_logic;
        tx_shift_empty  : out    vl_logic;
        txd             : out    vl_logic
    );
end qsys_system_esp8266_tx;
