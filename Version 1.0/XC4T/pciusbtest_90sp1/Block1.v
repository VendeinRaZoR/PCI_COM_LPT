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
// CREATED		"Sat Jun 23 19:09:59 2018"

module Block1(
	clk,
	irdy,
	frame,
	idsel,
	reset, 
	intd,
	RX1,
	CTS,
	intc,
	intb,
	ACK,
	BUSY,
	PE,
	SELT,
	ERR,
	baudclk_221184kHz,
	cbe,
	led2,
	TX1,
	RTS,
	inta,
	RS422_TX_MINUS,
	par,
	trdy,
	devsel,
	STROBE,
	SIN,
	AFD,
	INIT,
	ad,
	LPT_DATA,
	clk_out
);


input wire	clk;
input wire	irdy;
input wire	frame;
input wire	idsel;
input wire	reset;
input wire	intd;
input wire	RX1;
input wire	CTS;
input wire	intc;
input wire	intb;
input wire	ACK;
input wire	BUSY;
input wire	PE;
input wire	SELT;
input wire	ERR;
input wire	baudclk_221184kHz;
input wire	[3:0] cbe;
output wire	led2;
output wire	TX1;
output wire	RTS;
output wire	inta;
output wire	RS422_TX_MINUS;
inout wire	par;
inout wire	trdy;
inout wire	devsel;
inout wire	STROBE;
inout wire	SIN;
inout wire	AFD;
inout wire	INIT;
inout wire	[31:0] ad;
inout wire	[7:0] LPT_DATA;
output wire clk_out;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_34;
wire	[7:0] SYNTHESIZED_WIRE_35;
wire	[7:0] SYNTHESIZED_WIRE_36;
wire	[3:0] SYNTHESIZED_WIRE_37;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
wire	[31:0] SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_38;
wire	SYNTHESIZED_WIRE_39;
wire	[31:0] SYNTHESIZED_WIRE_24;
wire	[31:0] SYNTHESIZED_WIRE_25;
wire	[31:0] SYNTHESIZED_WIRE_26;
wire	[0:31] SYNTHESIZED_WIRE_40;
wire	SYNTHESIZED_WIRE_29;

assign	TX1 = SYNTHESIZED_WIRE_11;
assign	SYNTHESIZED_WIRE_39 = 0;
assign	SYNTHESIZED_WIRE_40 = 0;

reg is_devsel_sustained[2:0];

reg data_ready[1:0];

LPT_controller_82550	b2v_inst1(
	.clk(clk),
	.irdy(irdy),
	.reset(reset),
	.ACK(ACK),
	.BUSY(BUSY),
	.PE(PE),
	.SELT(SELT),
	.ERR(ERR),
	.is_LPT_configured(SYNTHESIZED_WIRE_0),
	.is_LPT_iospace(SYNTHESIZED_WIRE_34),
	.AFD(AFD),
	.INIT(INIT),
	.SIN(SIN),
	.STROBE(STROBE),
	.addr_data_buf_in_byte(SYNTHESIZED_WIRE_35),
	.data(LPT_DATA),
	.in_addr_bar_offset_w_io(SYNTHESIZED_WIRE_36),
	.in_command(SYNTHESIZED_WIRE_37),
	.device_ready(SYNTHESIZED_WIRE_13),
	.interrupt_pin(SYNTHESIZED_WIRE_9),
	.control(SYNTHESIZED_WIRE_16),
	.out_add_data_io(SYNTHESIZED_WIRE_26));

wire devsel_condition;
assign devsel_condition = (SYNTHESIZED_WIRE_12 & SYNTHESIZED_WIRE_13 & SYNTHESIZED_WIRE_14);

assign trdy = is_devsel_sustained[2] ? 1'bz : data_ready[1]; 

assign devsel = is_devsel_sustained[2] ? 1'bz : irdy | devsel_condition;

