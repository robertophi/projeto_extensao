library verilog;
use verilog.vl_types.all;
entity qsys_system_nios2_nios2_oci_fifocount_inc is
    port(
        empty           : in     vl_logic;
        free2           : in     vl_logic;
        free3           : in     vl_logic;
        tm_count        : in     vl_logic_vector(1 downto 0);
        fifocount_inc   : out    vl_logic_vector(4 downto 0)
    );
end qsys_system_nios2_nios2_oci_fifocount_inc;
