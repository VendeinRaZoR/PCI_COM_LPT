-- WARNING: Do NOT edit the input and output ports in this file in a text
-- editor if you plan to continue editing the block that represents it in
-- the Block Editor! File corruption is VERY likely to occur.

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


-- Generated by Quartus II 32-bit Version 13.0 (Build Build 156 04/24/2013)
-- Created on Fri Apr 06 22:42:53 2018

FUNCTION PCI_controller (clk, idsel, frame, irdy, reset, baudclk_221184kHz, RX1)
	WITH (IDLE, READ_IO, WRITE_IO, CONFIGURATION_READ, CONFIGURATION_WRITE, RESET, CS_RESET, CS_IDLE, CS_READ, CS_STATUSCOMMAND_READ_USB, CS_CLASSCODE_READ_USB, CS_BIST_HEADER_LAT_CACH_READ_USB, CS_BAR0_READ_USB, CS_BAR1_READ_USB, CS_BAR2_READ_USB, CS_BAR3_READ_USB, CS_BAR4_READ_USB, CS_BAR5_READ_USB, CS_CARDBUS_READ_USB, CS_SUBSYSTEM_VENDOR_READ_USB, CS_EXPANSION_ROM_BAR_READ_USB, CS_CAP_POINTER_READ_USB, CS_LAT_INTERRUPT_READ_USB, CS_USB_SPECIFIC0_READ, CS_USB_SPECIFIC1_READ, CS_VIDPID_WRITE_USB, CS_STATUSCOMMAND_WRITE_USB, CS_CLASSCODE_WRITE_USB, CS_BIST_HEADER_LAT_CACH_WRITE_USB, CS_BAR0_WRITE_USB, CS_BAR1_WRITE_USB, CS_BAR2_WRITE_USB, CS_BAR3_WRITE_USB, CS_BAR4_WRITE_USB, CS_BAR5_WRITE_USB, CS_CARDBUS_WRITE_USB, CS_SUBSYSTEM_VENDOR_WRITE_USB, CS_EXPANSION_ROM_BAR_WRITE_USB, CS_CAP_POINTER_WRITE_USB, CS_LAT_INTERRUPT_WRITE_USB, CS_USB_SPECIFIC0_WRITE, CS_USB_SPECIFIC1_WRITE, CS_VIDPID_READ_LPT, CS_STATUSCOMMAND_READ_LPT, CS_CLASSCODE_READ_LPT, CS_BIST_HEADER_LAT_CACH_READ_LPT, CS_BAR0_READ_LPT, CS_BAR1_READ_LPT, CS_BAR2_READ_LPT, CS_BAR3_READ_LPT, CS_BAR4_READ_LPT, CS_BAR5_READ_LPT, CS_CARDBUS_READ_LPT, CS_SUBSYSTEM_VENDOR_READ_LPT, CS_EXPANSION_ROM_BAR_READ_LPT, CS_CAP_POINTER_READ_LPT, CS_LAT_INTERRUPT_READ_LPT, CS_VIDPID_WRITE_LPT, CS_STATUSCOMMAND_WRITE_LPT, CS_CLASSCODE_WRITE_LPT, CS_BIST_HEADER_LAT_CACH_WRITE_LPT, CS_BAR0_WRITE_LPT, CS_BAR1_WRITE_LPT, CS_BAR2_WRITE_LPT, CS_BAR3_WRITE_LPT, CS_BAR4_WRITE_LPT, CS_BAR5_WRITE_LPT, CS_CARDBUS_WRITE_LPT, CS_SUBSYSTEM_VENDOR_WRITE_LPT, CS_EXPANSION_ROM_BAR_WRITE_LPT, CS_CAP_POINTER_WRITE_LPT, CS_LAT_INTERRUPT_WRITE_LPT, CS_VIDPID_READ_COM, CS_STATUSCOMMAND_READ_COM, CS_CLASSCODE_READ_COM, CS_BIST_HEADER_LAT_CACH_READ_COM, CS_BAR0_READ_COM, CS_BAR1_READ_COM, CS_BAR2_READ_COM, CS_BAR3_READ_COM, CS_BAR4_READ_COM, CS_BAR5_READ_COM, CS_CARDBUS_READ_COM, CS_SUBSYSTEM_VENDOR_READ_COM, CS_EXPANSION_ROM_BAR_READ_COM, CS_CAP_POINTER_READ_COM, CS_LAT_INTERRUPT_READ_COM, CS_VIDPID_WRITE_COM, CS_STATUSCOMMAND_WRITE_COM, CS_CLASSCODE_WRITE_COM, CS_BIST_HEADER_LAT_CACH_WRITE_COM, CS_BAR0_WRITE_COM, CS_BAR1_WRITE_COM, CS_BAR2_WRITE_COM, CS_BAR3_WRITE_COM, CS_BAR4_WRITE_COM, CS_BAR5_WRITE_COM, CS_CARDBUS_WRITE_COM, CS_SUBSYSTEM_VENDOR_WRITE_COM, CS_EXPANSION_ROM_BAR_WRITE_COM, CS_CAP_POINTER_WRITE_COM, CS_LAT_INTERRUPT_WRITE_COM, CS_NULL, CS_RESERVED, COMF_RESET, COMF_IDLE, COMF_READ, COMF_RX_READ, COMF_TX_WRITE, COMF_IER_WRITE, COMF_IIR_WRITE, COMF_FCR_WRITE, COMF_LCR_WRITE, COMF_MCR_WRITE, COMF_LSR_WRITE, COMF_MSR_WRITE, COMF_SCR_WRITE, COMF_DLL_WRITE, COMF_DLM_WRITE, COMF_DLL_READ, COMF_DLM_READ, COMF_IIR_READ, COMF_MCR_READ, COMF_LCR_READ, COMF_LSR_READ, COMF_MSR_READ, COMF_IER_READ, COMF_INT_FLAG_RESET, COMF_FIFO_WRITE, COMF_IER_CHECK, COMF_TSR_ENABLE, INT_PIN_USB, INT_PIN_LPT, INT_PIN_COM, STATUS_MASK, COMMAND_MASK, TRDY_DELAY, MULTIFUNCTIONAL, VIDPID, CLASSCODE)
	RETURNS (addr_data[31..0], cbe[3..0], devsel, trdy, par, inta, TX1, RX2, TX2);