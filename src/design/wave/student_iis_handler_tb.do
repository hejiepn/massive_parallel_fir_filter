onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group i2s /student_iis_handler_tb/clk
add wave -noupdate -group i2s /student_iis_handler_tb/rst_n
add wave -noupdate -group i2s /student_iis_handler_tb/AC_MCLK
add wave -noupdate -group i2s /student_iis_handler_tb/AC_BCLK
add wave -noupdate -group i2s /student_iis_handler_tb/AC_LRCLK
add wave -noupdate -group i2s /student_iis_handler_tb/AC_ADC_SDATA
add wave -noupdate -group i2s /student_iis_handler_tb/AC_DAC_SDATA
add wave -noupdate -group i2s /student_iis_handler_tb/valid_strobe
add wave -noupdate -group i2s /student_iis_handler_tb/valid_strobe_O
add wave -noupdate /student_iis_handler_tb/Data_O
add wave -noupdate /student_iis_handler_tb/Data_I
add wave -noupdate /student_iis_handler_tb/TEST_Data_I
add wave -noupdate /student_iis_handler_tb/TEST_Data_O
add wave -noupdate /student_iis_handler_tb/temp_l
add wave -noupdate /student_iis_handler_tb/tl_d2h
add wave -noupdate /student_iis_handler_tb/tl_h2d
add wave -noupdate /student_iis_handler_tb/DUT/reg2hw
add wave -noupdate -subitemconfig {/student_iis_handler_tb/DUT/hw2reg.serial_out -expand} /student_iis_handler_tb/DUT/hw2reg
add wave -noupdate /student_iis_handler_tb/DUT/Data_Out_int
add wave -noupdate /student_iis_handler_tb/DUT/new_serial_in_out
add wave -noupdate /student_iis_handler_tb/DUT/AC_MCLK
add wave -noupdate /student_iis_handler_tb/DUT/AC_BCLK
add wave -noupdate /student_iis_handler_tb/DUT/AC_LRCLK
add wave -noupdate /student_iis_handler_tb/DUT/AC_DAC_SDATA
add wave -noupdate /student_iis_handler_tb/DUT/serial_in
add wave -noupdate /student_iis_handler_tb/DUT/serial_out
add wave -noupdate /student_iis_handler_tb/DUT/pcm_in
add wave -noupdate /student_iis_handler_tb/DUT/pcm_in_prev
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26140000000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 349
configure wave -valuecolwidth 158
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
WaveRestoreZoom {0 fs} {40276026846 fs}
