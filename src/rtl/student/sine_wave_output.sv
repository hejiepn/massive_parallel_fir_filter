module sine_wave_output (
    input logic clk,
    input logic rst_ni,
    output logic [23:0] sine_wave_out
);

    logic [23:0] sine_wave_mem [0:1023];
    logic [9:0] sin_cnt;

    // Read sine wave values from .mem file
    initial begin
        $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie_fir_testing/risc-v-lab-group-01/src/rtl/student/data/sin_high.mem", sine_wave_mem);
    end

    // Output the sine wave values sequentially
    always_ff @(posedge clk, negedge rst_ni) begin
        if(!rst_ni) begin
            sin_cnt <= '0;
        end else begin
            sine_wave_out <= {'0,sine_wave_mem[sin_cnt]};
            sin_cnt <= sin_cnt + 1;
        end
    end

endmodule
