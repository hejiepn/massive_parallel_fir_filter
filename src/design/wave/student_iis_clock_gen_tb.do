onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/DATA_SIZE
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/AC_MCLK
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/AC_BCLK
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/BCLK_Fall
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/BCLK_Rise
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/AC_LRCLK
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/LRCLK_Fall
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/LRCLK_Rise
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/AC_MCLK_int
add wave -noupdate -expand -group clock_gen -radix unsigned /student_iis_clock_gen_tb/student_iis_clock_gen_inst/Cnt_BCLK
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/AC_BCLK_int
add wave -noupdate -expand -group clock_gen -radix unsigned /student_iis_clock_gen_tb/student_iis_clock_gen_inst/Cnt_LRCLK
add wave -noupdate -expand -group clock_gen /student_iis_clock_gen_tb/student_iis_clock_gen_inst/AC_LRCLK_int
add wave -noupdate /student_iis_clock_gen_tb/clk_i
add wave -noupdate /student_iis_clock_gen_tb/rst_ni
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11429312 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 447
configure wave -valuecolwidth 75
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
WaveRestoreZoom {11158018 fs} {11623710 fs}
