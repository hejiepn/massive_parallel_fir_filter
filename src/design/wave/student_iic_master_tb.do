onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group i2c_master /student_iic_master_tb/clk
add wave -noupdate -expand -group i2c_master /student_iic_master_tb/rst_n
add wave -noupdate -expand -group i2c_master /student_iic_master_tb/stb
add wave -noupdate -expand -group i2c_master /student_iic_master_tb/address
add wave -noupdate -expand -group i2c_master /student_iic_master_tb/data_in
add wave -noupdate -expand -group i2c_master /student_iic_master_tb/done
add wave -noupdate -expand -group i2c_master /student_iic_master_tb/err
add wave -noupdate -expand -group i2c_master /student_iic_master_tb/rcvd_data
add wave -noupdate -expand -group i2c_master /student_iic_master_tb/slave_rcvd_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {96660000050 fs} {96660000819 fs}
