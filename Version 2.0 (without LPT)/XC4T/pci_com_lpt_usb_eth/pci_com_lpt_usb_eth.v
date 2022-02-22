// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 32-bit"
// VERSION		"Version 13.0.0 Build 156 04/24/2013 SJ Web Edition"
// CREATED		"Thu Oct 11 18:24:15 2018"

module pci_com_lpt_usb_eth(
	I_CLK,
	I_IDSEL,
	_I_FRAME,
	_I_IRDY,
	_I_RESET,
	I_CLK_DEV,
	I_RX,
	I_CTS,
	I_DSR,
	I_RI,
	I_DCD,
	I_CBE,
	O_TX,
	O_RTS,
	O_DTR,
	O_PAR,
	O_DEV0BAR4SEL,
	O_DEV1BAR1SEL,
	O_INT,
	_O_TRDY,
	_O_DEVSEL,
	IO_AD,
	baudout
);


input wire	I_CLK;
input wire	I_IDSEL;
input wire	_I_FRAME;
input wire	_I_IRDY;
input wire	_I_RESET;
input wire	I_CLK_DEV;
input wire	I_RX;
input wire	I_CTS;
input wire	I_DSR;
input wire	I_RI;
input wire	I_DCD;
input wire	[3:0] I_CBE;
output wire	O_TX;
output wire	O_RTS;
output wire	O_DTR;
output wire	O_PAR;
output wire	O_DEV0BAR4SEL;
output wire	O_DEV1BAR1SEL;
output wire	O_INT;
inout wire	_O_TRDY;
inout wire	_O_DEVSEL;
inout wire	[31:0] IO_AD;
output wire baudout;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	[31:0] SYNTHESIZED_WIRE_3;
wire	[3:0] SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;

assign	SYNTHESIZED_WIRE_10 = 0;
assign	SYNTHESIZED_WIRE_9 = 1;




com_controller	b2v_inst(
	.I_CLK_BUS(I_CLK),
	.I_CLK_DEV(I_CLK_DEV),
	._I_RESET(_I_RESET),
	.I_OE_WE_DEV(SYNTHESIZED_WIRE_1),
	.I_RX(I_RX),
	.I_CTS(I_CTS),
	.I_DSR(I_DSR),
	.I_RI(I_RI),
	.I_DCD(I_DCD),
	.I_DEVSEL(SYNTHESIZED_WIRE_2),
	.I_ADDR(SYNTHESIZED_WIRE_3),
	.I_BE(SYNTHESIZED_WIRE_4),
	.IO_AD(IO_AD),
	
	.O_INTX(SYNTHESIZED_WIRE_8),
	.O_TX(O_TX),
	.O_RTS(O_RTS),
	.O_DTR(O_DTR),
	.O_DEVRDY(SYNTHESIZED_WIRE_5),
	.baudclk(baudout)
	);


