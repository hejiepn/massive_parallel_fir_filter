onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/tl_i
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/tl_o
add wave -noupdate -expand -group i2c -expand -subitemconfig {/student_iic_ctrl_tb/DUT/reg2hw.sda_en -expand /student_iic_ctrl_tb/DUT/reg2hw.sda_write -expand /student_iic_ctrl_tb/DUT/reg2hw.scl_en -expand /student_iic_ctrl_tb/DUT/reg2hw.scl_write -expand} /student_iic_ctrl_tb/DUT/reg2hw
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/hw2reg
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/sda_o
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/sda_en
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/sda_i
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/scl_o
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/scl_en
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/scl_i
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/sda_en_buf
add wave -noupdate -expand -group i2c /student_iic_ctrl_tb/DUT/scl_en_buf
add wave -noupdate -group scl_pad {/student_iic_ctrl_tb/DUT/scl_pad/cellarray[0]/iocell/DRIVE}
add wave -noupdate -group scl_pad {/student_iic_ctrl_tb/DUT/scl_pad/cellarray[0]/iocell/IBUF_LOW_PWR}
add wave -noupdate -group scl_pad {/student_iic_ctrl_tb/DUT/scl_pad/cellarray[0]/iocell/IOSTANDARD}
add wave -noupdate -group scl_pad {/student_iic_ctrl_tb/DUT/scl_pad/cellarray[0]/iocell/SLEW}
add wave -noupdate -group sda_pad {/student_iic_ctrl_tb/DUT/sda_pad/cellarray[0]/iocell/DRIVE}
add wave -noupdate -group sda_pad {/student_iic_ctrl_tb/DUT/sda_pad/cellarray[0]/iocell/IBUF_LOW_PWR}
add wave -noupdate -group sda_pad {/student_iic_ctrl_tb/DUT/sda_pad/cellarray[0]/iocell/IOSTANDARD}
add wave -noupdate -group sda_pad {/student_iic_ctrl_tb/DUT/sda_pad/cellarray[0]/iocell/SLEW}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {340000000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 310
configure wave -valuecolwidth 158
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 fs} {3991391566 fs}
