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
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/sample_shift_out
add wave -noupdate -group fir_single -format Analog-Step -height 84 -max 254.0 /student_fir_i2s_clk_tb/dut/sample_in_internal
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/valid_strobe_out
add wave -noupdate -group fir_single -format Analog-Step -height 84 -max 1.0 -min -1.0 -radix decimal /student_fir_i2s_clk_tb/dut/y_out
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/tl_i
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/tl_o
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/TLUL_DPRAM_DEVICES
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/tl_student_dpram_i
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/tl_student_dpram_o
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/reg2hw
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/hw2reg
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/MAX_ADDR
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/ROM_FILE_COEFF
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/ROM_FILE_SAMPLES
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/wr_addr
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/rd_addr
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/rd_addr_c
add wave -noupdate -group fir_single -radix decimal /student_fir_i2s_clk_tb/dut/read_coeff
add wave -noupdate -group fir_single -radix decimal /student_fir_i2s_clk_tb/dut/read_sample
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/ena_samples
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/enb_samples
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/enb_coeff
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/fir_sum
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/fir_state
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/valid_strobe_in_prev
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/valid_strobe_in_pos_edge
add wave -noupdate -group fir_single /student_fir_i2s_clk_tb/dut/useTlulSample
add wave -noupdate /student_fir_i2s_clk_tb/dut/samples_dpram/dpram_samples/bram
add wave -noupdate /student_fir_i2s_clk_tb/dut/coeff_dpram/dpram_samples/bram
add wave -noupdate /student_fir_i2s_clk_tb/dut/sample_in_internal
add wave -noupdate /student_fir_i2s_clk_tb/dut/y_out
add wave -noupdate /student_fir_i2s_clk_tb/dut/y_out_1
add wave -noupdate /student_fir_i2s_clk_tb/dut/y_out_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11077040000000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 367
configure wave -valuecolwidth 186
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
WaveRestoreZoom {9690634779345 fs} {19643595282779 fs}
