## Generated SDC file "pci_com_lpt_usb_eth.out.sdc"

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

## DATE    "Tue Oct 23 16:35:41 2018"

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

create_clock -name {I_CLK_DEV} -period 20.000 -waveform { 0.000 10.000 } [get_ports { I_CLK_DEV }]
create_clock -name {I_CLK} -period 30.000 -waveform { 0.000 15.000 } [get_ports { I_CLK }]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {I_CLK_DEV}] -rise_to [get_clocks {I_CLK_DEV}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {I_CLK_DEV}] -fall_to [get_clocks {I_CLK_DEV}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {I_CLK_DEV}] -rise_to [get_clocks {I_CLK}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {I_CLK_DEV}] -rise_to [get_clocks {I_CLK}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {I_CLK_DEV}] -fall_to [get_clocks {I_CLK}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {I_CLK_DEV}] -fall_to [get_clocks {I_CLK}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {I_CLK_DEV}] -rise_to [get_clocks {I_CLK_DEV}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {I_CLK_DEV}] -fall_to [get_clocks {I_CLK_DEV}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {I_CLK_DEV}] -rise_to [get_clocks {I_CLK}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {I_CLK_DEV}] -rise_to [get_clocks {I_CLK}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {I_CLK_DEV}] -fall_to [get_clocks {I_CLK}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {I_CLK_DEV}] -fall_to [get_clocks {I_CLK}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {I_CLK}] -rise_to [get_clocks {I_CLK_DEV}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {I_CLK}] -rise_to [get_clocks {I_CLK_DEV}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {I_CLK}] -fall_to [get_clocks {I_CLK_DEV}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {I_CLK}] -fall_to [get_clocks {I_CLK_DEV}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {I_CLK}] -rise_to [get_clocks {I_CLK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {I_CLK}] -fall_to [get_clocks {I_CLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {I_CLK}] -rise_to [get_clocks {I_CLK_DEV}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {I_CLK}] -rise_to [get_clocks {I_CLK_DEV}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {I_CLK}] -fall_to [get_clocks {I_CLK_DEV}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {I_CLK}] -fall_to [get_clocks {I_CLK_DEV}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {I_CLK}] -rise_to [get_clocks {I_CLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {I_CLK}] -fall_to [get_clocks {I_CLK}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************



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

