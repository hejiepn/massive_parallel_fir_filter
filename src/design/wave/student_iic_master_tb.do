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
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/done_o
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/err_o
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/sda_oe
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/scl_oe
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/TSCL_CYCLES
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/dSda
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/ddSda
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/dScl
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/fStart
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/fStop
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/busState
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/sclCnt
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/busFreeCnt
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/state
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/nstate
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/rSda
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/rScl
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/loadByte
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/dataBitOut
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/shiftBit
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/dataByte
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/bitCount
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/subState
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/iSda
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/iScl
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/iDone
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/iErr
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/latchAddr
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/latchData
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/addrNData
add wave -noupdate -expand -group i2c_bus /student_iic_master_tb/DUT/currAddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
configure wave -namecolwidth 311
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
WaveRestoreZoom {0 fs} {49300948036 fs}
