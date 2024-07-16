module fir_filter (
    input logic clk_i,
    input logic rst_ni,
    input logic valid_strobe,
    input logic [15:0] data_in,
    output logic [15:0] data_out
);

  logic [15:0] delay_line_out [10:0];
  logic [15:0] coefficients [10:0];
  logic [15:0] products [10:0];
  logic [15:0] sum_stage1 [5:0];
  logic [15:0] sum_stage2 [2:0];
  logic [15:0] sum_stage3 [1:0];
  logic [15:0] fir_sum;

  // Instantiate delay line buffer
  fir_ringbuffer delay_line (
      .clk_i(clk_i),
      .rst_ni(rst_ni),
      .valid_strobe(valid_strobe),
      .data_in(data_in),
      .data_out(delay_line_out)
  );

  // Instantiate coefficient memory
  generate
    genvar i;
    for (i = 0; i < 11; i++) begin
      coefficient_bram coef_bram (
        .raddr(i),
        .rdata(coefficients[i])
      );
    end
  endgenerate

  // Compute products
  generate
    for (i = 0; i < 11; i++) begin
      always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni) begin
          products[i] <= 16'h0;
        end else if (valid_strobe) begin
          products[i] <= delay_line_out[i] * coefficients[i];
        end
      end
    end
  endgenerate

  // Sum stage 1 (11 to 6)
  generate
    for (i = 0; i < 5; i++) begin
      always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni) begin
          sum_stage1[i] <= 16'h0;
        end else if (valid_strobe) begin
          sum_stage1[i] <= products[2*i] + products[2*i+1];
        end
      end
    end
  endgenerate

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      sum_stage1[5] <= 16'h0;
    end else if (valid_strobe) begin
      sum_stage1[5] <= products[10];
    end
  end

  // Sum stage 2 (6 to 3)
  generate
    for (i = 0; i < 3; i++) begin
      always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni) begin
          sum_stage2[i] <= 16'h0;
        end else if (valid_strobe) begin
          sum_stage2[i] <= sum_stage1[2*i] + sum_stage1[2*i+1];
        end
      end
    end
  endgenerate

  // Sum stage 3 (3 to 1)
  generate
    for (i = 0; i < 1; i++) begin
      always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni) begin
          sum_stage3[i] <= 16'h0;
        end else if (valid_strobe) begin
          sum_stage3[i] <= sum_stage2[2*i] + sum_stage2[2*i+1];
        end
      end
    end
  endgenerate

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      sum_stage3[1] <= 16'h0;
    end else if (valid_strobe) begin
      sum_stage3[1] <= sum_stage2[2];
    end
  end

  // Final sum
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      fir_sum <= 16'h0;
      data_out <= 16'h0;
    end else if (valid_strobe) begin
      fir_sum <= sum_stage3[0] + sum_stage3[1];
      data_out <= fir_sum;
    end
  end

endmodule
