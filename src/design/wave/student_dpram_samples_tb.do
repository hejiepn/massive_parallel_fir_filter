onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dpram_samples /student_dpram_samples_tb/dut/AddrWidth
add wave -noupdate -expand -group dpram_samples /student_dpram_samples_tb/dut/DataSize
add wave -noupdate -expand -group dpram_samples /student_dpram_samples_tb/dut/dob
add wave -noupdate -expand -group dpram_samples /student_dpram_samples_tb/dut/bram
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/AddrWidth
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/DataSize
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/clk_i
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/ena
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/enb
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/wea
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/addra
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/addrb
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/dia
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/dob
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/write_ptr
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/read_ptr
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/expected_data
add wave -noupdate -expand -group dpram_samples_tb /student_dpram_samples_tb/error_flag
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
WaveRestoreZoom {829050 fs} {830090 fs}
