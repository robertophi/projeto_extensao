library verilog;
use verilog.vl_types.all;
entity qsys_system_esp8266 is
    port(
        address         : in     vl_logic_vector(3 downto 0);
        begintransfer   : in     vl_logic;
        chipselect      : in     vl_logic;
        clk             : in     vl_logic;
        keep            : in     vl_logic;
        read_n          : in     vl_logic;
        reset_n         : in     vl_logic;
        rxd             : in     vl_logic;
        synthesis       : in     vl_logic;
        write_n         : in     vl_logic;
        writedata       : in     vl_logic_vector(31 downto 0);
        dataavailable   : out    vl_logic;
        gap_detect      : out    vl_logic;
        gap_timeout     : out    vl_logic;
        irq             : out    vl_logic;
        readdata        : out    vl_logic_vector(31 downto 0);
        readyfordata    : out    vl_logic;
        txd             : out    vl_logic
    );
end qsys_system_esp8266;
