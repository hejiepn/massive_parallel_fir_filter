module student_iis_handler (
    input logic clk_i,
    input logic rst_ni,

    // To/From Audio Codec
    output logic AC_MCLK,       // Codec Master Clock
    output logic AC_BCLK,       // Codec Bit Clock
    output logic AC_LRCLK,      // Codec Left/Right Clock
    input  logic AC_ADC_SDATA,  // Codec ADC Serial Data
    output logic AC_DAC_SDATA,  // Codec DAC Serial Data

    // To/From HW
	input logic [15:0] Data_I, 	 //Data from HW to Codec (mono Channel)
	output logic [15:0] Data_O,	 //Data from Codec to HW (mono Channel)
    input logic valid_strobe_I,  // Valid strobe from HW
	output logic valid_strobe    // Valid strobe to HW

);

localparam integer data_width_I = 16;

  // Generation of AC_MCLK (half of the system clock) -> 25 MHz == f_s*512
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) AC_MCLK <= 1'b0;
    else AC_MCLK <= ~AC_MCLK;
  end

  // Generation of AC_BCLK (1/16 of the system clock) -> 3.125 MHz >= f_s * word_width(16) *2(bc. of stereo) == 1.536 MHz (minimum required frequency)
  // Also Generate Falling and Rising Edge Strobes
  logic [2:0] Cnt_BCLK;
  logic AC_BCLK_int;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Cnt_BCLK <= 3'b111;
      AC_BCLK_int <= 1'b0;
    end else begin
      if (Cnt_BCLK == 3'b000) begin
        Cnt_BCLK <= 3'b111;
        AC_BCLK_int <= ~AC_BCLK_int;
      end else Cnt_BCLK <= Cnt_BCLK - 1'b1;
    end
  end
  assign AC_BCLK = AC_BCLK_int;

  logic BCLK_Fall, BCLK_Rise;
  assign BCLK_Rise = ((Cnt_BCLK == 3'b000) && (AC_BCLK_int == 1'b0)) ? 1'b1 : 1'b0;
  assign BCLK_Fall = ((Cnt_BCLK == 3'b000) && (AC_BCLK_int == 1'b1)) ? 1'b1 : 1'b0;

  // Generation of AC_LRCLK (1/1024 of the system clock) -> 48.828 kHz == sample frequency f_s
  // Also Generate Falling and Rising Edge Strobes
  logic [8:0] Cnt_LRCLK;
  logic AC_LRCLK_int;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Cnt_LRCLK <= 9'b111111111;
      AC_LRCLK_int <= 1'b0;
    end else begin
      if (Cnt_LRCLK == 0) begin
        Cnt_LRCLK <= 9'b111111111;
        AC_LRCLK_int <= ~AC_LRCLK_int;
      end else Cnt_LRCLK <= Cnt_LRCLK - 1;
    end
  end

  assign AC_LRCLK = AC_LRCLK_int;

  logic LRCLK_Fall, LRCLK_Rise;
  assign LRCLK_Rise = ((Cnt_LRCLK == 0) && (AC_LRCLK_int == 1'b0)) ? 1'b1 : 1'b0;
  assign LRCLK_Fall = ((Cnt_LRCLK == 0) && (AC_LRCLK_int == 1'b1)) ? 1'b1 : 1'b0;

  logic valid_strobe_I_int;

  // Shift out data to send to the codec
  logic [data_width_I:0] Data_Out_int;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Data_Out_int[data_width_I]   <= 1'b0;  // Append a 0 to the MSB bc. wait one bclk cycle
      Data_Out_int[data_width_I-1:0] <= '0;
    end else begin
      Data_Out_int <= Data_Out_int;
	  if(valid_strobe_I) begin
		valid_strobe_I_int <= 1'b1;
	  end
      if (LRCLK_Fall && valid_strobe_I_int)  begin
        Data_Out_int[data_width_I]   <= 1'b0;
        Data_Out_int[data_width_I-1:0] <= Data_I;
		valid_strobe_I_int <= 1'b0;
	  end else if (LRCLK_Rise && valid_strobe_I_int) begin
		 Data_Out_int[data_width_I]   <= 1'b0;
        Data_Out_int[data_width_I-1:0] <= Data_I;
		valid_strobe_I_int <= 1'b0;
	  end else if (BCLK_Fall == 1'b1 && LRCLK_Fall == 1'b0 && LRCLK_Rise == 1'b0) begin
        Data_Out_int <= {Data_Out_int[data_width_I-1:0], 1'b0};
      end
    end
  end

  assign AC_DAC_SDATA = Data_Out_int[data_width_I];

  // Shift in data from the codec
  logic [15:0] Data_O_int;
  logic [15:0] Data_In_int;
  logic [4:0] rising_edge_cnt;    // Count the number of rising edges (we need to ignore the first one and write to the output directly after the LSB is shifted in)
  logic valid_strobe_int_O;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
	Data_O_int <= 16'b0;
      Data_In_int <= 16'b0;
      rising_edge_cnt <= 5'b0;
      valid_strobe_int_O <= 1'b0;
    end else begin
      if (LRCLK_Rise) begin
        Data_In_int <= '0;
        rising_edge_cnt <= 5'b0;
		valid_strobe_int_O <= 1'b0;
      end else if (LRCLK_Fall) begin
        Data_In_int <= '0;
        rising_edge_cnt <= 5'b0;
        valid_strobe_int_O <= 1'b0;
      end else if (BCLK_Rise) begin
        rising_edge_cnt <= rising_edge_cnt + 1'b1;
        if (rising_edge_cnt > 5'd0 && rising_edge_cnt <= 16) begin
          Data_In_int <= {Data_In_int[15:0], AC_ADC_SDATA};
        end
		else if (rising_edge_cnt > 5'd16 && AC_LRCLK_int == 1'b0) begin
			Data_O_int <= Data_In_int;
			valid_strobe_int_O <= 1'b1;
		end
        else if (rising_edge_cnt > 5'd16 && AC_LRCLK_int == 1'b1) begin
          Data_O_int <= Data_In_int;
          valid_strobe_int_O <= 1'b1;
        end
      end
    end
  end

  assign Data_O = Data_O_int;
  assign valid_strobe = valid_strobe_int_O;

endmodule