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
    output logic [DATA_SIZE-1:0] Data_O_R,    // Data from Codec to HW (mono Channel)
    output logic [DATA_SIZE-1:0] Data_O_L,    // Data from Codec to HW (mono Channel)
    output logic valid_strobe // Valid strobe to HW
);


// Shift in data from the codec
  logic [DATA_SIZE-1:0] Data_O_L_int;
  logic [DATA_SIZE-1:0] Data_O_R_int;
  logic [DATA_SIZE-1:0] Data_In_int;
  logic [4:0] rising_edge_cnt;    // Count the number of rising edges (we need to ignore the first one and write to the output directly after the LSB is shifted in)
  logic valid_strobe_int;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Data_O_L_int <= 16'b0;
      Data_O_R_int <= 16'b0;
      Data_In_int <= 16'b0;
      rising_edge_cnt <= 5'b0;
      valid_strobe_int <= 1'b0;
    end else begin
      if (LRCLK_Rise) begin
        Data_In_int <= '0;
        rising_edge_cnt <= 5'b0;
      end else if (LRCLK_Fall) begin
        Data_In_int <= '0;
        rising_edge_cnt <= 5'b0;
        valid_strobe_int <= 1'b0;
      end else if (BCLK_Rise) begin
        rising_edge_cnt <= rising_edge_cnt + 1'b1;
        //$display("rising_edge_cnt %d \n", rising_edge_cnt);
        if (rising_edge_cnt > 5'd0 && rising_edge_cnt <= 16) begin
          Data_In_int <= {Data_In_int[15:0], AC_ADC_SDATA};
          //$display("AC_ADC_SDATA: %b \n",AC_ADC_SDATA);
          //$display("Data_In_int shift: %h \n",Data_In_int);
        end else if (rising_edge_cnt > 5'd16 && AC_LRCLK == 1'b0) begin
            Data_O_L_int <= Data_In_int;
            //$display("Data_In_int LEFT: %h \n",Data_In_int);
        end else if (rising_edge_cnt > 5'd16 && AC_LRCLK == 1'b1) begin
          Data_O_R_int <= Data_In_int;
          //$display("Data_In_int RIGHT: %h \n",Data_In_int);
          valid_strobe_int <= 1'b1;
        end
      end
    end
  end

  assign Data_O_L = Data_O_L_int;
  assign Data_O_R = Data_O_R_int;
  assign valid_strobe = valid_strobe_int;


endmodule
