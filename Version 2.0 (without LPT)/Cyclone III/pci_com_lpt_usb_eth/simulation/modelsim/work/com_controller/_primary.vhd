library verilog;
use verilog.vl_types.all;
entity com_controller is
    port(
        I_CLK_BUS       : in     vl_logic;
        I_CLK_DEV       : in     vl_logic;
        \_I_RESET\      : in     vl_logic;
        I_OE_WE_DEV     : in     vl_logic;
        I_RX            : in     vl_logic;
        I_CTS           : in     vl_logic;
        I_DEVSEL        : in     vl_logic;
        I_ADDR          : in     vl_logic_vector(31 downto 0);
        I_BE            : in     vl_logic_vector(3 downto 0);
        O_PAR           : out    vl_logic;
        O_INTX          : out    vl_logic;
        O_TX            : out    vl_logic;
        O_DTR           : out    vl_logic;
        O_DEVRDY        : out    vl_logic;
        IO_AD           : inout  vl_logic_vector(31 downto 0);
        baudclk         : out    vl_logic
    );
end com_controller;
