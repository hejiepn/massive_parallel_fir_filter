onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group ringbuffer /student_ringbuffer_tb/clk
add wave -noupdate -expand -group ringbuffer /student_ringbuffer_tb/rst_n
add wave -noupdate -expand -group ringbuffer /student_ringbuffer_tb/valid_strobe_tb
add wave -noupdate -expand -group ringbuffer /student_ringbuffer_tb/delay_tb
add wave -noupdate -expand -group ringbuffer /student_ringbuffer_tb/left_in_tb
add wave -noupdate -expand -group ringbuffer /student_ringbuffer_tb/right_in_tb
add wave -noupdate -expand -group ringbuffer /student_ringbuffer_tb/left_out_tb
add wave -noupdate -expand -group ringbuffer /student_ringbuffer_tb/right_out_tb
add wave -noupdate -expand -group ringbuffer /student_ringbuffer_tb/#ublk#262446018#32/errcnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
configure wave -namecolwidth 426
configure wave -valuecolwidth 455
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
WaveRestoreZoom {4999999050 fs} {4999999639 fs}
