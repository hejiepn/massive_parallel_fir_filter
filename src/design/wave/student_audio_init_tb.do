onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group audio_init /student_audio_init_tb/clk
add wave -noupdate -expand -group audio_init /student_audio_init_tb/rst_n
add wave -noupdate -expand -group audio_init /student_audio_init_tb/rcvd_data
add wave -noupdate -expand -group audio_init /student_audio_init_tb/slave_rcvd_done
add wave -noupdate -expand -group audio_init /student_audio_init_tb/audio_init_done
add wave -noupdate -expand -group audio_init /student_audio_init_tb/fd
add wave -noupdate -expand -group audio_init /student_audio_init_tb/rcvd_counter
add wave -noupdate -expand -group audio_init /student_audio_init_tb/tl_d2h
add wave -noupdate -expand -group audio_init /student_audio_init_tb/tl_h2d
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
WaveRestoreZoom {97679999050 fs} {97680001353 fs}
