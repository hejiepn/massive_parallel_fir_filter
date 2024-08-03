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
    input logic AC_ADC_SDATA,  // Codec ADC Serial Data

    // From FIR
	input logic signed [DATA_SIZE_FIR_OUT-1:0] Data_I_R, 	 //Data from HW to Codec (mono Channel)
	input logic signed [DATA_SIZE_FIR_OUT-1:0] Data_I_L, 	 //Data from HW to Codec (mono Channel)
  input logic valid_strobe_I,  // Valid strobe from HW

	// To FIR
	output logic [DATA_SIZE-1:0] Data_O_L, //Data from Codec to HW (mono Channel)
	output logic [DATA_SIZE-1:0] Data_O_R, //Data from Codec to HW (mono Channel)

	input  tlul_pkg::tl_h2d_t tl_i,
	output tlul_pkg::tl_d2h_t tl_o,  
	output logic valid_strobe   // Valid strobe to HW

);

import student_iis_handler_reg_pkg::*;
student_iis_handler_reg2hw_t reg2hw; // Write
student_iis_handler_hw2reg_t hw2reg; // Read

 student_iis_handler_reg_top student_iis_handler_reggen_module(
  .clk_i,
  .rst_ni,
  .tl_i,
  .tl_o,
  .reg2hw,
  .hw2reg,
  .devmode_i(1'b1)
  );

logic BCLK_Fall_int;
logic BCLK_Rise_int;
logic LRCLK_Fall_int;
logic LRCLK_Rise_int;

logic ADC_SDATA_int;

logic ADC_SDATA_tlul;
logic useTLUL;
logic [DATA_SIZE-1:0] serial_in_int;
logic [3:0] tlulCnt;
logic lastBitFlag;

always_ff @(posedge clk_i or negedge rst_ni) begin
	if (~rst_ni) begin
		useTLUL <= 1'b0;
		tlulCnt <= DATA_SIZE-1;
		serial_in_int <= '0;
		ADC_SDATA_tlul <= '0;
		lastBitFlag <= 1'b0;
	end else begin
		if(reg2hw.serial_in.qe) begin
			useTLUL <= 1'b1;
			serial_in_int <= reg2hw.serial_in.q;
		end
		if(useTLUL) begin
			if(BCLK_Fall_int == 1'b1 && LRCLK_Fall_int == 1'b0 && LRCLK_Rise_int == 1'b0 && ~lastBitFlag) begin
				ADC_SDATA_tlul <= serial_in_int[tlulCnt];
				if (tlulCnt == 0) begin
						lastBitFlag <= 1'b1;
				end else begin
					tlulCnt <= tlulCnt - 1;
				end
			end else if(BCLK_Fall_int == 1'b1 && LRCLK_Fall_int == 1'b0 && LRCLK_Rise_int == 1'b0 && lastBitFlag) begin 
				tlulCnt <= DATA_SIZE-1;
				useTLUL <= 1'b0;
				lastBitFlag <= 1'b0;
			end 
		end
	end 
end

assign ADC_SDATA_int = useTLUL? ADC_SDATA_tlul : AC_ADC_SDATA;

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
	.AC_ADC_SDATA(ADC_SDATA_int),
	.AC_LRCLK(AC_LRCLK),
	.LRCLK_Rise(LRCLK_Rise_int),
	.LRCLK_Fall(LRCLK_Fall_int),
	.BCLK_Rise(BCLK_Rise_int),
	.Data_O_R(Data_O_R),
	.Data_O_L(Data_O_L),
	.valid_strobe(valid_strobe)
  );

  always_ff @(posedge clk_i, negedge rst_ni) begin
	if (~rst_ni) begin
		hw2reg.pcm_out_left.de <= 1'b0;
		hw2reg.pcm_out_left.d <= '0;
	end else begin
		if(valid_strobe) begin
			hw2reg.pcm_out_left.d <= Data_O_L;
			hw2reg.pcm_out_left.de <= 1'b1;
		end else begin
			hw2reg.pcm_out_left.de <= 1'b0;
		end
	end
  end

   always_ff @(posedge clk_i, negedge rst_ni) begin
	if (~rst_ni) begin
		hw2reg.pcm_out_right.de <= 1'b0;
		hw2reg.pcm_out_right.d <= '0;
	end else begin
		if(valid_strobe) begin
			hw2reg.pcm_out_right.d <= Data_O_R;
			hw2reg.pcm_out_right.de <= 1'b1;
		end else begin
			hw2reg.pcm_out_right.de <= 1'b0;
		end
	end
  end

  logic use_tl_pcm_in_left;
  logic [DATA_SIZE_FIR_OUT-1:0] Data_I_L_int;
  logic [DATA_SIZE_FIR_OUT-1:0] Data_I_L_tlul;
  logic AC_DAC_SDATA_int;

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
	.AC_DAC_SDATA(AC_DAC_SDATA_int)
  );

  logic loobackEnable;

  always_ff @(posedge clk_i, negedge rst_ni) begin
	if(!rst_ni) begin
		loobackEnable <= 1'b0;
	end else begin
		if(reg2hw.loopback_enable.qe) begin
			loobackEnable <= reg2hw.loopback_enable.q;
		end
	end
  end

  assign AC_DAC_SDATA = loobackEnable? AC_ADC_SDATA : AC_DAC_SDATA_int;

//   always_ff @(posedge clk_i, negedge rst_ni) begin
// 	if (~rst_ni) begin
// 		use_tl_pcm_in_left <= 1'b0;
// 	end else begin
// 		if(reg2hw.pcm_in_left.qe) begin
// 			Data_I_L_tlul <= reg2hw.pcm_in_left.q[DATA_SIZE_FIR_OUT-1:0];
// 			use_tl_pcm_in_left <= 1'b1;
// 		end
// 		if (valid_strobe_I) begin
// 			if (use_tl_pcm_in_left) begin
// 				Data_I_L_int <= Data_I_L_tlul;
// 				use_tl_pcm_in_left <= 1'b0;
// 			end else begin
// 				Data_I_L_int <= Data_I_L;
// 			end 
// 		end
// 	end 
//   end 


//   logic [23:0] AC_DAC_SDATA_int;
//   logic [31:0] AC_DAC_SDATA_int_cnt;

//  always_ff @(posedge clk_i, negedge rst_ni) begin
// 	if (~rst_ni) begin
// 		hw2reg.serial_out.de <= 1'b0;
// 		hw2reg.serial_out.d <= '0;
// 		AC_DAC_SDATA_int_cnt <= 32'd23;
// 		AC_DAC_SDATA_int <= '0;
// 	end else begin
// 		if(BCLK_Fall_int == 1'b1 && LRCLK_Fall_int == 1'b0 && LRCLK_Rise_int == 1'b0) begin
// 			AC_DAC_SDATA_int <= {AC_DAC_SDATA_int[22:0], AC_DAC_SDATA};
// 			AC_DAC_SDATA_int_cnt <= AC_DAC_SDATA_int_cnt - 1;
// 			if(AC_DAC_SDATA_int_cnt == 0) begin
// 				hw2reg.serial_out.d <= AC_DAC_SDATA_int;
// 				hw2reg.serial_out.de <= 1'b1;
// 				AC_DAC_SDATA_int_cnt <= 32'd23;
// 			end else begin 
// 				hw2reg.serial_out.de <= 1'b0;
// 			end
// 		end
// 	end
//   end
  


endmodule
