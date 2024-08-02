onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group adder_tree /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/adder_tree_i/idata
add wave -noupdate -group adder_tree /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/adder_tree_i/odata
add wave -noupdate -group adder_tree /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/adder_tree_i/data
add wave -noupdate -group fir_parallle /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/y_out_internal
add wave -noupdate -group fir_parallle /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/sample_in_internal_first
add wave -noupdate -group fir_parallle /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/valid_strobe_in_prev
add wave -noupdate -group fir_parallle /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/valid_strobe_in_pos_edge
add wave -noupdate -group fir_parallle /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/adder_tree_y_out
add wave -noupdate -group fir_parallle /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/reg2hw
add wave -noupdate -group fir_parallle /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/hw2reg
add wave -noupdate -group fir_parallle /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/valid_strobe_out
add wave -noupdate -group fir_parallle /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/y_out
add wave -noupdate -group i2s /student_fir_parallel_i2s_clk_tb/i2s_clock_gen/AC_BCLK
add wave -noupdate -group i2s /student_fir_parallel_i2s_clk_tb/i2s_clock_gen/BCLK_Fall
add wave -noupdate -group i2s /student_fir_parallel_i2s_clk_tb/i2s_clock_gen/BCLK_Rise
add wave -noupdate -group i2s /student_fir_parallel_i2s_clk_tb/i2s_clock_gen/AC_LRCLK
add wave -noupdate -group i2s /student_fir_parallel_i2s_clk_tb/i2s_clock_gen/LRCLK_Fall
add wave -noupdate -group i2s /student_fir_parallel_i2s_clk_tb/i2s_clock_gen/LRCLK_Rise
add wave -noupdate -group fir-parall_tb /student_fir_parallel_i2s_clk_tb/clk_i
add wave -noupdate -group fir-parall_tb /student_fir_parallel_i2s_clk_tb/rst_ni
add wave -noupdate -group fir-parall_tb /student_fir_parallel_i2s_clk_tb/valid_strobe_in
add wave -noupdate -group fir-parall_tb /student_fir_parallel_i2s_clk_tb/sample_in
add wave -noupdate -group fir-parall_tb /student_fir_parallel_i2s_clk_tb/sample_shift_out
add wave -noupdate -group fir-parall_tb /student_fir_parallel_i2s_clk_tb/valid_strobe_out
add wave -noupdate -group fir-parall_tb /student_fir_parallel_i2s_clk_tb/y_out
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/valid_strobe_out
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/y_out
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/tl_i
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/tl_o
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/tl_student_fir_i
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/tl_student_fir_o
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/reg2hw
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/hw2reg
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/sample_shift_out_internal
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/sample_shift_in_internal
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/valid_strobe_out_internal
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/y_out_internal
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/sample_in_internal_first
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/valid_strobe_in_prev
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/valid_strobe_in_pos_edge
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/useTlulSample
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/adder_tree_y_out
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/stageNum
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/stageCounter
add wave -noupdate -group fir_parallel /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/waitAdder
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/reg2hw}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/hw2reg}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/sample_in_internal}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[1]/genblk1/fir_i_middle/reg2hw}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[1]/genblk1/fir_i_middle/hw2reg}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[1]/genblk1/fir_i_middle/sample_in_internal}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[5]/genblk1/fir_i_middle/reg2hw}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[5]/genblk1/fir_i_middle/hw2reg}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[5]/genblk1/fir_i_middle/sample_in_internal}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[7]/genblk1/fir_i_middle/reg2hw}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[7]/genblk1/fir_i_middle/hw2reg}
add wave -noupdate {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[7]/genblk1/fir_i_middle/sample_in_internal}
add wave -noupdate -group fir0_bram_samples {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/samples_dpram/req}
add wave -noupdate -group fir0_bram_samples {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/samples_dpram/we}
add wave -noupdate -group fir0_bram_samples {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[0]/genblk1/fir_i_first/samples_dpram/dpram_samples/bram}
add wave -noupdate -group fir4_bram_coeff {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[4]/genblk1/fir_i_middle/coeff_dpram/req}
add wave -noupdate -group fir4_bram_coeff {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[4]/genblk1/fir_i_middle/coeff_dpram/we}
add wave -noupdate -group fir4_bram_coeff {/student_fir_parallel_i2s_clk_tb/dut_fir_parallel/fir[4]/genblk1/fir_i_middle/coeff_dpram/dpram_samples/bram}
add wave -noupdate /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/useSineWave
add wave -noupdate /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/y_out_int_int
add wave -noupdate /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/y_out
add wave -noupdate /student_fir_parallel_i2s_clk_tb/dut_fir_parallel/y_out_internal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5362080000000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 693
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
WaveRestoreZoom {0 fs} {66963491381562 fs}
