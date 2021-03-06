transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/altera_projects/pci_usb_test {C:/altera_projects/pci_usb_test/Block1.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/pci_usb_test {C:/altera_projects/pci_usb_test/com_controller.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/pci_usb_test {C:/altera_projects/pci_usb_test/altpll0.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/pci_usb_test {C:/altera_projects/pci_usb_test/pci_controller.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/pci_usb_test {C:/altera_projects/pci_usb_test/pci_io.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/pci_usb_test {C:/altera_projects/pci_usb_test/lpt_controller.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/pci_usb_test/db {C:/altera_projects/pci_usb_test/db/altpll0_altpll3.v}

vlog -vlog01compat -work work +incdir+C:/altera_projects/pci_usb_test/simulation/modelsim {C:/altera_projects/pci_usb_test/simulation/modelsim/Block1.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  Block1

add wave *
view structure
view signals
run -all
