library verilog;
use verilog.vl_types.all;
entity qsys_system_esp8266_rx_stimulus_source is
    port(
        baud_divisor    : in     vl_logic_vector(8 downto 0);
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        reset_n         : in     vl_logic;
        rx_char_ready   : in     vl_logic;
        rxd             : in     vl_logic;
        source_rxd      : out    vl_logic
    );
end qsys_system_esp8266_rx_stimulus_source;
