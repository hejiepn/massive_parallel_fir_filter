module student_iis_handler #(
	parameter int unsigned DATA_SIZE = 16,
	parameter int unsigned DATA_SIZE_FIR_OUT = 32
)(
    input logic clk_i,
    input logic rst_ni,

    // To Audio Codec
    output logic AC_MCLK,       // Codec Master Clock
    output logic AC_BCLK,       // Codec Bit Clock
    output logic AC_LRCLK,      // Codec Left/Right Clock
    output logic AC_DAC_SDATA,  // Codec DAC Serial Data

	// From Audio Codec
    input  logic AC_ADC_SDATA,  // Codec ADC Serial Data

    // From FIR
	input logic [DATA_SIZE_FIR_OUT-1:0] Data_I, 	 //Data from HW to Codec (mono Channel)
    input logic valid_strobe_I,  // Valid strobe from HW

	// To FIR
	output logic [DATA_SIZE-1:0] Data_O, //Data from Codec to HW (mono Channel)
	output logic valid_strobe,   // Valid strobe to HW

 	input  tlul_pkg::tl_h2d_t tl_i,
    output tlul_pkg::tl_d2h_t tl_o  //slave output (this module's response)
);

// import student_iis_handler_reg_pkg::*;
// student_iis_handler_reg2hw_t reg2hw; // Write
// student_iis_handler_hw2reg_t hw2reg; // Read

//  student_iis_handler_reg_top student_iis_handler_reggen_module(
//   .clk_i,
//   .rst_ni,
//   .tl_i,
//   .tl_o,
//   .reg2hw,
//   .hw2reg,
//   .devmode_i(1'b1)
//   );

//********************************************************************************************//
/**
* Clock Generation
**/

  // Generation of AC_MCLK (half of the system clock) -> 25 MHz == f_s*512
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) AC_MCLK <= 1'b0;
    else AC_MCLK <= ~AC_MCLK;
  end

  // Generation of AC_BCLK (1/32 of the system clock) -> 1,5625 MHz >= f_s * word_width(16) *2(bc. of stereo) == 1,4112 MHz (minimum required frequency)
  // Also Generate Falling and Rising Edge Strobes
  logic [3:0] Cnt_BCLK;
  logic AC_BCLK_int;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Cnt_BCLK <= '1;
      AC_BCLK_int <= 1'b0;
    end else begin
      if (Cnt_BCLK == '0) begin
        Cnt_BCLK <= '1;
        AC_BCLK_int <= ~AC_BCLK_int;
      end else Cnt_BCLK <= Cnt_BCLK - 1;
    end
  end
  assign AC_BCLK = AC_BCLK_int;

  logic BCLK_Fall, BCLK_Rise;
  assign BCLK_Rise = ((Cnt_BCLK == '0) && (AC_BCLK_int == 1'b0)) ? 1'b1 : 1'b0;
  assign BCLK_Fall = ((Cnt_BCLK == '0) && (AC_BCLK_int == 1'b1)) ? 1'b1 : 1'b0;

  // Generation of AC_LRCLK (1/1024 of the system clock) -> 48.828 kHz == sample frequency f_s
  // Also Generate Falling and Rising Edge Strobes
  logic [9:0] Cnt_LRCLK;
  logic AC_LRCLK_int;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Cnt_LRCLK <= '1;
      AC_LRCLK_int <= 1'b0;
    end else begin
      if (Cnt_LRCLK == 0) begin
        Cnt_LRCLK <= '1;
        AC_LRCLK_int <= ~AC_LRCLK_int;
      end else Cnt_LRCLK <= Cnt_LRCLK - 1;
    end
  end

  assign AC_LRCLK = AC_LRCLK_int;

  logic LRCLK_Fall, LRCLK_Rise;
  assign LRCLK_Rise = ((Cnt_LRCLK == 0) && (AC_LRCLK_int == 1'b0)) ? 1'b1 : 1'b0;
  assign LRCLK_Fall = ((Cnt_LRCLK == 0) && (AC_LRCLK_int == 1'b1)) ? 1'b1 : 1'b0;

  //********************************************************************************************//

  student_iis_receiver #(
	.DATA_SIZE(DATA_SIZE)
  ) student_iis_receiver_inst (
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.AC_ADC_SDATA(AC_ADC_SDATA),
	.AC_LRCLK(AC_LRCLK),
	.LRCLK_Rise(LRCLK_Rise),
	.LRCLK_Fall(LRCLK_Fall),
	.BCLK_Rise(BCLK_Rise),
	.Data_O(Data_O),
	.valid_strobe(valid_strobe)
  );

  student_iis_transmitter #(
	.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT)
	  ) student_iis_transmitter_inst (
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.Data_I(Data_I),
	.valid_strobe_I(valid_strobe_I),
	.LRCLK_Rise(LRCLK_Rise),
	.LRCLK_Fall(LRCLK_Fall),
	.BCLK_Fall(BCLK_Fall),
	.AC_DAC_SDATA(AC_DAC_SDATA)
  );

endmodule
