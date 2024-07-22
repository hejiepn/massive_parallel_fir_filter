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
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/sample_shift_out}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/valid_strobe_out}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/y_out}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/tl_i}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/tl_o}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/TLUL_DPRAM_DEVICES}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/tl_student_dpram_i}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/tl_student_dpram_o}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/reg2hw}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/hw2reg}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/MAX_ADDR}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/ROM_FILE_COEFF}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/ROM_FILE_SAMPLES}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/wr_addr}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/rd_addr}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/rd_addr_c}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/read_coeff}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/read_sample}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/ena_samples}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/enb_samples}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/enb_coeff}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/fir_sum}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/sample_in_internal}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/fir_state}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/valid_strobe_in_prev}
add wave -noupdate -group fir_first {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/valid_strobe_in_pos_edge}
add wave -noupdate -group fir_first_bram_samples {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/samples_dpram/dpram_samples/clk_i}
add wave -noupdate -group fir_first_bram_samples {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/samples_dpram/dpram_samples/ena}
add wave -noupdate -group fir_first_bram_samples {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/samples_dpram/dpram_samples/enb}
add wave -noupdate -group fir_first_bram_samples {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/samples_dpram/dpram_samples/wea}
add wave -noupdate -group fir_first_bram_samples {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/samples_dpram/dpram_samples/addra}
add wave -noupdate -group fir_first_bram_samples {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/samples_dpram/dpram_samples/addrb}
add wave -noupdate -group fir_first_bram_samples {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/samples_dpram/dpram_samples/dia}
add wave -noupdate -group fir_first_bram_samples {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/samples_dpram/dpram_samples/dob}
add wave -noupdate -group fir_first_bram_coeff {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/coeff_dpram/dpram_samples/clk_i}
add wave -noupdate -group fir_first_bram_coeff {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/coeff_dpram/dpram_samples/ena}
add wave -noupdate -group fir_first_bram_coeff {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/coeff_dpram/dpram_samples/enb}
add wave -noupdate -group fir_first_bram_coeff {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/coeff_dpram/dpram_samples/wea}
add wave -noupdate -group fir_first_bram_coeff {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/coeff_dpram/dpram_samples/addra}
add wave -noupdate -group fir_first_bram_coeff {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/coeff_dpram/dpram_samples/addrb}
add wave -noupdate -group fir_first_bram_coeff {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/coeff_dpram/dpram_samples/dia}
add wave -noupdate -group fir_first_bram_coeff {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/coeff_dpram/dpram_samples/dob}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/clk_i}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/rst_ni}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/valid_strobe_in}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/sample_in}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/sample_shift_out}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/valid_strobe_out}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/y_out}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/tl_i}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/tl_o}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/reg2hw}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/hw2reg}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/wr_addr}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/rd_addr}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/rd_addr_c}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/read_coeff}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/read_sample}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/ena_samples}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/enb_samples}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/enb_coeff}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/fir_sum}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/sample_in_internal}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/fir_state}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/valid_strobe_in_prev}
add wave -noupdate -group fir_middle {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/valid_strobe_in_pos_edge}
add wave -noupdate -group fir_middle_bram_samples {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/samples_dpram/dpram_samples/clk_i}
add wave -noupdate -group fir_middle_bram_samples {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/samples_dpram/dpram_samples/ena}
add wave -noupdate -group fir_middle_bram_samples {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/samples_dpram/dpram_samples/enb}
add wave -noupdate -group fir_middle_bram_samples {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/samples_dpram/dpram_samples/wea}
add wave -noupdate -group fir_middle_bram_samples {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/samples_dpram/dpram_samples/addra}
add wave -noupdate -group fir_middle_bram_samples {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/samples_dpram/dpram_samples/addrb}
add wave -noupdate -group fir_middle_bram_samples {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/samples_dpram/dpram_samples/dia}
add wave -noupdate -group fir_middle_bram_samples {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/samples_dpram/dpram_samples/dob}
add wave -noupdate -group fir_middle_bram_coeff {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/coeff_dpram/dpram_samples/clk_i}
add wave -noupdate -group fir_middle_bram_coeff {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/coeff_dpram/dpram_samples/ena}
add wave -noupdate -group fir_middle_bram_coeff {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/coeff_dpram/dpram_samples/enb}
add wave -noupdate -group fir_middle_bram_coeff {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/coeff_dpram/dpram_samples/wea}
add wave -noupdate -group fir_middle_bram_coeff {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/coeff_dpram/dpram_samples/addra}
add wave -noupdate -group fir_middle_bram_coeff {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/coeff_dpram/dpram_samples/addrb}
add wave -noupdate -group fir_middle_bram_coeff {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/coeff_dpram/dpram_samples/dia}
add wave -noupdate -group fir_middle_bram_coeff {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/coeff_dpram/dpram_samples/dob}
add wave -noupdate -group fir_first_control_sig {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/wr_addr}
add wave -noupdate -group fir_first_control_sig {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/rd_addr}
add wave -noupdate -group fir_first_control_sig {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/rd_addr_c}
add wave -noupdate -group fir_first_control_sig {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/read_coeff}
add wave -noupdate -group fir_first_control_sig {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/read_sample}
add wave -noupdate -group fir_first_control_sig {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/ena_samples}
add wave -noupdate -group fir_first_control_sig {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/enb_samples}
add wave -noupdate -group fir_first_control_sig {/student_fir_parallel_tb/dut/fir[0]/genblk1/fir_i_first/enb_coeff}
add wave -noupdate -group fir_middle_control_sig {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/wr_addr}
add wave -noupdate -group fir_middle_control_sig {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/rd_addr}
add wave -noupdate -group fir_middle_control_sig {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/rd_addr_c}
add wave -noupdate -group fir_middle_control_sig {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/read_coeff}
add wave -noupdate -group fir_middle_control_sig {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/read_sample}
add wave -noupdate -group fir_middle_control_sig {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/ena_samples}
add wave -noupdate -group fir_middle_control_sig {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/enb_samples}
add wave -noupdate -group fir_middle_control_sig {/student_fir_parallel_tb/dut/fir[1]/genblk1/fir_i_middle/enb_coeff}
add wave -noupdate -expand -group adder_tree /student_fir_parallel_tb/dut/adder_tree_i/idata
add wave -noupdate -expand -group adder_tree /student_fir_parallel_tb/dut/adder_tree_i/odata
add wave -noupdate -expand -group adder_tree /student_fir_parallel_tb/dut/adder_tree_i/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1240000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 501
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
WaveRestoreZoom {0 fs} {1071969 fs}
