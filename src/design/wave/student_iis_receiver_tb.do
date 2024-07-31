onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/tl_d2h
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/tl_h2d
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/clk_i
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/rst_ni
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/AC_MCLK
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/AC_BCLK
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/AC_LRCLK
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/AC_ADC_SDATA
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/AC_DAC_SDATA
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/Data_rx
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/valid_strobe_rx
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/BCLK_Fall_int
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/BCLK_Rise_int
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/LRCLK_Fall_int
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/LRCLK_Rise_int
add wave -noupdate -expand -group iis_rx_tb /student_iis_receiver_tb/TEST_Data_I
add wave -noupdate -expand -group iis_rx /student_iis_receiver_tb/student_iis_receiver_inst/Data_O
add wave -noupdate -expand -group iis_rx /student_iis_receiver_tb/student_iis_receiver_inst/valid_strobe
add wave -noupdate -expand -group iis_rx /student_iis_receiver_tb/student_iis_receiver_inst/Data_O_L_int
add wave -noupdate -expand -group iis_rx /student_iis_receiver_tb/student_iis_receiver_inst/Data_O_R_int
add wave -noupdate -expand -group iis_rx /student_iis_receiver_tb/student_iis_receiver_inst/Data_In_int
add wave -noupdate -expand -group iis_rx /student_iis_receiver_tb/student_iis_receiver_inst/rising_edge_cnt
add wave -noupdate -expand -group iis_rx /student_iis_receiver_tb/student_iis_receiver_inst/valid_strobe_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40509991130 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 364
configure wave -valuecolwidth 269
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
WaveRestoreZoom {40509985642 fs} {40509994114 fs}