always@(posedge clk or posedge irdy)
begin
if(irdy)
begin
data_ready[1] <= 1;
data_ready[0] <= 1;
end
else
begin
data_ready[0] <= devsel_condition;
data_ready[1] <= data_ready[0];
is_devsel_sustained[0] <= irdy;
is_devsel_sustained[1] <= is_devsel_sustained[0];
is_devsel_sustained[2] <= is_devsel_sustained[1];
end
end

assign inta = (SYNTHESIZED_WIRE_8 & SYNTHESIZED_WIRE_9) ? 1'bz : 1'b0;

assign	led2 =  ~reset;


PCI_target_controller	b2v_inst4(
	.clk(clk),
	.idsel(idsel),
	.frame(frame),
	.irdy(irdy),
	.reset(reset),
	.device_ready(SYNTHESIZED_WIRE_12),
	.addr_data(SYNTHESIZED_WIRE_10),
	.cbe(cbe),
	.BAR0_DEVICE1_configured(SYNTHESIZED_WIRE_29),
	.BAR1_DEVICE1_configured(SYNTHESIZED_WIRE_0),
	.control(SYNTHESIZED_WIRE_15),
	.is_config_space(SYNTHESIZED_WIRE_19),
	.is_BAR0_DEVICE1_address(SYNTHESIZED_WIRE_38),
	.is_BAR1_DEVICE1_address(SYNTHESIZED_WIRE_34),
	.addr_data_buf_in_byte(SYNTHESIZED_WIRE_35),
	.in_addr_offset_w_io(SYNTHESIZED_WIRE_36),
	.in_command(SYNTHESIZED_WIRE_37),
	.out_add_data_cs(SYNTHESIZED_WIRE_24));

assign	RS422_TX_MINUS =  ~SYNTHESIZED_WIRE_11;

assign	SYNTHESIZED_WIRE_18 = SYNTHESIZED_WIRE_15 & SYNTHESIZED_WIRE_16 & SYNTHESIZED_WIRE_17;

PCI_io	b2v_inst8(
	.clk(clk),
	.control(SYNTHESIZED_WIRE_18),
	.is_config_space(SYNTHESIZED_WIRE_19),
	.is_io_space0(SYNTHESIZED_WIRE_38),
	.is_io_space1(SYNTHESIZED_WIRE_34),
	.is_io_space2(SYNTHESIZED_WIRE_39),
	.is_io_space3(SYNTHESIZED_WIRE_39),
	.in_cs_addr_data(SYNTHESIZED_WIRE_24),
	.in_in_addr_data_buf(ad),
	.in_io_addr_data_device0(SYNTHESIZED_WIRE_25),
	.in_io_addr_data_device1(SYNTHESIZED_WIRE_26),
	.in_io_addr_data_device2(SYNTHESIZED_WIRE_40),
	.in_io_addr_data_device3(SYNTHESIZED_WIRE_40),
	.out_addr_data(ad),
	.out_in_addr_data_buf(SYNTHESIZED_WIRE_10));


COM_controller_16C550	b2v_inst9(
	.clk(clk),
	.irdy(irdy),
	.reset(reset),
	.baudclk_96000kHz(baudclk_221184kHz),
	.RX1(RX1),
	.CTS(CTS),
	.is_COM_configured(SYNTHESIZED_WIRE_29),
	.is_COM_iospace(SYNTHESIZED_WIRE_38),
	.addr_data_buf_in_byte(SYNTHESIZED_WIRE_35),
	.in_addr_bar_offset_w_io(SYNTHESIZED_WIRE_36),
	.in_command(SYNTHESIZED_WIRE_37),
	.device_ready(SYNTHESIZED_WIRE_14),
	.interrupt_pin(SYNTHESIZED_WIRE_8),
	.TX1(SYNTHESIZED_WIRE_11),
	.RTS(RTS),
	.control(SYNTHESIZED_WIRE_17),
	.out_add_data_io(SYNTHESIZED_WIRE_25),
	.baudout(clk_out));


endmodule
