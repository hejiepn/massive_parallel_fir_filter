onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /student_iis_handler_top_tb/clk
add wave -noupdate /student_iis_handler_top_tb/rst_n
add wave -noupdate /student_iis_handler_top_tb/AC_MCLK
add wave -noupdate /student_iis_handler_top_tb/AC_BCLK
add wave -noupdate /student_iis_handler_top_tb/AC_LRCLK
add wave -noupdate /student_iis_handler_top_tb/AC_ADC_SDATA
add wave -noupdate /student_iis_handler_top_tb/AC_DAC_SDATA
add wave -noupdate /student_iis_handler_top_tb/Data_I_L
add wave -noupdate /student_iis_handler_top_tb/Data_I_R
add wave -noupdate /student_iis_handler_top_tb/Data_O_L
add wave -noupdate /student_iis_handler_top_tb/Data_O_R
add wave -noupdate /student_iis_handler_top_tb/valid_strobe
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/DATA_SIZE
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/DATA_SIZE_FIR_OUT
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/AC_MCLK
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/AC_BCLK
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/AC_LRCLK
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/AC_DAC_SDATA
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/Data_O_L
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/Data_O_R
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/tl_i
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/tl_o
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/valid_strobe
add wave -noupdate -expand -group dut -expand -subitemconfig {/student_iis_handler_top_tb/DUT/reg2hw.serial_in -expand} /student_iis_handler_top_tb/DUT/reg2hw
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/hw2reg
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/ADC_SDATA_int
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/BCLK_Fall_int
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/BCLK_Rise_int
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/tlulCnt
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/useTLUL
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/LRCLK_Fall_int
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/LRCLK_Rise_int
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/ADC_SDATA_tlul
add wave -noupdate -expand -group dut /student_iis_handler_top_tb/DUT/serial_in_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {307300000000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 341
configure wave -valuecolwidth 198
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
WaveRestoreZoom {1020 ns} {429420 ns}
