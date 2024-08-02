onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group I2S_CLOCK /student_fir_i2s_clk_tb/i2s_clock_gen/AC_MCLK
add wave -noupdate -group I2S_CLOCK /student_fir_i2s_clk_tb/i2s_clock_gen/AC_BCLK
add wave -noupdate -group I2S_CLOCK /student_fir_i2s_clk_tb/i2s_clock_gen/BCLK_Fall
add wave -noupdate -group I2S_CLOCK /student_fir_i2s_clk_tb/i2s_clock_gen/BCLK_Rise
add wave -noupdate -group I2S_CLOCK /student_fir_i2s_clk_tb/i2s_clock_gen/AC_LRCLK
add wave -noupdate -group I2S_CLOCK /student_fir_i2s_clk_tb/i2s_clock_gen/LRCLK_Fall
add wave -noupdate -group I2S_CLOCK /student_fir_i2s_clk_tb/i2s_clock_gen/LRCLK_Rise
add wave -noupdate -group fir_i2s_tb /student_fir_i2s_clk_tb/clk_i
add wave -noupdate -group fir_i2s_tb /student_fir_i2s_clk_tb/rst_ni
add wave -noupdate -group fir_i2s_tb /student_fir_i2s_clk_tb/valid_strobe_in
add wave -noupdate -group fir_i2s_tb /student_fir_i2s_clk_tb/sample_in
add wave -noupdate -group fir_i2s_tb /student_fir_i2s_clk_tb/sample_shift_out
add wave -noupdate -group fir_i2s_tb /student_fir_i2s_clk_tb/valid_strobe_out
add wave -noupdate -group fir_i2s_tb /student_fir_i2s_clk_tb/y_out
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/clk_i
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/rst_ni
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/ena
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/enb
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/wea
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/addra
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/addrb
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/dia
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/dob
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/tl_i
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/tl_o
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/req
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/we
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/addr
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/wdata
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/wmask
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/rdata
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/rvalid
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/ena_i
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/enb_i
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/wea_i
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/addra_i
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/addrb_i
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/dia_i
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/dob_i
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/dia_i_tlul
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/dia_i_tlul_prev
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/dia_o_tlul
add wave -noupdate -group coeff-dpram /student_fir_i2s_clk_tb/dut/coeff_dpram/write_active_tlul
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/clk_i
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/rst_ni
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/ena
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/enb
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/wea
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/addra
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/addrb
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/dia
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/dob
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/tl_i
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/tl_o
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/req
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/we
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/addr
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/wdata
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/wmask
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/rdata
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/rvalid
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/ena_i
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/enb_i
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/wea_i
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/addra_i
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/addrb_i
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/dia_i
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/dob_i
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/dia_i_tlul
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/dia_i_tlul_prev
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/dia_o_tlul
add wave -noupdate -group samples_dpram /student_fir_i2s_clk_tb/dut/samples_dpram/write_active_tlul
add wave -noupdate -group mux /student_fir_i2s_clk_tb/dut/tlul_mux_dpram/clk_i
add wave -noupdate -group mux /student_fir_i2s_clk_tb/dut/tlul_mux_dpram/rst_ni
add wave -noupdate -group mux /student_fir_i2s_clk_tb/dut/tlul_mux_dpram/tl_host_i
add wave -noupdate -group mux /student_fir_i2s_clk_tb/dut/tlul_mux_dpram/tl_host_o
add wave -noupdate -group mux /student_fir_i2s_clk_tb/dut/tlul_mux_dpram/select
add wave -noupdate -group mux /student_fir_i2s_clk_tb/dut/tlul_mux_dpram/is_curr
add wave -noupdate -group coeff_bram /student_fir_i2s_clk_tb/dut/coeff_dpram/dpram_samples/bram
add wave -noupdate -group samples-bram -expand /student_fir_i2s_clk_tb/dut/samples_dpram/dpram_samples/bram
add wave -noupdate /student_fir_i2s_clk_tb/dut/reg2hw
add wave -noupdate /student_fir_i2s_clk_tb/dut/hw2reg
add wave -noupdate /student_fir_i2s_clk_tb/dut/useTlulSample
add wave -noupdate /student_fir_i2s_clk_tb/dut/valid_strobe_in_prev
add wave -noupdate /student_fir_i2s_clk_tb/dut/valid_strobe_in_pos_edge
add wave -noupdate /student_fir_i2s_clk_tb/dut/sample_in_internal
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/sample_shift_out
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/sample_in_internal
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/valid_strobe_out
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/y_out
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/tl_i
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/tl_o
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/TLUL_DPRAM_DEVICES
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/tl_student_dpram_i
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/tl_student_dpram_o
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/reg2hw
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/hw2reg
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/MAX_ADDR
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/ROM_FILE_COEFF
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/ROM_FILE_SAMPLES
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/wr_addr
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/rd_addr
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/rd_addr_c
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/read_coeff
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/read_sample
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/ena_samples
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/enb_samples
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/enb_coeff
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/fir_sum
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/fir_state
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/valid_strobe_in_prev
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/valid_strobe_in_pos_edge
add wave -noupdate -expand -group fir_single /student_fir_i2s_clk_tb/dut/useTlulSample
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58024640000000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 451
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
WaveRestoreZoom {46225256250 ps} {118354149171687 fs}
