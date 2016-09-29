library verilog;
use verilog.vl_types.all;
entity qsys_system_esp8266_rx is
    port(
        baud_divisor    : in     vl_logic_vector(8 downto 0);
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        reset_n         : in     vl_logic;
        rx_rd_strobe    : in     vl_logic;
        rxd             : in     vl_logic;
        status_wr_strobe: in     vl_logic;
        break_detect    : out    vl_logic;
        framing_error   : out    vl_logic;
        parity_error    : out    vl_logic;
        rx_char_ready   : out    vl_logic;
        rx_data         : out    vl_logic_vector(7 downto 0);
        rx_overrun      : out    vl_logic
    );
end qsys_system_esp8266_rx;
