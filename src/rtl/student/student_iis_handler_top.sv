module student_iis_handler_top #(
	parameter int unsigned DATA_SIZE = 16,
	parameter int unsigned DATA_SIZE_FIR_OUT = 16
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
	input logic [DATA_SIZE_FIR_OUT-1:0] Data_I_R, 	 //Data from HW to Codec (mono Channel)
	input logic [DATA_SIZE_FIR_OUT-1:0] Data_I_L, 	 //Data from HW to Codec (mono Channel)
  input logic valid_strobe_I,  // Valid strobe from HW

	// To FIR
	output logic [DATA_SIZE-1:0] Data_O_L, //Data from Codec to HW (mono Channel)
	output logic [DATA_SIZE-1:0] Data_O_R, //Data from Codec to HW (mono Channel)

	output logic valid_strobe   // Valid strobe to HW

);

// 	input  tlul_pkg::tl_h2d_t tl_i,
  //output tlul_pkg::tl_d2h_t tl_o  

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

logic BCLK_Fall_int;
logic BCLK_Rise_int;
logic LRCLK_Fall_int;
logic LRCLK_Rise_int;

  student_iis_clock_gen #(
	.DATA_SIZE(DATA_SIZE)
  ) student_iis_clock_gen_inst (
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.AC_MCLK(AC_MCLK),
	.AC_BCLK(AC_BCLK),
	.BCLK_Fall(BCLK_Fall_int),
	.BCLK_Rise(BCLK_Rise_int),
	.AC_LRCLK(AC_LRCLK),
	.LRCLK_Fall(LRCLK_Fall_int),
	.LRCLK_Rise(LRCLK_Rise_int)
  );

  student_iis_receiver #(
	.DATA_SIZE(DATA_SIZE)
  ) student_iis_receiver_inst (
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.AC_ADC_SDATA(AC_ADC_SDATA),
	.AC_LRCLK(AC_LRCLK),
	.LRCLK_Rise(LRCLK_Rise_int),
	.LRCLK_Fall(LRCLK_Fall_int),
	.BCLK_Rise(BCLK_Rise_int),
	.Data_O_R(Data_O_R),
	.Data_O_L(Data_O_L),
	.valid_strobe(valid_strobe)
  );

  student_iis_transmitter #(
	.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT)
	  ) student_iis_transmitter_inst (
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.Data_I_L(Data_I_L),
	.Data_I_R(Data_I_R),
	.valid_strobe_I(valid_strobe_I),
	.LRCLK_Rise(LRCLK_Rise_int),
	.LRCLK_Fall(LRCLK_Fall_int),
	.BCLK_Fall(BCLK_Fall_int),
	.AC_DAC_SDATA(AC_DAC_SDATA)
  );

endmodule
