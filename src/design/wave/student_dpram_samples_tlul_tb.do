onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group bram /student_dpram_samples_tlul_tb/dut/dpram_samples/dob
add wave -noupdate -expand -group bram -expand /student_dpram_samples_tlul_tb/dut/dpram_samples/bram
add wave -noupdate -expand -group tl_adapter_sram /student_dpram_samples_tlul_tb/dut/adapter_i/tl_i
add wave -noupdate -expand -group tl_adapter_sram /student_dpram_samples_tlul_tb/dut/adapter_i/tl_o
add wave -noupdate -expand -group tl_adapter_sram /student_dpram_samples_tlul_tb/dut/adapter_i/req_o
add wave -noupdate -expand -group tl_adapter_sram /student_dpram_samples_tlul_tb/dut/adapter_i/we_o
add wave -noupdate -expand -group tl_adapter_sram /student_dpram_samples_tlul_tb/dut/write_active_tlul
add wave -noupdate -expand -group tl_adapter_sram /student_dpram_samples_tlul_tb/dut/adapter_i/addr_o
add wave -noupdate -expand -group tl_adapter_sram /student_dpram_samples_tlul_tb/dut/adapter_i/wdata_o
add wave -noupdate -expand -group tl_adapter_sram /student_dpram_samples_tlul_tb/dut/adapter_i/wmask_o
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/AddrWidth
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/DataSize
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/DebugMode
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/dob
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/tl_i
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/tl_o
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/TL_DataSize
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/req
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/we
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/addr
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/wdata
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/wmask
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/rdata
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/rvalid
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/ena_i
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/enb_i
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/wea_i
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/addra_i
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/addrb_i
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/dia_i
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/dob_i
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/dia_i_tlul
add wave -noupdate -expand -group dut /student_dpram_samples_tlul_tb/dut/dia_o_tlul
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {788896216 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 416
configure wave -valuecolwidth 190
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
WaveRestoreZoom {0 fs} {2494800 ps}
