## Generated SDC file "pciusbtest.sdc"

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
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Sun Sep 24 07:38:05 2017"

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

create_clock -name {clk} -period 90MHz [get_ports {clk}]
create_clock -name {clock} -period 2.000 [get_ports {clock}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {inst3|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {inst3|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 10000 -master_clock {clock} [get_pins {inst3|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {inst3|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {inst3|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {inst3|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {inst3|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {inst3|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {inst3|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -exclusive -group [get_clocks {clk}] -group [get_clocks {clock}] 


#**************************************************************
# Set False Path
#**************************************************************

#set_false_path -from [get_keepers {PCI_controller:inst4|state.RESET}] 
#set_false_path -from [get_keepers {PCI_controller:inst4|state.READ_IO}] 
#set_false_path -from [get_keepers {PCI_controller:inst4|state.WRITE_IO}] 
set_false_path -to [get_keepers {PCI_controller:inst4|state.RESET}] 
set_false_path -to [get_keepers {PCI_controller:inst4|state.READ_IO}] 
set_false_path -to [get_keepers {PCI_controller:inst4|state.WRITE_IO}] 
set_false_path -to [get_keepers {PCI_controller:inst4|state.IDLE}] 
#set_false_path -from [get_keepers {PCI_controller:inst4|confspace_pointer[*]}] -to [get_keepers {PCI_controller:inst4|state.IDLE}]

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

