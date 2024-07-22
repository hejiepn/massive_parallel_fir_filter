module student_adder #(
  parameter int unsigned DATA_SIZE_FIR_OUT = 32,
  parameter int unsigned NUM_FIR = 10
)(
  input logic clk,
  input logic rst_ni,
  input logic valid_strobe_in_a,
  input logic valid_strobe_in_b,
  input logic [DATA_SIZE_FIR_OUT-2:0] fir_out_a,
  input logic [DATA_SIZE_FIR_OUT-2:0] fir_out_b,
  output logic [DATA_SIZE_FIR_OUT:0] odata,
  output logic valid_strobe_out
);

  // Internal register to store the sum
  logic [DATA_SIZE_FIR_OUT:0] sum;
  logic valid_reg;

  always_ff @(posedge clk or negedge rst_ni) begin
    if (~rst_ni) begin
      sum <= '0; // Reset sum to zero
      valid_reg <= 0; // Reset valid register
    end else begin
      if (valid_strobe_in_a && valid_strobe_in_b) begin
        sum <= fir_out_a + fir_out_b; // Add inputs when both valid signals are high
        valid_reg <= 1; // Set valid register when inputs are valid
      end else begin
        valid_reg <= 0; // Clear valid register when inputs are not valid
      end
    end
  end

  assign odata = sum;
  assign valid_strobe_out = valid_reg;

endmodule
