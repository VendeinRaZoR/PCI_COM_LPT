library verilog;
use verilog.vl_types.all;
entity LPT_controller_82550 is
    generic(
        TRDY_DELAY      : integer := 0;
        LPTF_RESET      : integer := 0;
        LPTF_IDLE       : integer := 1;
        LPTF_PIR_READ   : integer := 2;
        LPTF_PDR_WRITE  : integer := 3;
        LPTF_PSR_READ   : integer := 4;
        LPTF_PCR_READ   : integer := 5;
        LPTF_PCR_WRITE  : integer := 6;
        LPTF_PXR_READ   : integer := 7;
        LPTF_PXR_WRITE  : integer := 8
    );
    port(
        clk             : in     vl_logic;
        irdy            : in     vl_logic;
        reset           : in     vl_logic;
        ACK             : in     vl_logic;
        BUSY            : in     vl_logic;
        PE              : in     vl_logic;
        SELT            : in     vl_logic;
        AFD             : out    vl_logic;
        ERR             : in     vl_logic;
        INIT            : out    vl_logic;
        SIN             : out    vl_logic;
        data            : out    vl_logic_vector(7 downto 0);
        STROBE          : out    vl_logic;
        in_addr_bar_offset_w_io: in     vl_logic_vector(7 downto 0);
        is_LPT_configured: in     vl_logic;
        is_LPT_iospace  : in     vl_logic;
        addr_data_buf_in_byte: in     vl_logic_vector(7 downto 0);
        in_command      : in     vl_logic_vector(3 downto 0);
        devsel          : out    vl_logic;
        trdy            : out    vl_logic;
        par             : out    vl_logic;
        interrupt_pin   : out    vl_logic;
        control         : out    vl_logic;
        out_add_data_io : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TRDY_DELAY : constant is 1;
    attribute mti_svvh_generic_type of LPTF_RESET : constant is 1;
    attribute mti_svvh_generic_type of LPTF_IDLE : constant is 1;
    attribute mti_svvh_generic_type of LPTF_PIR_READ : constant is 1;
    attribute mti_svvh_generic_type of LPTF_PDR_WRITE : constant is 1;
    attribute mti_svvh_generic_type of LPTF_PSR_READ : constant is 1;
    attribute mti_svvh_generic_type of LPTF_PCR_READ : constant is 1;
    attribute mti_svvh_generic_type of LPTF_PCR_WRITE : constant is 1;
    attribute mti_svvh_generic_type of LPTF_PXR_READ : constant is 1;
    attribute mti_svvh_generic_type of LPTF_PXR_WRITE : constant is 1;
end LPT_controller_82550;
