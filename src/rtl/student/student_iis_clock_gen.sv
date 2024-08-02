module student_iis_clock_gen #(
	parameter int unsigned DATA_SIZE = 16
)(
	input logic clk_i,
	input logic rst_ni,
	output logic AC_MCLK,
	output logic AC_BCLK,
	output logic BCLK_Fall,
	output logic BCLK_Rise,
	output logic AC_LRCLK,
	output logic LRCLK_Fall,
	output logic LRCLK_Rise
);

logic AC_MCLK_int;

 // Generation of AC_MCLK (half of the system clock) -> 25 MHz for CODEC, which supports until 27 MHz
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) AC_MCLK_int <= 1'b0;
    else AC_MCLK_int <= ~AC_MCLK_int;
  end

  assign AC_MCLK = AC_MCLK_int;

  // Generation of AC_BCLK (1/16 of the system clock) -> 3,125 MHz >= f_s * word_width(16) *2(bc. of stereo) == 1,4112 MHz (minimum required frequency)
  // Also Generate Falling and Rising Edge Strobes
  //logic [2:0] Cnt_BCLK;
  logic [3:0] Cnt_BCLK;
  logic AC_BCLK_int;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
  //    Cnt_BCLK <= '1;
      Cnt_BCLK <= 4'd8;
      AC_BCLK_int <= 1'b0;
    end else begin
      if (Cnt_BCLK == '0) begin
        //  Cnt_BCLK <= '1;
         Cnt_BCLK <= 4'd8;
        AC_BCLK_int <= ~AC_BCLK_int;
      end else Cnt_BCLK <= Cnt_BCLK - 1;
    end
  end

  assign AC_BCLK = AC_BCLK_int;

  //logic BCLK_Fall, BCLK_Rise;
  assign BCLK_Rise = ((Cnt_BCLK == '0) && (AC_BCLK_int == 1'b0)) ? 1'b1 : 1'b0;
  assign BCLK_Fall = ((Cnt_BCLK == '0) && (AC_BCLK_int == 1'b1)) ? 1'b1 : 1'b0;

  // Generation of AC_LRCLK (1/1024 of the system clock) -> 48.828 kHz == sample frequency f_s
  // Also Generate Falling and Rising Edge Strobes
  logic [9:0] Cnt_LRCLK;
  //logic [8:0] Cnt_LRCLK;
  logic AC_LRCLK_int;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Cnt_LRCLK <= 10'd566;
      //Cnt_LRCLK <= '1;
      AC_LRCLK_int <= 1'b0;
    end else begin
      if (Cnt_LRCLK == 0) begin
	  	 Cnt_LRCLK <= 10'd566;
      //Cnt_LRCLK <= '1;
        AC_LRCLK_int <= ~AC_LRCLK_int;
      end else Cnt_LRCLK <= Cnt_LRCLK - 1;
    end
  end

  assign AC_LRCLK = AC_LRCLK_int;

  //logic LRCLK_Fall, LRCLK_Rise;
  assign LRCLK_Rise = ((Cnt_LRCLK == 0) && (AC_LRCLK_int == 1'b0)) ? 1'b1 : 1'b0;
  assign LRCLK_Fall = ((Cnt_LRCLK == 0) && (AC_LRCLK_int == 1'b1)) ? 1'b1 : 1'b0;

endmodule