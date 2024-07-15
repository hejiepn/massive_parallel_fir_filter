onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group iic_tb /student_iic_ctrl_tb/clk
add wave -noupdate -expand -group iic_tb /student_iic_ctrl_tb/rst_n
add wave -noupdate -expand -group iic_tb /student_iic_ctrl_tb/tl_h2d
add wave -noupdate -expand -group iic_tb /student_iic_ctrl_tb/tl_d2h
add wave -noupdate -expand -group iic_tb /student_iic_ctrl_tb/error_cnt
add wave -noupdate -expand -group iic_tb /student_iic_ctrl_tb/#ublk#240997330#55/rdata
add wave -noupdate -expand -group iic /student_iic_ctrl_tb/DUT/sda_oe
add wave -noupdate -expand -group iic /student_iic_ctrl_tb/DUT/scl_oe
add wave -noupdate -expand -group iic /student_iic_ctrl_tb/DUT/tl_i
add wave -noupdate -expand -group iic /student_iic_ctrl_tb/DUT/tl_o
add wave -noupdate -expand -group iic /student_iic_ctrl_tb/DUT/reg2hw
add wave -noupdate -expand -group iic -subitemconfig {/student_iic_ctrl_tb/DUT/hw2reg.sda_read -expand} /student_iic_ctrl_tb/DUT/hw2reg
add wave -noupdate -expand -group iic /student_iic_ctrl_tb/DUT/sda_i_d
add wave -noupdate -expand -group iic /student_iic_ctrl_tb/DUT/sda_i_dd
add wave -noupdate -expand -group iic /student_iic_ctrl_tb/DUT/scl_i_d
add wave -noupdate -expand -group iic /student_iic_ctrl_tb/DUT/scl_i_dd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {586412037 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 460
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
WaveRestoreZoom {0 fs} {4935 ns}
