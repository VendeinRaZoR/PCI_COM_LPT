onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Block1_vlg_tst/clk
add wave -noupdate /Block1_vlg_tst/irdy
add wave -noupdate /Block1_vlg_tst/ad
add wave -noupdate /Block1_vlg_tst/frame
add wave -noupdate /Block1_vlg_tst/trdy
add wave -noupdate /Block1_vlg_tst/baudclk_221184kHz
add wave -noupdate /Block1_vlg_tst/BUSY
add wave -noupdate /Block1_vlg_tst/cbe
add wave -noupdate /Block1_vlg_tst/CTS
add wave -noupdate /Block1_vlg_tst/ERR
add wave -noupdate /Block1_vlg_tst/ACK
add wave -noupdate /Block1_vlg_tst/idsel
add wave -noupdate /Block1_vlg_tst/intb
add wave -noupdate /Block1_vlg_tst/intc
add wave -noupdate /Block1_vlg_tst/intd
add wave -noupdate /Block1_vlg_tst/PE
add wave -noupdate /Block1_vlg_tst/reset
add wave -noupdate /Block1_vlg_tst/RX1
add wave -noupdate /Block1_vlg_tst/SELT
add wave -noupdate /Block1_vlg_tst/AFD
add wave -noupdate /Block1_vlg_tst/devsel
add wave -noupdate /Block1_vlg_tst/INIT
add wave -noupdate /Block1_vlg_tst/inta
add wave -noupdate /Block1_vlg_tst/LPT_DATA
add wave -noupdate /Block1_vlg_tst/par
add wave -noupdate /Block1_vlg_tst/RS422_TX_MINUS
add wave -noupdate /Block1_vlg_tst/RTS
add wave -noupdate /Block1_vlg_tst/SIN
add wave -noupdate /Block1_vlg_tst/STROBE
add wave -noupdate /Block1_vlg_tst/TX1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 217
configure wave -valuecolwidth 100
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
WaveRestoreZoom {104297 ps} {571067 ps}
