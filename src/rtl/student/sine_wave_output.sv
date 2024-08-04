module sine_wave_output (
    input logic clk,
    input logic rst_ni,
    input logic lrclk,
    output logic [15:0] sine_wave_out
);

    logic [15:0] sine_wave_mem [0:1023];
    logic [9:0] sin_cnt;
    logic one_time;

    // Read sine wave values from .mem file
    initial begin
        $readmemh("/home/rvlab/groups/rvlab01/Desktop/data/sin_low.mem", sine_wave_mem);
    end


logic lrclk_prev;
  logic lrclk_pos_edge;

  always_ff @(posedge clk, negedge rst_ni) begin
    if (~rst_ni) begin
      lrclk_prev <= 0;
    end else begin
      lrclk_prev <= lrclk;
    end
  end

 assign lrclk_pos_edge = lrclk && ~lrclk_prev;

 logic [15:0] sine_wave_out_int;

    // Output the sine wave values sequentially
    always_ff @(posedge clk, negedge rst_ni) begin
        if(!rst_ni) begin
            sin_cnt <= '0;
            one_time <= 0;
            sine_wave_out_int <= '0;
        end else begin
            if(one_time) begin
                sine_wave_out_int <= '0;
            end else begin 
                if(lrclk_pos_edge) begin
                    sine_wave_out_int <= sine_wave_mem[sin_cnt];
                    sin_cnt <= sin_cnt + 1;
                    if(sin_cnt == 500) one_time <= 1;
                end
            end
        end
    end

    assign sine_wave_out = sine_wave_out_int;

endmodule
