module fir_filter (
    input logic clk_i,
    input logic rst_ni,
    input logic valid_strobe,
    input logic [15:0] data_in,
    output logic [15:0] data_out
);

  logic [15:0] delay_line_out [4:0];
  logic [15:0] coefficient;
  logic [15:0] fir_sum;
  logic [2:0] coef_addr;

  // Instantiate delay line buffer
  fir_ringbuffer delay_line (
      .clk_i(clk_i),
      .rst_ni(rst_ni),
      .valid_strobe(valid_strobe),
      .data_in(data_in),
      .data_out(delay_line_out)
  );

  // Instantiate coefficient memory
  coefficient_bram coef_bram (
      .raddr(coef_addr),
      .rdata(coefficient)
  );

  // FIR computation
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      data_out <= 16'h0;
      fir_sum <= 16'h0;
      coef_addr <= 3'h0;
    end else if (valid_strobe) begin
      fir_sum <= 16'h0;
      for (int i = 0; i < 5; i++) begin
        coef_addr <= i[2:0];
        fir_sum <= fir_sum + delay_line_out[i] * coefficient;
      end
      data_out <= fir_sum;
    end
  end

endmodule
