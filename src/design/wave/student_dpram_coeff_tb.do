onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/AddrWidth
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/CoeffDataSize
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/DebugMode
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/dob
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/tl_i
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/tl_o
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/DataSize
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/req
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/we
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/addr
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/wdata
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/wmask
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/rdata
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/rvalid
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/read_data
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/temp_bram
add wave -noupdate -expand -group dpram_coeff /student_dpram_coeff_tb/dut/mem
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/AddrWidth
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/DataSize
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/DEBUGMODE
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/MaxAddr
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/clk
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/rst_ni
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/enb
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/addrb
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/dob
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/tl_h2d
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/tl_d2h
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/expected_data
add wave -noupdate -expand -group dpram_ceoff_tb /student_dpram_coeff_tb/error_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
configure wave -namecolwidth 307
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
WaveRestoreZoom {0 fs} {195478942 fs}
