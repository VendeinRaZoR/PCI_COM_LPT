onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/I_CLK
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/I_CLK_DEV
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/CLK_RX
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/_I_IRDY
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/IO_AD
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/I_CBE
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/_I_FRAME
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/I_IDSEL
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/_O_DEVSEL
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/_O_TRDY
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/_I_RESET
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/O_TX
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/I_RX
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/strb_cntr_rx
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/strb_tx
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/strb_rx
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/fifo_rx_empty
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/fifo_rx_waddr
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/fifo_rx_raddr
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/RBR_COM1
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/RSR_COM1
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/rx_edge
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/strb_tx_en
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/strb_rx_en
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/rx_shift_en
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/ovrn_err_iflag
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/brk_dtd_iflag
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/brk_dtd_cntr
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/brk_dtd_value
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/ovrn_err
add wave -noupdate /pci_com_lpt_usb_eth_vlg_tst/i1/b2v_inst/fifo_rx_full
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 9} {999932393 ps} 0} {{Cursor 11} {132659145 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 352
configure wave -valuecolwidth 53
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {143566906 ps} {143720288 ps}
