library verilog;
use verilog.vl_types.all;
entity Block1 is
    port(
        clk             : in     vl_logic;
        irdy            : in     vl_logic;
        frame           : in     vl_logic;
        idsel           : in     vl_logic;
        reset           : in     vl_logic;
        intd            : in     vl_logic;
        RX1             : in     vl_logic;
        CTS             : in     vl_logic;
        intc            : in     vl_logic;
        intb            : in     vl_logic;
        ACK             : in     vl_logic;
        BUSY            : in     vl_logic;
        PE              : in     vl_logic;
        SELT            : in     vl_logic;
        ERR             : in     vl_logic;
        baudclk_221184kHz: in     vl_logic;
        cbe             : in     vl_logic_vector(3 downto 0);
        led2            : out    vl_logic;
        TX1             : out    vl_logic;
        RTS             : out    vl_logic;
        inta            : out    vl_logic;
        RS422_TX_MINUS  : out    vl_logic;
        par             : inout  vl_logic;
        trdy            : inout  vl_logic;
        devsel          : inout  vl_logic;
        STROBE          : inout  vl_logic;
        SIN             : inout  vl_logic;
        AFD             : inout  vl_logic;
        INIT            : inout  vl_logic;
        ad              : inout  vl_logic_vector(31 downto 0);
        LPT_DATA        : inout  vl_logic_vector(7 downto 0)
    );
end Block1;
