onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group fir_tb /student_fir_tb/clk_i
add wave -noupdate -expand -group fir_tb /student_fir_tb/rst_ni
add wave -noupdate -expand -group fir_tb /student_fir_tb/valid_strobe_in
add wave -noupdate -expand -group fir_tb /student_fir_tb/sample_in
add wave -noupdate -expand -group fir_tb /student_fir_tb/compute_finished_out
add wave -noupdate -expand -group fir_tb /student_fir_tb/sample_shift_out
add wave -noupdate -expand -group fir_tb /student_fir_tb/valid_strobe_out
add wave -noupdate -expand -group fir_tb /student_fir_tb/y_out
add wave -noupdate -expand -group sample_bram /student_fir_tb/dut/samples_dpram/bram
add wave -noupdate -group fir /student_fir_tb/dut/compute_finished_out
add wave -noupdate -group fir /student_fir_tb/dut/sample_shift_out
add wave -noupdate -group fir /student_fir_tb/dut/valid_strobe_out
add wave -noupdate -group fir /student_fir_tb/dut/y_out
add wave -noupdate -group fir /student_fir_tb/dut/ADDR_WIDTH
add wave -noupdate -group fir /student_fir_tb/dut/MAX_ADDR
add wave -noupdate -group fir /student_fir_tb/dut/ROM_FILE_COEFF
add wave -noupdate -group fir /student_fir_tb/dut/ROM_FILE_SAMPLES
add wave -noupdate -group fir /student_fir_tb/dut/wr_addr
add wave -noupdate -group fir /student_fir_tb/dut/rd_addr
add wave -noupdate -group fir /student_fir_tb/dut/rd_addr_c
add wave -noupdate -group fir /student_fir_tb/dut/read_coeff
add wave -noupdate -group fir /student_fir_tb/dut/read_sample
add wave -noupdate -group fir /student_fir_tb/dut/ena_samples
add wave -noupdate -group fir /student_fir_tb/dut/enb_samples
add wave -noupdate -group fir /student_fir_tb/dut/enb_coeff
add wave -noupdate -group fir /student_fir_tb/dut/fir_sum
add wave -noupdate -group fir /student_fir_tb/dut/fir_state
add wave -noupdate -group fir /student_fir_tb/dut/valid_strobe_in_prev
add wave -noupdate -group fir /student_fir_tb/dut/valid_strobe_in_pos_edge
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/clk_i
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/rst_ni
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/mem
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/enb
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/addrb
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/dob
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/tl_i
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/tl_o
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/req
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/we
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/addr
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/wdata
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/wmask
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/rdata
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/rvalid
add wave -noupdate -expand -group coeff_bram /student_fir_tb/dut/coeff_dpram/read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {934554391 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 295
configure wave -valuecolwidth 85
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
WaveRestoreZoom {0 fs} {12882925452066 fs}
