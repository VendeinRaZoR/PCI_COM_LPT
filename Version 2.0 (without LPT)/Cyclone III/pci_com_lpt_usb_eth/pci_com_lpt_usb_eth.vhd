-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 13.0.0 Build 156 04/24/2013 SJ Web Edition"
-- CREATED		"Sun Sep 30 21:45:53 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY pci_com_lpt_usb_eth IS 
	PORT
	(
		I_CLK :  IN  STD_LOGIC;
		I_IDSEL :  IN  STD_LOGIC;
		_I_FRAME :  IN  STD_LOGIC;
		_I_IRDY :  IN  STD_LOGIC;
		_I_RESET :  IN  STD_LOGIC;
		I_CLK_DEV :  IN  STD_LOGIC;
		I_RX :  IN  STD_LOGIC;
		I_CTS :  IN  STD_LOGIC;
		I_DSR :  IN  STD_LOGIC;
		I_RI :  IN  STD_LOGIC;
		I_DCD :  IN  STD_LOGIC;
		I_CBE :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		IO_AD :  INOUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		_O_TRDY :  OUT  STD_LOGIC;
		_O_DEVSEL :  OUT  STD_LOGIC;
		O_INTX :  OUT  STD_LOGIC;
		O_TX :  OUT  STD_LOGIC;
		O_RTS :  OUT  STD_LOGIC;
		O_DTR :  OUT  STD_LOGIC
	);
END pci_com_lpt_usb_eth;

ARCHITECTURE bdf_type OF pci_com_lpt_usb_eth IS 

