library verilog;
use verilog.vl_types.all;
entity altpll0 is
    port(
        inclk0          : in     vl_logic;
        c0              : out    vl_logic;
        c1              : out    vl_logic
    );
end altpll0;
