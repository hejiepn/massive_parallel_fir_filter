onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /adder_tree_tb/clk_i
add wave -noupdate /adder_tree_tb/rst_ni
add wave -noupdate /adder_tree_tb/odata
add wave -noupdate /adder_tree_tb/at/idata
add wave -noupdate /adder_tree_tb/at/odata
add wave -noupdate /adder_tree_tb/at/data
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
WaveRestoreZoom {10199050 fs} {10200050 fs}
