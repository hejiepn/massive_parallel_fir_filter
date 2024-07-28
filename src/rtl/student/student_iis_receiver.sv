module student_iis_receiver #(
	parameter int unsigned DATA_SIZE = 16
)(
    input logic clk_i,
    input logic rst_ni,

    //From Audio Codec
    input  logic AC_ADC_SDATA,  // Codec ADC Serial Data
	input logic AC_LRCLK,
	input LRCLK_Rise,
	input LRCLK_Fall,
	input BCLK_Rise,

    // To HW
	output logic [DATA_SIZE-1:0] Data_O,	 //Data from Codec to HW (mono Channel)
	output logic valid_strobe // Valid strobe to HW
);

  // Shift in data from the codec
  logic [DATA_SIZE-1:0] Data_O_int;
  logic [DATA_SIZE-1:0] Data_In_int;
  logic [$clog2(DATA_SIZE):0] rising_edge_cnt;    // Count the number of rising edges (we need to ignore the first one and write to the output directly after the LSB is shifted in)
  logic valid_strobe_int_O;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
		Data_O_int <= DATA_SIZE-1'b0;
      	Data_In_int <= DATA_SIZE-1'b0;
      	rising_edge_cnt <= '0;
      	valid_strobe_int_O <= 1'b0;
    end else begin
      if (LRCLK_Rise) begin
        Data_In_int <= '0;
        rising_edge_cnt <= '0;
		valid_strobe_int_O <= 1'b0;
      end else if (LRCLK_Fall) begin
        Data_In_int <= '0;
        rising_edge_cnt <= '0;
        valid_strobe_int_O <= 1'b0;
      end else if (BCLK_Rise) begin
        rising_edge_cnt <= rising_edge_cnt + 1'b1;
        if (rising_edge_cnt > '0 && rising_edge_cnt <= DATA_SIZE) begin
          Data_In_int <= {Data_In_int[DATA_SIZE-1:0], AC_ADC_SDATA};
        end
		else if (rising_edge_cnt > DATA_SIZE && AC_LRCLK == '0) begin
			Data_O_int <= Data_In_int;
			valid_strobe_int_O <= 1'b1;
		end
        else if (rising_edge_cnt > DATA_SIZE && AC_LRCLK == '1) begin
          Data_O_int <= Data_In_int;
          valid_strobe_int_O <= 1'b1;
        end
      end
    end
  end

  assign Data_O = Data_O_int;
  assign valid_strobe = valid_strobe_int_O;

endmodule
