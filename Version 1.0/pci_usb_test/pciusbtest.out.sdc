## Generated SDC file "pciusbtest.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.0 Build 156 04/24/2013 SJ Web Edition"

## DATE    "Sun Jul 15 11:29:14 2018"

##
## DEVICE  "EP3C10E144C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {baudclk_221184kHz} -period 20.000 -waveform { 0.000 10.000 } [get_ports {baudclk_221184kHz}]
create_clock -name {COM_controller_16C550:b2v_inst9|baudclk_TX} -period 1 -waveform { 0.000 0.500 } [get_registers {COM_controller_16C550:b2v_inst9|baudclk_TX}]
create_clock -name {clk} -period 30.000 -waveform { 0.000 0.500 } [get_ports {clk}]
create_clock -name {COM_controller_16C550:b2v_inst9|baudclk_RX} -period 1 -waveform { 0.000 0.500 } [get_registers {COM_controller_16C550:b2v_inst9|baudclk_RX}]


#**************************************************************
# Create Generated Clock
#**************************************************************

#create_generated_clock -name {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {b2v_inst3|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 12 -master_clock {baudclk_221184kHz} [get_pins {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -setup 0.100  
#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -hold 0.070  
#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -setup 0.100  
#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -hold 0.070  
#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -setup 0.100  
#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -hold 0.070  
#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -setup 0.100  
#set_clock_uncertainty -rise_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -hold 0.070  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -setup 0.100  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -hold 0.070  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -setup 0.100  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -hold 0.070  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -setup 0.100  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -hold 0.070  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -setup 0.100  
#set_clock_uncertainty -fall_from [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -hold 0.070  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}]  0.020  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}]  0.020  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -rise_to [get_clocks {clk}]  0.030  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -fall_to [get_clocks {clk}]  0.030  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}]  0.020  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}]  0.020  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -rise_to [get_clocks {clk}]  0.030  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}] -fall_to [get_clocks {clk}]  0.030  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  0.020  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  0.020  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -rise_to [get_clocks {clk}]  0.030  
#set_clock_uncertainty -rise_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -fall_to [get_clocks {clk}]  0.030  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  0.020  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  0.020  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -rise_to [get_clocks {clk}]  0.030  
#set_clock_uncertainty -fall_from [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}] -fall_to [get_clocks {clk}]  0.030  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}]  0.030  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}]  0.030  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  0.030  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  0.030  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
#set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}]  0.030  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_TX}]  0.030  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  0.030  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  0.030  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
#set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

#set_false_path  -from  [get_clocks {clk}]  -to  [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX COM_controller_16C550:b2v_inst9|baudclk_TX}]
#set_false_path  -from  [get_clocks {clk}]  -to  [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}]
#set_false_path  -from  [get_clocks {clk}]  -to  [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_18432kHz}]
#set_false_path  -from  [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  -to  [get_clocks {baudclk_221184kHz}]
#set_false_path  -from  [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]  -to  [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_18432kHz}]
#set_false_path  -from  [get_clocks {clk}]  -to  [get_clocks {baudclk_221184kHz b2v_inst3|altpll_component|auto_generated|pll1|clk[0] COM_controller_16C550:b2v_inst9|com_state.COMF_IIR_READ COM_controller_16C550:b2v_inst9|baudclk_TX COM_controller_16C550:b2v_inst9|baudclk_RX COM_controller_16C550:b2v_inst9|baudclk_18432kHz COM_controller_16C550:b2v_inst9|IER_COM1[1] COM_controller_16C550:b2v_inst9|FIFO_RX_COM1_int_trigger_counter[0] COM_controller_16C550:b2v_inst9|FIFO_TX_COM1_empty}]
#set_false_path  -from  [get_clocks {COM_controller_16C550:b2v_inst9|FIFO_RX_COM1_int_trigger_counter[0] COM_controller_16C550:b2v_inst9|FIFO_TX_COM1_empty COM_controller_16C550:b2v_inst9|IER_COM1[1] COM_controller_16C550:b2v_inst9|baudclk_18432kHz COM_controller_16C550:b2v_inst9|baudclk_RX COM_controller_16C550:b2v_inst9|baudclk_TX COM_controller_16C550:b2v_inst9|com_state.COMF_IIR_READ b2v_inst3|altpll_component|auto_generated|pll1|clk[0] baudclk_221184kHz}]  -to  [get_clocks {clk}]
#set_false_path  -from  [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0] COM_controller_16C550:b2v_inst9|com_state.COMF_IIR_READ COM_controller_16C550:b2v_inst9|IER_COM1[1] COM_controller_16C550:b2v_inst9|baudclk_18432kHz COM_controller_16C550:b2v_inst9|FIFO_TX_COM1_empty COM_controller_16C550:b2v_inst9|FIFO_RX_COM1_int_trigger_counter[0] clk baudclk_221184kHz}]  -to  [get_clocks {COM_controller_16C550:b2v_inst9|baudclk_RX}]
#set_false_path  -from  [get_clocks {COM_controller_16C550:b2v_inst9|FIFO_RX_COM1_int_trigger_counter[0] COM_controller_16C550:b2v_inst9|FIFO_TX_COM1_empty COM_controller_16C550:b2v_inst9|IER_COM1[1] COM_controller_16C550:b2v_inst9|baudclk_18432kHz COM_controller_16C550:b2v_inst9|baudclk_RX COM_controller_16C550:b2v_inst9|baudclk_TX COM_controller_16C550:b2v_inst9|com_state.COMF_IIR_READ baudclk_221184kHz clk}]  -to  [get_clocks {b2v_inst3|altpll_component|auto_generated|pll1|clk[0]}]
#set_false_path -from [get_keepers {COM_controller_16C550:b2v_inst9|CTS_COM1[1]}] -to [get_keepers {COM_controller_16C550:b2v_inst9|CTS_COM1_changed_int_flag}]
#set_false_path -from [get_keepers {COM_controller_16C550:b2v_inst9|parity_error[1]}] -to [get_keepers {COM_controller_16C550:b2v_inst9|parity_error_int_flag}]
#set_false_path -from [get_keepers {COM_controller_16C550:b2v_inst9|framing_error[1]}] -to [get_keepers {COM_controller_16C550:b2v_inst9|framing_error_int_flag}]
#set_false_path -from [get_keepers {COM_controller_16C550:b2v_inst9|interrupt_pending}] -to [get_keepers {COM_controller_16C550:b2v_inst9|CTS_COM1_changed_int_flag}]
#set_false_path -from [get_keepers {COM_controller_16C550:b2v_inst9|CTS_COM1[0]}] -to [get_keepers {COM_controller_16C550:b2v_inst9|CTS_COM1_changed_int_flag}]
#set_false_path -from [get_keepers {COM_controller_16C550:b2v_inst9|CTS_COM1[0]}] -to [get_keepers {COM_controller_16C550:b2v_inst9|MSR_COM1[0]}]
#set_false_path -from [get_keepers {COM_controller_16C550:b2v_inst9|CTS_COM1[1]}] -to [get_keepers {COM_controller_16C550:b2v_inst9|MSR_COM1[0]}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

