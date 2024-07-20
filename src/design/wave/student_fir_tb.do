onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group bram_coeff /student_fir_tb/dut/coeff_dpram/dpram_samples/AddrWidth
add wave -noupdate -group bram_coeff /student_fir_tb/dut/coeff_dpram/dpram_samples/DataSize
add wave -noupdate -group bram_coeff /student_fir_tb/dut/coeff_dpram/dpram_samples/DebugMode
add wave -noupdate -group bram_coeff /student_fir_tb/dut/coeff_dpram/dpram_samples/dob
add wave -noupdate -group bram_coeff /student_fir_tb/dut/coeff_dpram/dpram_samples/temp_bram
add wave -noupdate -group bram_coeff /student_fir_tb/dut/coeff_dpram/dpram_samples/bram
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/AddrWidth
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/DataSize
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/DebugMode
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/dob
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/tl_i
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/tl_o
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/TL_DataSize
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/req
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/we
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/addr
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/wdata
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/wmask
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/rdata
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/rvalid
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/ena_i
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/enb_i
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/wea_i
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/addra_i
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/addrb_i
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/dia_i
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/dob_i
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/dia_i_tlul
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/dia_i_tlul_prev
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/dia_o_tlul
add wave -noupdate -group dpram_coeff /student_fir_tb/dut/coeff_dpram/write_active_tlul
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/AddrWidth
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/DataSize
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/DebugMode
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/dob
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/tl_i
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/tl_o
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/TL_DataSize
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/req
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/we
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/addr
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/wdata
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/wmask
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/rdata
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/rvalid
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/ena_i
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/enb_i
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/wea_i
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/addra_i
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/addrb_i
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/dia_i
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/dob_i
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/dia_i_tlul
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/dia_i_tlul_prev
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/dia_o_tlul
add wave -noupdate -group dpram_samples /student_fir_tb/dut/samples_dpram/write_active_tlul
add wave -noupdate -group bram_samples /student_fir_tb/dut/samples_dpram/dpram_samples/AddrWidth
add wave -noupdate -group bram_samples /student_fir_tb/dut/samples_dpram/dpram_samples/DataSize
add wave -noupdate -group bram_samples /student_fir_tb/dut/samples_dpram/dpram_samples/DebugMode
add wave -noupdate -group bram_samples /student_fir_tb/dut/samples_dpram/dpram_samples/dob
add wave -noupdate -group bram_samples /student_fir_tb/dut/samples_dpram/dpram_samples/temp_bram
add wave -noupdate -group bram_samples -expand /student_fir_tb/dut/samples_dpram/dpram_samples/bram
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/NUM
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/ADDR_WIDTH
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/ADDR_OFFSET
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/CURR_OFFSET
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/CURR_WIDTH
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/CURR_VAL
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/tl_host_i
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/tl_host_o
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/tl_device_o
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/tl_device_i
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/select
add wave -noupdate -group tlul_mux /student_fir_tb/dut/tlul_mux_dpram/is_curr
add wave -noupdate -group fir /student_fir_tb/dut/ADDR_WIDTH
add wave -noupdate -group fir /student_fir_tb/dut/DATA_SIZE
add wave -noupdate -group fir /student_fir_tb/dut/DEBUGMODE
add wave -noupdate -group fir /student_fir_tb/dut/DATA_SIZE_FIR_OUT
add wave -noupdate -group fir /student_fir_tb/dut/compute_finished_out
add wave -noupdate -group fir /student_fir_tb/dut/sample_shift_out
add wave -noupdate -group fir /student_fir_tb/dut/valid_strobe_out
add wave -noupdate -group fir /student_fir_tb/dut/y_out
add wave -noupdate -group fir /student_fir_tb/dut/tl_i
add wave -noupdate -group fir /student_fir_tb/dut/tl_o
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
add wave -noupdate -group fir /student_fir_tb/dut/TLUL_DPRAM_DEVICES
add wave -noupdate -group fir /student_fir_tb/dut/tl_student_dpram_i
add wave -noupdate -group fir /student_fir_tb/dut/tl_student_dpram_o
add wave -noupdate -group fir_tb /student_fir_tb/AddrWidth
add wave -noupdate -group fir_tb /student_fir_tb/MaxAddr
add wave -noupdate -group fir_tb /student_fir_tb/DATA_SIZE
add wave -noupdate -group fir_tb /student_fir_tb/DEBUGMODE
add wave -noupdate -group fir_tb /student_fir_tb/DATA_SIZE_FIR_OUT
add wave -noupdate -group fir_tb /student_fir_tb/clk_i
add wave -noupdate -group fir_tb /student_fir_tb/rst_ni
add wave -noupdate -group fir_tb /student_fir_tb/valid_strobe_in
add wave -noupdate -group fir_tb /student_fir_tb/sample_in
add wave -noupdate -group fir_tb /student_fir_tb/compute_finished_out
add wave -noupdate -group fir_tb /student_fir_tb/sample_shift_out
add wave -noupdate -group fir_tb /student_fir_tb/valid_strobe_out
add wave -noupdate -group fir_tb /student_fir_tb/y_out
add wave -noupdate -group fir_tb /student_fir_tb/sin_mem
add wave -noupdate -group fir_tb /student_fir_tb/i
add wave -noupdate -group fir_tb /student_fir_tb/tl_h2d
add wave -noupdate -group fir_tb /student_fir_tb/tl_d2h
add wave -noupdate -group fir_tb /student_fir_tb/clk_count
add wave -noupdate -group fir_tb /student_fir_tb/counting
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {783596967 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 447
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
WaveRestoreZoom {0 fs} {1176210 ps}
