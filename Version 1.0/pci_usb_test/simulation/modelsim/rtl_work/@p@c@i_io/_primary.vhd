library verilog;
use verilog.vl_types.all;
entity PCI_io is
    port(
        clk             : in     vl_logic;
        in_cs_addr_data : in     vl_logic_vector(31 downto 0);
        in_io_addr_data_device0: in     vl_logic_vector(31 downto 0);
        in_io_addr_data_device1: in     vl_logic_vector(31 downto 0);
        in_io_addr_data_device2: in     vl_logic_vector(31 downto 0);
        in_io_addr_data_device3: in     vl_logic_vector(31 downto 0);
        in_in_addr_data_buf: in     vl_logic_vector(31 downto 0);
        control         : in     vl_logic;
        is_config_space : in     vl_logic;
        is_io_space0    : in     vl_logic;
        is_io_space1    : in     vl_logic;
        is_io_space2    : in     vl_logic;
        is_io_space3    : in     vl_logic;
        out_in_addr_data_buf: out    vl_logic_vector(31 downto 0);
        out_addr_data   : out    vl_logic_vector(31 downto 0)
    );
end PCI_io;
