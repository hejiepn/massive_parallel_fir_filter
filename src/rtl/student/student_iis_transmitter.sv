module student_iis_transmitter #(
  parameter int unsigned DATA_SIZE_FIR_OUT = 32
)(
	input logic clk_i,
	input logic rst_ni,
	input logic [DATA_SIZE_FIR_OUT-1:0] Data_I,
	input logic valid_strobe_I,
	input logic LRCLK_Rise,
	input logic LRCLK_Fall,
	input logic BCLK_Fall,
	output logic AC_DAC_SDATA
);

logic valid_strobe_I_int;

  // Shift out data to send to the codec
  logic [DATA_SIZE_FIR_OUT:0] Data_Out_int;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Data_Out_int[DATA_SIZE_FIR_OUT]   <= 1'b0;  // Append a 0 to the MSB bc. wait one bclk cycle
      Data_Out_int[DATA_SIZE_FIR_OUT-1:0] <= '0;
    end else begin
      //Data_Out_int <= Data_Out_int;
	  if(valid_strobe_I) begin
		valid_strobe_I_int <= 1'b1;
	  end
      if (LRCLK_Fall && valid_strobe_I_int)  begin
        Data_Out_int[DATA_SIZE_FIR_OUT]   <= 1'b0;
        Data_Out_int[DATA_SIZE_FIR_OUT-1:0] <= Data_I;
		valid_strobe_I_int <= 1'b0;
	  end else if (LRCLK_Rise && valid_strobe_I_int) begin
		Data_Out_int[DATA_SIZE_FIR_OUT]   <= 1'b0;
        Data_Out_int[DATA_SIZE_FIR_OUT-1:0] <= Data_I;
		valid_strobe_I_int <= 1'b0;
	  end else if (BCLK_Fall == 1'b1 && LRCLK_Fall == 1'b0 && LRCLK_Rise == 1'b0) begin
        Data_Out_int <= {Data_Out_int[DATA_SIZE_FIR_OUT-1:0], 1'b0};
      end
    end
  end

  assign AC_DAC_SDATA = Data_Out_int[DATA_SIZE_FIR_OUT];

endmodule