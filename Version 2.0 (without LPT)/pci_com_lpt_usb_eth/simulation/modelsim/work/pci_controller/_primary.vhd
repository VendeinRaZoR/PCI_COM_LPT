library verilog;
use verilog.vl_types.all;
entity pci_controller is
    generic(
        VIDPID          : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        STATUSCOMMAND   : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        CLASSCODE       : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        BIST_HEADER_LAT_CACH: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        BAR0            : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        BAR1            : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        BAR2            : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        BAR3            : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        BAR4            : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        BAR5            : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        CARDBUS         : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        SUBSYSTEM_VENDOR: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        EXPANSION_ROM_BAR: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        CAP_POINTER     : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        LAT_INTERRUPT   : vl_logic_vector(0 to 15) := (Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        RESERVED        : vl_logic_vector(0 to 15) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        CS_INT_PIN_DEV0 : integer := 512;
        CS_INT_PIN_DEV1 : integer := 256;
        CS_INT_PIN_DEV2 : integer := 768;
        CS_INT_PIN_DEV3 : integer := 1024;
        CS_STAT_MASK_DEV0: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        CS_STAT_MASK_DEV1: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        CS_STAT_MASK_DEV2: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        CS_STAT_MASK_DEV3: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        CS_CMD_MASK_DEV0: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        CS_CMD_MASK_DEV1: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        CS_CMD_MASK_DEV2: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        CS_CMD_MASK_DEV3: vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        CS_MULTIFUNC_DEV: integer := 8388608;
        CS_VIDPID_DEV0  : vl_logic_vector(31 downto 0) := (Hi1, Hi1, Hi0, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi1, Hi1, Hi0, Hi1, Hi1, Hi1, Hi1);
        CS_CLASSCODE_DEV0: integer := 201523280;
        CS_VIDPID_DEV1  : integer := 1347633992;
        CS_CLASSCODE_DEV1: integer := 117441039;
        CS_VIDPID_DEV2  : integer := 0;
        CS_CLASSCODE_DEV2: integer := 0;
        CS_VIDPID_DEV3  : integer := 0;
        CS_CLASSCODE_DEV3: integer := 0;
        ST_IDLE         : integer := 0;
        ST_DECODED      : integer := 1;
        ST_READCS       : integer := 2;
        ST_WRITECS      : integer := 3;
        ST_READIO       : integer := 4;
        ST_WRITEIO      : integer := 5;
        ST_SUSTAIN      : integer := 6
    );
    port(
        I_CLK           : in     vl_logic;
        IO_AD           : inout  vl_logic_vector(31 downto 0);
        I_CBE           : in     vl_logic_vector(3 downto 0);
        I_IDSEL         : in     vl_logic;
        \_I_FRAME\      : in     vl_logic;
        \_I_IRDY\       : in     vl_logic;
        I_DEV0BAR4DATA  : in     vl_logic;
        I_DEV1BAR0DATA  : in     vl_logic;
        I_DEV1BAR1DATA  : in     vl_logic;
        \_I_RESET\      : in     vl_logic;
        O_PAR           : out    vl_logic;
        O_ADDR          : out    vl_logic_vector(31 downto 0);
        O_BE            : out    vl_logic_vector(3 downto 0);
        O_DEV0BAR4SEL   : out    vl_logic;
        O_DEV1BAR0SEL   : out    vl_logic;
        O_DEV1BAR1SEL   : out    vl_logic;
        O_OE_WE_DEV     : out    vl_logic;
        \_O_TRDY\       : out    vl_logic;
        \_O_DEVSEL\     : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of VIDPID : constant is 1;
    attribute mti_svvh_generic_type of STATUSCOMMAND : constant is 1;
    attribute mti_svvh_generic_type of CLASSCODE : constant is 1;
    attribute mti_svvh_generic_type of BIST_HEADER_LAT_CACH : constant is 1;
    attribute mti_svvh_generic_type of BAR0 : constant is 1;
    attribute mti_svvh_generic_type of BAR1 : constant is 1;
    attribute mti_svvh_generic_type of BAR2 : constant is 1;
    attribute mti_svvh_generic_type of BAR3 : constant is 1;
    attribute mti_svvh_generic_type of BAR4 : constant is 1;
    attribute mti_svvh_generic_type of BAR5 : constant is 1;
    attribute mti_svvh_generic_type of CARDBUS : constant is 1;
    attribute mti_svvh_generic_type of SUBSYSTEM_VENDOR : constant is 1;
    attribute mti_svvh_generic_type of EXPANSION_ROM_BAR : constant is 1;
    attribute mti_svvh_generic_type of CAP_POINTER : constant is 1;
    attribute mti_svvh_generic_type of LAT_INTERRUPT : constant is 1;
    attribute mti_svvh_generic_type of RESERVED : constant is 1;
    attribute mti_svvh_generic_type of CS_INT_PIN_DEV0 : constant is 1;
    attribute mti_svvh_generic_type of CS_INT_PIN_DEV1 : constant is 1;
    attribute mti_svvh_generic_type of CS_INT_PIN_DEV2 : constant is 1;
    attribute mti_svvh_generic_type of CS_INT_PIN_DEV3 : constant is 1;
    attribute mti_svvh_generic_type of CS_STAT_MASK_DEV0 : constant is 1;
    attribute mti_svvh_generic_type of CS_STAT_MASK_DEV1 : constant is 1;
    attribute mti_svvh_generic_type of CS_STAT_MASK_DEV2 : constant is 1;
    attribute mti_svvh_generic_type of CS_STAT_MASK_DEV3 : constant is 1;
    attribute mti_svvh_generic_type of CS_CMD_MASK_DEV0 : constant is 1;
    attribute mti_svvh_generic_type of CS_CMD_MASK_DEV1 : constant is 1;
    attribute mti_svvh_generic_type of CS_CMD_MASK_DEV2 : constant is 1;
    attribute mti_svvh_generic_type of CS_CMD_MASK_DEV3 : constant is 1;
    attribute mti_svvh_generic_type of CS_MULTIFUNC_DEV : constant is 1;
    attribute mti_svvh_generic_type of CS_VIDPID_DEV0 : constant is 1;
    attribute mti_svvh_generic_type of CS_CLASSCODE_DEV0 : constant is 1;
    attribute mti_svvh_generic_type of CS_VIDPID_DEV1 : constant is 1;
    attribute mti_svvh_generic_type of CS_CLASSCODE_DEV1 : constant is 1;
    attribute mti_svvh_generic_type of CS_VIDPID_DEV2 : constant is 1;
    attribute mti_svvh_generic_type of CS_CLASSCODE_DEV2 : constant is 1;
    attribute mti_svvh_generic_type of CS_VIDPID_DEV3 : constant is 1;
    attribute mti_svvh_generic_type of CS_CLASSCODE_DEV3 : constant is 1;
    attribute mti_svvh_generic_type of ST_IDLE : constant is 1;
    attribute mti_svvh_generic_type of ST_DECODED : constant is 1;
    attribute mti_svvh_generic_type of ST_READCS : constant is 1;
    attribute mti_svvh_generic_type of ST_WRITECS : constant is 1;
    attribute mti_svvh_generic_type of ST_READIO : constant is 1;
    attribute mti_svvh_generic_type of ST_WRITEIO : constant is 1;
    attribute mti_svvh_generic_type of ST_SUSTAIN : constant is 1;
end pci_controller;
