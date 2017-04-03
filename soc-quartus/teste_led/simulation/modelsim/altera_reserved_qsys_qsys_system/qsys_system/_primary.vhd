library verilog;
use verilog.vl_types.all;
entity qsys_system is
    port(
        clk_clk         : in     vl_logic;
        sdram_wire_addr : out    vl_logic_vector(11 downto 0);
        sdram_wire_ba   : out    vl_logic_vector(1 downto 0);
        sdram_wire_cas_n: out    vl_logic;
        sdram_wire_cke  : out    vl_logic;
        sdram_wire_cs_n : out    vl_logic;
        sdram_wire_dq   : inout  vl_logic_vector(15 downto 0);
        sdram_wire_dqm  : out    vl_logic_vector(1 downto 0);
        sdram_wire_ras_n: out    vl_logic;
        sdram_wire_we_n : out    vl_logic;
        sdram_clk_clk   : out    vl_logic;
        pwms_export     : out    vl_logic_vector(31 downto 0);
        esp8266_rxd     : in     vl_logic;
        esp8266_txd     : out    vl_logic
    );
end qsys_system;
