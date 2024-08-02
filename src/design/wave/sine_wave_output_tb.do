onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sine_wave_output_tb/clk
add wave -noupdate /sine_wave_output_tb/rst_ni
add wave -noupdate /sine_wave_output_tb/sine_wave_out
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
WaveRestoreZoom {2999050 fs} {3000050 fs}
