onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_LRCLK
add wave -noupdate /student_fir_DAC_SDATA_tb/LRCLK_Fall
add wave -noupdate /student_fir_DAC_SDATA_tb/LRCLK_Rise
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_MCLK
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_BCLK
add wave -noupdate /student_fir_DAC_SDATA_tb/BCLK_Fall
add wave -noupdate /student_fir_DAC_SDATA_tb/BCLK_Rise
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_DAC_SDATA
add wave -noupdate /student_fir_DAC_SDATA_tb/AC_ADC_SDATA
add wave -noupdate /student_fir_DAC_SDATA_tb/y_out
add wave -noupdate /student_fir_DAC_SDATA_tb/sample_in
add wave -noupdate /student_fir_DAC_SDATA_tb/valid_strobe_in
add wave -noupdate /student_fir_DAC_SDATA_tb/clk_i
add wave -noupdate /student_fir_DAC_SDATA_tb/rst_ni
add wave -noupdate /student_fir_DAC_SDATA_tb/sample_shift_out
add wave -noupdate /student_fir_DAC_SDATA_tb/valid_strobe_out
add wave -noupdate /student_fir_DAC_SDATA_tb/valid_strobe
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
configure wave -namecolwidth 332
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
WaveRestoreZoom {23240319999050 fs} {23240320003012 fs}