COMPONENT com_controller
	PORT(I_CLK_BUS : IN STD_LOGIC;
		 I_CLK_DEV : IN STD_LOGIC;
		 _I_RESET : IN STD_LOGIC;
		 I_OE_WE_DEV : IN STD_LOGIC;
		 I_RX : IN STD_LOGIC;
		 I_CTS : IN STD_LOGIC;
		 I_DSR : IN STD_LOGIC;
		 I_RI : IN STD_LOGIC;
		 I_DCD : IN STD_LOGIC;
		 I_DEVSEL : IN STD_LOGIC;
		 I_ADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 I_BE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 IO_AD : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 O_PAR : OUT STD_LOGIC;
		 O_INTX : OUT STD_LOGIC;
		 O_TX : OUT STD_LOGIC;
		 O_RTS : OUT STD_LOGIC;
		 O_DTR : OUT STD_LOGIC;
		 O_DEVDATA : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT pci_controller
GENERIC (BAR0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			BAR1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			BAR2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			BAR3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			BAR4 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			BAR5 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			BIST_HEADER_LAT_CACH : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CAP_POINTER : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CARDBUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CLASSCODE : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CS_CLASSCODE_DEV0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_CLASSCODE_DEV1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_CLASSCODE_DEV2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_CLASSCODE_DEV3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_CMD_MASK_DEV0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CS_CMD_MASK_DEV1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CS_CMD_MASK_DEV2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CS_CMD_MASK_DEV3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CS_INT_PIN_DEV0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_INT_PIN_DEV1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_INT_PIN_DEV2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_INT_PIN_DEV3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_MULTIFUNC_DEV : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_STAT_MASK_DEV0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CS_STAT_MASK_DEV1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CS_STAT_MASK_DEV2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CS_STAT_MASK_DEV3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
			CS_VIDPID_DEV0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_VIDPID_DEV1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_VIDPID_DEV2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			CS_VIDPID_DEV3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
			EXPANSION_ROM_BAR : STD_LOGIC_VECTOR(15 DOWNTO 0);
			LAT_INTERRUPT : STD_LOGIC_VECTOR(15 DOWNTO 0);
			RESERVED : STD_LOGIC_VECTOR(15 DOWNTO 0);
			ST_DECODED : INTEGER;
			ST_IDLE : INTEGER;
			ST_READCS : INTEGER;
			ST_READIO : INTEGER;
			ST_SUSTAIN : INTEGER;
			ST_WRITECS : INTEGER;
			ST_WRITEIO : INTEGER;
			STATUSCOMMAND : STD_LOGIC_VECTOR(15 DOWNTO 0);
			SUBSYSTEM_VENDOR : STD_LOGIC_VECTOR(15 DOWNTO 0);
			VIDPID : STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
	PORT(I_CLK : IN STD_LOGIC;
		 I_IDSEL : IN STD_LOGIC;
		 _I_FRAME : IN STD_LOGIC;
		 _I_IRDY : IN STD_LOGIC;
		 I_DEV0BAR4DATA : IN STD_LOGIC;
		 I_DEV1BAR0DATA : IN STD_LOGIC;
		 I_DEV1BAR1DATA : IN STD_LOGIC;
		 _I_RESET : IN STD_LOGIC;
		 I_CBE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 IO_AD : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 O_PAR : OUT STD_LOGIC;
		 O_DEV0BAR4SEL : OUT STD_LOGIC;
		 O_DEV1BAR0SEL : OUT STD_LOGIC;
		 O_DEV1BAR1SEL : OUT STD_LOGIC;
		 O_OE_WE_DEV : OUT STD_LOGIC;
		 _O_TRDY : OUT STD_LOGIC;
		 _O_DEVSEL : OUT STD_LOGIC;
		 O_ADDR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 O_BE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_7 <= '0';



b2v_inst : com_controller
PORT MAP(I_CLK_BUS => I_CLK,
		 I_CLK_DEV => I_CLK_DEV,
		 _I_RESET => _I_RESET,
		 I_OE_WE_DEV => SYNTHESIZED_WIRE_0,
		 I_RX => I_RX,
		 I_CTS => I_CTS,
		 I_DSR => I_DSR,
		 I_RI => I_RI,
		 I_DCD => I_DCD,
		 I_DEVSEL => SYNTHESIZED_WIRE_1,
		 I_ADDR => SYNTHESIZED_WIRE_2,
		 I_BE => SYNTHESIZED_WIRE_3,
		 IO_AD => IO_AD,
		 O_INTX => O_INTX,
		 O_TX => O_TX,
		 O_RTS => O_RTS,
		 O_DTR => O_DTR,
		 O_DEVDATA => SYNTHESIZED_WIRE_4);


b2v_inst1 : pci_controller
GENERIC MAP(BAR0 => "0000000000010000",
			BAR1 => "0000000000100000",
			BAR2 => "0000000001000000",
			BAR3 => "0000000010000000",
			BAR4 => "0000000100000000",
			BAR5 => "0000001000000000",
			BIST_HEADER_LAT_CACH => "0000000000001000",
			CAP_POINTER => "0010000000000000",
			CARDBUS => "0000010000000000",
			CLASSCODE => "0000000000000100",
			CS_CLASSCODE_DEV0 => "00001100000000110000000001010000",
			CS_CLASSCODE_DEV1 => "00000111000000000000001000001111",
			CS_CLASSCODE_DEV2 => "00000000000000000000000000000000",
			CS_CLASSCODE_DEV3 => "00000000000000000000000000000000",
			CS_CMD_MASK_DEV0 => "0000000000000011",
			CS_CMD_MASK_DEV1 => "0000000000000011",
			CS_CMD_MASK_DEV2 => "0000000000000011",
			CS_CMD_MASK_DEV3 => "0000000000000011",
			CS_INT_PIN_DEV0 => "00000000000000000000001000000000",
			CS_INT_PIN_DEV1 => "00000000000000000000000100000000",
			CS_INT_PIN_DEV2 => "00000000000000000000001100000000",
			CS_INT_PIN_DEV3 => "00000000000000000000010000000000",
			CS_MULTIFUNC_DEV => "00000000100000000000000000000000",
			CS_STAT_MASK_DEV0 => "0000001010001000",
			CS_STAT_MASK_DEV1 => "0000001010001000",
			CS_STAT_MASK_DEV2 => "0000001010001000",
			CS_STAT_MASK_DEV3 => "0000001010001000",
			CS_VIDPID_DEV0 => "11011110101011011011111011101111",
			CS_VIDPID_DEV1 => "01010000010100110100001101001000",
			CS_VIDPID_DEV2 => "00000000000000000000000000000000",
			CS_VIDPID_DEV3 => "00000000000000000000000000000000",
			EXPANSION_ROM_BAR => "0001000000000000",
			LAT_INTERRUPT => "0100000000000000",
			RESERVED => "1000000000000000",
			ST_DECODED => 1,
			ST_IDLE => 0,
			ST_READCS => 2,
			ST_READIO => 4,
			ST_SUSTAIN => 6,
			ST_WRITECS => 3,
			ST_WRITEIO => 5,
			STATUSCOMMAND => "0000000000000010",
			SUBSYSTEM_VENDOR => "0000100000000000",
			VIDPID => "0000000000000001"
			)
PORT MAP(I_CLK => I_CLK,
		 I_IDSEL => I_IDSEL,
		 _I_FRAME => _I_FRAME,
		 _I_IRDY => _I_IRDY,
		 I_DEV0BAR4DATA => SYNTHESIZED_WIRE_4,
		 I_DEV1BAR0DATA => SYNTHESIZED_WIRE_7,
		 I_DEV1BAR1DATA => SYNTHESIZED_WIRE_7,
		 _I_RESET => _I_RESET,
		 I_CBE => I_CBE,
		 IO_AD => IO_AD,
		 O_DEV1BAR0SEL => SYNTHESIZED_WIRE_1,
		 O_OE_WE_DEV => SYNTHESIZED_WIRE_0,
		 _O_TRDY => _O_TRDY,
		 _O_DEVSEL => _O_DEVSEL,
		 O_ADDR => SYNTHESIZED_WIRE_2,
		 O_BE => SYNTHESIZED_WIRE_3);



END bdf_type;