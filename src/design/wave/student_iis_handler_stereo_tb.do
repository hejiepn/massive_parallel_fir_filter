onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/clk
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/rst_n
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/AC_MCLK
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/AC_BCLK
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/AC_LRCLK
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/AC_ADC_SDATA
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/AC_DAC_SDATA
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/Data_I_L
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/Data_I_R
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/Data_O_L
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/Data_O_R
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/valid_strobe
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/TEST_Data_I_L
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/TEST_Data_I_R
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/TEST_Data_O_L
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/TEST_Data_O_R
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/temp_l
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/temp_r
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/fd_r
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/fd_w
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/line
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/num_cycles
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/succeeded
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/failed
add wave -noupdate -expand -group iis_stereo_tb /student_iis_handler_stereo_tb/f_err
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/AC_MCLK
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/AC_BCLK
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/AC_LRCLK
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/AC_DAC_SDATA
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/Data_O_L
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/Data_O_R
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/valid_strobe
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/Cnt_BCLK
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/AC_BCLK_int
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/BCLK_Fall
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/BCLK_Rise
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/Cnt_LRCLK
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/AC_LRCLK_int
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/LRCLK_Fall
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/LRCLK_Rise
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/Data_Out_int
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/Data_O_L_int
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/Data_O_R_int
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/Data_In_int
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/rising_edge_cnt
add wave -noupdate -expand -group iis_stereo /student_iis_handler_stereo_tb/DUT/valid_strobe_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11480074740 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 349
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 fs} {44286954992 fs}
