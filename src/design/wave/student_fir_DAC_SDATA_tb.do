onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_LRCLK
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_MCLK
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_BCLK
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_DAC_SDATA
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_ADC_SDATA
add wave -noupdate /student_fir_DAC_SDATA_tb/y_out
add wave -noupdate /student_fir_DAC_SDATA_tb/sample_in
add wave -noupdate /student_fir_DAC_SDATA_tb/clk_i
add wave -noupdate /student_fir_DAC_SDATA_tb/rst_ni
add wave -noupdate /student_fir_DAC_SDATA_tb/valid_strobe_out
add wave -noupdate /student_fir_DAC_SDATA_tb/valid_strobe
add wave -noupdate -group i2s_rx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_receiver_inst/Data_O_R
add wave -noupdate -group i2s_rx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_receiver_inst/Data_O_L
add wave -noupdate -group i2s_rx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_receiver_inst/valid_strobe
add wave -noupdate -group i2s_rx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_receiver_inst/Data_O_L_int
add wave -noupdate -group i2s_rx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_receiver_inst/Data_O_R_int
add wave -noupdate -group i2s_rx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_receiver_inst/Data_In_int
add wave -noupdate -group i2s_rx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_receiver_inst/rising_edge_cnt
add wave -noupdate -group i2s_rx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_receiver_inst/valid_strobe_int
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/sample_shift_out}
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/valid_strobe_out}
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/y_out}
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/reg2hw}
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/hw2reg}
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/fir_sum}
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/sample_in_internal}
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/fir_state}
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/valid_strobe_in_prev}
add wave -noupdate -group fir_0 {/student_fir_DAC_SDATA_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/valid_strobe_in_pos_edge}
add wave -noupdate -expand -group i2s_tx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_transmitter_inst/AC_DAC_SDATA
add wave -noupdate -expand -group i2s_tx /student_fir_DAC_SDATA_tb/student_iis_handler_top_ins/student_iis_transmitter_inst/Data_Out_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3306460000000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 630
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
WaveRestoreZoom {20631579220461 fs} {33488052918670 fs}
