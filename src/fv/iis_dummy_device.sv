// file: iis_dummy_device.sv
// Description: Dummy IIS device for testing the IIS handler. 
//              Gets Data from two inputs, sends it to the IIS Handler and shows all received data on the outputs.

module iis_dummy_device #(
  parameter int unsigned DATA_SIZE = 16,
  parameter int unsigned DATA_SIZE_FIR_OUT = 24
  )(
    input logic clk_i,
    input logic rst_ni,

    input  logic AC_MCLK,       // Codec Master Clock
    input  logic AC_BCLK,       // Codec Bit Clock
    input  logic AC_LRCLK,      // Codec Left/Right Clock
    output logic AC_ADC_SDATA,  // Codec ADC Serial Data
    input  logic AC_DAC_SDATA,  // Codec DAC Serial Data

    input logic [DATA_SIZE-1:0] TEST_DATA_IN_L,  // Test Data to send to the iis handler (left channel)
    input logic [DATA_SIZE-1:0] TEST_DATA_IN_R,  // Test Data to send to the iis handler (right channel)

    output logic [DATA_SIZE_FIR_OUT-1:0] TEST_DATA_OUT_L,  // Received data from the iis handler (left channel)
    output logic [DATA_SIZE_FIR_OUT-1:0] TEST_DATA_OUT_R   // Received data from the iis handler (right channel)

);

  // Detect rising edge of LRCLK
  logic LRCLK_Rise;
  logic LRCLK_last;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      LRCLK_Rise <= 1'b0;
      LRCLK_last <= 1'b0;
    end else begin
      LRCLK_Rise <= !LRCLK_last && AC_LRCLK;
      LRCLK_last <= AC_LRCLK;
    end
  end

  // Detect falling edge of LRCLK
  logic LRCLK_Fall;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      LRCLK_Fall <= 1'b0;
    end else begin
      LRCLK_Fall <= LRCLK_last && !AC_LRCLK;
    end
  end

  // Detect rising edge of BCLK
  logic BCLK_Rise;
  logic BCLK_last;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      BCLK_Rise <= 1'b0;
      BCLK_last <= 1'b0;
    end else begin
      BCLK_Rise <= !BCLK_last && AC_BCLK;
      BCLK_last <= AC_BCLK;
    end
  end

  // Detect falling edge of BCLK
  logic BCLK_Fall;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) BCLK_Fall <= 1'b0;
    else begin
      BCLK_Fall <= BCLK_last && !AC_BCLK;
    end
  end


  // Shift in 24 bits of data
  logic [DATA_SIZE_FIR_OUT-1:0] Data_In_int;
  logic [ 4:0] rising_edge_cnt;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      TEST_DATA_OUT_L <= '0;
      TEST_DATA_OUT_R <= '0;
      Data_In_int <= '0;
      rising_edge_cnt <= '0;
    end else begin
      if (LRCLK_Rise) begin
        Data_In_int <= '0;
        rising_edge_cnt <= '0;
      end else if (LRCLK_Fall) begin
        Data_In_int <= '0;
        rising_edge_cnt <= '0;
      end else if (BCLK_Rise) begin
        rising_edge_cnt <= rising_edge_cnt + 1'b1;
        if (rising_edge_cnt > 5'd0 && rising_edge_cnt <= DATA_SIZE_FIR_OUT) begin
          Data_In_int <= {Data_In_int[DATA_SIZE_FIR_OUT-1:0], AC_DAC_SDATA};
        end else if (rising_edge_cnt > DATA_SIZE_FIR_OUT && AC_LRCLK == 1'b0) TEST_DATA_OUT_L <= Data_In_int;
        else if (rising_edge_cnt > DATA_SIZE_FIR_OUT && AC_LRCLK == 1'b1) begin
          TEST_DATA_OUT_R <= Data_In_int;
        end
      end
    end
  end

  // Shift out 16 bits of data
  logic [DATA_SIZE:0] Data_Out_int = '0;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Data_Out_int[DATA_SIZE]   <= 1'b0;  // Append a 0 to the MSB bc. wait one bclk cycle
      Data_Out_int[DATA_SIZE-1:0] <= TEST_DATA_IN_L;
    end else begin
      Data_Out_int <= Data_Out_int;
      if (LRCLK_Rise) begin
        Data_Out_int[DATA_SIZE]   <= 1'b0;
        Data_Out_int[DATA_SIZE-1:0] <= TEST_DATA_IN_R;
      end else if (LRCLK_Fall) begin
        Data_Out_int[DATA_SIZE]   <= 1'b0;
        Data_Out_int[DATA_SIZE-1:0] <= TEST_DATA_IN_L;
      end else if (BCLK_Fall == 1'b1 && LRCLK_Fall == 1'b0 && LRCLK_Rise == 1'b0) begin
        Data_Out_int <= {Data_Out_int[DATA_SIZE-1:0], 1'b0};
      end
    end
  end
  assign AC_ADC_SDATA = Data_Out_int[DATA_SIZE];

endmodule
