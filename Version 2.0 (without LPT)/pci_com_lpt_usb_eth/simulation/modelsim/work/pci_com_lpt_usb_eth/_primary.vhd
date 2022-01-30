library verilog;
use verilog.vl_types.all;
entity pci_com_lpt_usb_eth is
    port(
        I_CLK           : in     vl_logic;
        I_IDSEL         : in     vl_logic;
        \_I_FRAME\      : in     vl_logic;
        \_I_IRDY\       : in     vl_logic;
        \_I_RESET\      : in     vl_logic;
        I_CLK_DEV       : in     vl_logic;
        I_RX            : in     vl_logic;
        I_CTS           : in     vl_logic;
        I_CBE           : in     vl_logic_vector(3 downto 0);
        O_TX            : out    vl_logic;
        O_DTR           : out    vl_logic;
        O_PAR           : out    vl_logic;
        O_DEV0BAR4SEL   : out    vl_logic;
        O_DEV1BAR1SEL   : out    vl_logic;
        O_INT           : out    vl_logic;
        \_O_TRDY\       : inout  vl_logic;
        \_O_DEVSEL\     : inout  vl_logic;
        IO_AD           : inout  vl_logic_vector(31 downto 0)
    );
end pci_com_lpt_usb_eth;
