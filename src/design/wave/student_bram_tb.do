onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group bram /student_bram_tb/clk
add wave -noupdate -expand -group bram /student_bram_tb/pos_edge_tb
add wave -noupdate -expand -group bram /student_bram_tb/left_in_ff_tb
add wave -noupdate -expand -group bram /student_bram_tb/wr_addr_tb
add wave -noupdate -expand -group bram /student_bram_tb/left_rdata_tb
add wave -noupdate -expand -group bram /student_bram_tb/rd_addr_tb
add wave -noupdate -expand -group bram /student_bram_tb/period
add wave -noupdate -expand -group bram /student_bram_tb/#ublk#36442690#29/errcnt
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
WaveRestoreZoom {379999050 fs} {380000429 fs}
