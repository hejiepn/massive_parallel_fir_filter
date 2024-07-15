onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/AddrWidth
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/DataSize
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/DEBUGMODE
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/clk_i
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/rst_ni
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/ena
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/enb
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/wea
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/addra
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/addrb
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/dia
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/dob
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/tl_h2d
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/tl_d2h
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/write_ptr
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/read_ptr
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/expected_data
add wave -noupdate -group dpram_samples_tlul_tb /student_dpram_samples_tlul_tb/error_flag
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/AddrWidth
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/DataSize
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/DebugMode
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/dob
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/tl_i
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/tl_o
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/TL_DataSize
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/req
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/we
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/addr
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/wdata
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/wmask
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/rdata
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/rvalid
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/temp_bram
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/read_data
add wave -noupdate -group dpram_samples_tlul /student_dpram_samples_tlul_tb/dut/bram
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
WaveRestoreZoom {699999050 fs} {699999904 fs}
