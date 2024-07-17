module student_iis_handler #(
	parameter int unsigned DATA_SIZE = 16,
	parameter int unsigned DATA_SIZE_FIR_OUT = 32
)(
    input logic clk_i,
    input logic rst_ni,

    // To/From Audio Codec
    output logic AC_MCLK,       // Codec Master Clock
    output logic AC_BCLK,       // Codec Bit Clock
    output logic AC_LRCLK,      // Codec Left/Right Clock
    input  logic AC_ADC_SDATA,  // Codec ADC Serial Data
    output logic AC_DAC_SDATA,  // Codec DAC Serial Data

    // To/From HW
  	input logic [DATA_SIZE_FIR_OUT-1:0] Data_I, 	 //Data from HW to Codec (mono Channel)
  	output logic [DATA_SIZE-1:0] Data_O,	 //Data from Codec to HW (mono Channel)
    input logic valid_strobe_I,  // Valid strobe from HW
  	output logic valid_strobe,    // Valid strobe to HW

    input  tlul_pkg::tl_h2d_t tl_i,
    output tlul_pkg::tl_d2h_t tl_o  //slave output (this module's response)
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

 logic serial_in;
 logic serial_in_prev;
 logic serial_out;
 logic [DATA_SIZE-1:0] pcm_out;
 logic [DATA_SIZE_FIR_OUT-1:0] pcm_in;
 logic [DATA_SIZE_FIR_OUT-1:0] pcm_in_prev;
 logic AC_DAC_SDATA_prev;
 logic [DATA_SIZE-1:0] Data_O_prev;

 always_ff @(posedge clk_i or negedge rst_ni) begin : proc_
     if(~rst_ni) begin
        serial_in <= '0;
        serial_in_prev <= '0:
        pcm_in <= '0;
        pcm_in_prev <= '0;
   end else begin
      if(reg2hw.serial_in.qe) begin
        serial_in <= reg2hw.serial_in.q;
        serial_in_prev <= serial_in;
      end
      if(reg2hw.pcm_in.qe) begin
        pcm_in <= {'0,reg2hw.pcm_in.q};
        pcm_in_prev <= pcm_in;
      end
   end
 end


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
  logic [DATA_SIZE_FIR_OUT:0] Data_Out_int;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Data_Out_int[DATA_SIZE_FIR_OUT]   <= 1'b0;  // Append a 0 to the MSB bc. wait one bclk cycle
      Data_Out_int[DATA_SIZE_FIR_OUT-1:0] <= '0;
    end else begin
        Data_Out_int <= Data_Out_int;
  	   if(valid_strobe_I) begin
  		    valid_strobe_I_int <= 1'b1;
  	   end
       if (LRCLK_Fall && valid_strobe_I_int)  begin
          Data_Out_int[DATA_SIZE_FIR_OUT]   <= 1'b0;
            if(pcm_in != pcm_in_prev) begin
              Data_Out_int[DATA_SIZE_FIR_OUT-1:0] <= pcm_in; //tlul write instead of data coming from fir
            end else begin
              Data_Out_int[DATA_SIZE_FIR_OUT-1:0] <= Data_I;
            end
  		    valid_strobe_I_int <= 1'b0;
  	  end else if (LRCLK_Rise && valid_strobe_I_int) begin
  		    Data_Out_int[DATA_SIZE_FIR_OUT]   <= 1'b0;
          if(pcm_in != pcm_in_prev) begin
            Data_Out_int[DATA_SIZE_FIR_OUT-1:0] <= pcm_in; //tlul write instead of data coming from fir
          end else begin
            Data_Out_int[DATA_SIZE_FIR_OUT-1:0] <= Data_I;
          end
  		    valid_strobe_I_int <= 1'b0;
  	  end else if (BCLK_Fall == 1'b1 && LRCLK_Fall == 1'b0 && LRCLK_Rise == 1'b0) begin
          Data_Out_int <= {Data_Out_int[DATA_SIZE_FIR_OUT-1:0], 1'b0};
      end
    end
  end

  assign AC_DAC_SDATA = Data_Out_int[DATA_SIZE_FIR_OUT];

  always_ff @(posedge clk_i, negedge rst_ni) begin : tlul_serial_out
     if (!rst_ni) begin
        hw2reg.serial_out.de <= '0;
        hw2reg.serial_out.d <= '0;
        AC_DAC_SDATA_prev <= '0;
    end else begin
      AC_DAC_SDATA_prev <= AC_DAC_SDATA;
      if(AC_DAC_SDATA_prev != AC_DAC_SDATA) begin
          hw2reg.serial_out.d <= Data_Out_int[DATA_SIZE_FIR_OUT];
          hw2reg.serial_out.de <= '1;
      end else begin
          hw2reg.serial_out.de <= '0;
      end
    end
  end

  // Shift in data from the codec
  logic [DATA_SIZE-1:0] Data_O_int;
  logic [DATA_SIZE-1:0] Data_In_int;
  logic [4:0] rising_edge_cnt;    // Count the number of rising edges (we need to ignore the first one and write to the output directly after the LSB is shifted in)
  logic valid_strobe_int_O;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        Data_O_int <= DATA_SIZE-1'b0;
        Data_In_int <= DATA_SIZE-1'b0;
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
            if(serial_in != serial_in_prev) begin 
              Data_In_int <= {Data_In_int[15:0], serial_in};
            end else begin
              Data_In_int <= {Data_In_int[15:0], AC_ADC_SDATA};
            end
          end else if (rising_edge_cnt > 5'd16 && AC_LRCLK_int == 1'b0) begin
      			Data_O_int <= Data_In_int;
      			valid_strobe_int_O <= 1'b1;
      		end else if (rising_edge_cnt > 5'd16 && AC_LRCLK_int == 1'b1) begin
            Data_O_int <= Data_In_int;
            valid_strobe_int_O <= 1'b1;
          end
        end
    end
  end

  assign Data_O = Data_O_int;
  assign valid_strobe = valid_strobe_int_O;

    always_ff @(posedge clk_i, negedge rst_ni) begin : tlul_serial_out
     if (!rst_ni) begin
        hw2reg.pcm_out.de <= '0;
        hw2reg.pcm_out.d <= '0;
        Data_O_prev <= '0;
    end else begin
      Data_O_prev <= Data_O;
      if(Data_O != Data_O_prev) begin
          hw2reg.pcm_out.d <= Data_O_int;
          hw2reg.pcm_out.de <= '1;      
      end else begin
          hw2reg.pcm_out.de <= '0;
      end
    end
  end

endmodule