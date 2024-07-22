onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/ADDR_WIDTH
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/DATA_SIZE
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/DEBUGMODE
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/DATA_SIZE_FIR_OUT
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/NUM_FIR
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/clk_i
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/rst_ni
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/valid_strobe_in
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/sample_in
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/valid_strobe_out
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/y_out
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/tl_h2d
add wave -noupdate -group fir_parallel_tb /student_fir_parallel_tb/tl_d2h
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/ADDR_WIDTH
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/DATA_SIZE
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/DEBUGMODE
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/DATA_SIZE_FIR_OUT
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/NUM_FIR
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/valid_strobe_out
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/y_out
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/tl_i
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/tl_o
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/tl_student_fir_i
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/tl_student_fir_o
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/reg2hw
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/hw2reg
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/sample_shift_out_internal
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/valid_strobe_out_internal
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/y_out_internal
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/valid_strobe_in_prev
add wave -noupdate -group fir_parallel /student_fir_parallel_tb/dut/valid_strobe_in_pos_edge
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1340000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 436
configure wave -valuecolwidth 114
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
WaveRestoreZoom {9101586 fs} {10468338 fs}
