module dummy_effect (
    input logic clk_i,
    input logic rst_ni,

    input  logic        valid_strobe,  // 
    input  logic [15:0] Data_I_L,      // Data from IIS handler (Left Channel)
    input  logic [15:0] Data_I_R,      // Data from IIS handler (Right Channel)
    output logic [15:0] Data_O_L,      // Data to IIS handler (Left Channel)
    output logic [15:0] Data_O_R       // Data to IIS handler (Right Channel)

);

  // Detect rising edge of valid_strobe
  logic valid_strobe_Rise;
  logic valid_strobe_last;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      valid_strobe_Rise <= 1'b0;
      valid_strobe_last <= 1'b0;
    end else begin
      valid_strobe_Rise <= !valid_strobe_last && valid_strobe;
      valid_strobe_last <= valid_strobe;
    end
  end

  // Detect falling edge of valid_strobe
  logic valid_strobe_Fall;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      valid_strobe_Fall <= 1'b0;
    end else begin
      valid_strobe_Fall <= valid_strobe_last && !valid_strobe;
    end
  end

  // Set Data_O_L and Data_O_R to Data_I_L and Data_I_R when valid_strobe rises
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Data_O_L <= 16'd0;
      Data_O_R <= 16'd0;
    end else begin
      if (valid_strobe_Rise) begin
        Data_O_L <= Data_I_L;
        Data_O_R <= Data_I_R;
      end
    end
  end

endmodule