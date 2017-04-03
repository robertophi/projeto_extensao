library verilog;
use verilog.vl_types.all;
entity qsys_system_pll is
    port(
        CLOCK_50        : in     vl_logic;
        reset           : in     vl_logic;
        SDRAM_CLK       : out    vl_logic;
        sys_clk         : out    vl_logic;
        sys_reset_n     : out    vl_logic
    );
end qsys_system_pll;
