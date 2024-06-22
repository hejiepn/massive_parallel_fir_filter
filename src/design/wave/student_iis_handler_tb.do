onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group I2S /student_iis_handler_tb/clk
add wave -noupdate -group I2S /student_iis_handler_tb/rst_n
add wave -noupdate -group I2S /student_iis_handler_tb/AC_MCLK
add wave -noupdate -group I2S /student_iis_handler_tb/AC_BCLK
add wave -noupdate -group I2S /student_iis_handler_tb/AC_LRCLK
add wave -noupdate -group I2S /student_iis_handler_tb/AC_ADC_SDATA
add wave -noupdate -group I2S /student_iis_handler_tb/AC_DAC_SDATA
add wave -noupdate -group I2S /student_iis_handler_tb/Data_I_L
add wave -noupdate -group I2S /student_iis_handler_tb/Data_I_R
add wave -noupdate -group I2S /student_iis_handler_tb/Data_O_L
add wave -noupdate -group I2S /student_iis_handler_tb/Data_O_R
add wave -noupdate -group I2S /student_iis_handler_tb/valid_strobe
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
WaveRestoreZoom {3072019999050 fs} {3072020000050 fs}