pci_controller	b2v_inst1(
	.I_CLK(I_CLK),
	.I_IDSEL(I_IDSEL),
	._I_FRAME(_I_FRAME),
	._I_IRDY(_I_IRDY),
	.I_DEV0BAR4DATA(SYNTHESIZED_WIRE_5),
	.I_DEV1BAR0DATA(SYNTHESIZED_WIRE_10),
	.I_DEV1BAR1DATA(SYNTHESIZED_WIRE_10),
	._I_RESET(_I_RESET),
	.I_CBE(I_CBE),
	.IO_AD(IO_AD),
	.O_PAR(O_PAR),
	.O_DEV0BAR4SEL(O_DEV0BAR4SEL),
	.O_DEV1BAR0SEL(SYNTHESIZED_WIRE_2),
	.O_DEV1BAR1SEL(O_DEV1BAR1SEL),
	.O_OE_WE_DEV(SYNTHESIZED_WIRE_1),
	._O_TRDY(_O_TRDY),
	._O_DEVSEL(_O_DEVSEL),
	
	.O_ADDR(SYNTHESIZED_WIRE_3),
	.O_BE(SYNTHESIZED_WIRE_4));
	defparam	b2v_inst1.BAR0 = 16'b0000000000010000;
	defparam	b2v_inst1.BAR1 = 16'b0000000000100000;
	defparam	b2v_inst1.BAR2 = 16'b0000000001000000;
	defparam	b2v_inst1.BAR3 = 16'b0000000010000000;
	defparam	b2v_inst1.BAR4 = 16'b0000000100000000;
	defparam	b2v_inst1.BAR5 = 16'b0000001000000000;
	defparam	b2v_inst1.BIST_HEADER_LAT_CACH = 16'b0000000000001000;
	defparam	b2v_inst1.CAP_POINTER = 16'b0010000000000000;
	defparam	b2v_inst1.CARDBUS = 16'b0000010000000000;
	defparam	b2v_inst1.CLASSCODE = 16'b0000000000000100;
	defparam	b2v_inst1.CS_CLASSCODE_DEV0 = 32'b00001100000000110000000001010000;
	defparam	b2v_inst1.CS_CLASSCODE_DEV1 = 32'b00000111000000000000001000001111;
	defparam	b2v_inst1.CS_CLASSCODE_DEV2 = 32'b00000000000000000000000000000000;
	defparam	b2v_inst1.CS_CLASSCODE_DEV3 = 32'b00000000000000000000000000000000;
	defparam	b2v_inst1.CS_CMD_MASK_DEV0 = 16'b0000000000000011;
	defparam	b2v_inst1.CS_CMD_MASK_DEV1 = 16'b0000000000000011;
	defparam	b2v_inst1.CS_CMD_MASK_DEV2 = 16'b0000000000000011;
	defparam	b2v_inst1.CS_CMD_MASK_DEV3 = 16'b0000000000000011;
	defparam	b2v_inst1.CS_INT_PIN_DEV0 = 32'b00000000000000000000001000000000;
	defparam	b2v_inst1.CS_INT_PIN_DEV1 = 32'b00000000000000000000000100000000;
	defparam	b2v_inst1.CS_INT_PIN_DEV2 = 32'b00000000000000000000001100000000;
	defparam	b2v_inst1.CS_INT_PIN_DEV3 = 32'b00000000000000000000010000000000;
	defparam	b2v_inst1.CS_MULTIFUNC_DEV = 32'b00000000100000000000000000000000;
	defparam	b2v_inst1.CS_STAT_MASK_DEV0 = 16'b0000001010001000;
	defparam	b2v_inst1.CS_STAT_MASK_DEV1 = 16'b0000001010001000;
	defparam	b2v_inst1.CS_STAT_MASK_DEV2 = 16'b0000001010001000;
	defparam	b2v_inst1.CS_STAT_MASK_DEV3 = 16'b0000001010001000;
	defparam	b2v_inst1.CS_VIDPID_DEV0 = 32'b11011110101011011011111011101111;
	defparam	b2v_inst1.CS_VIDPID_DEV1 = 32'b01010000010100110100001101001000;
	defparam	b2v_inst1.CS_VIDPID_DEV2 = 32'b00000000000000000000000000000000;
	defparam	b2v_inst1.CS_VIDPID_DEV3 = 32'b00000000000000000000000000000000;
	defparam	b2v_inst1.EXPANSION_ROM_BAR = 16'b0001000000000000;
	defparam	b2v_inst1.LAT_INTERRUPT = 16'b0100000000000000;
	defparam	b2v_inst1.RESERVED = 16'b1000000000000000;
	defparam	b2v_inst1.ST_DECODED = 1;
	defparam	b2v_inst1.ST_IDLE = 0;
	defparam	b2v_inst1.ST_READCS = 2;
	defparam	b2v_inst1.ST_READIO = 4;
	defparam	b2v_inst1.ST_SUSTAIN = 6;
	defparam	b2v_inst1.ST_WRITECS = 3;
	defparam	b2v_inst1.ST_WRITEIO = 5;
	defparam	b2v_inst1.STATUSCOMMAND = 16'b0000000000000010;
	defparam	b2v_inst1.SUBSYSTEM_VENDOR = 16'b0000100000000000;
	defparam	b2v_inst1.VIDPID = 16'b0000000000000001;


assign	O_INT = SYNTHESIZED_WIRE_8 & SYNTHESIZED_WIRE_9;



/*alt_pll	b2v_inst5(
	.inclk0(I_CLK_DEV),
	.c0(SYNTHESIZED_WIRE_0));*/


endmodule
