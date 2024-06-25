`timescale 1ns / 1ps

module tb_fir_filter;

  // Parameters
  localparam ADDR_WIDTH = 16;
  localparam DATA_WIDTH = 16;
  localparam MAX_ADDR = 1024;

  // Signals
  logic clk_i;
  logic rst_ni;
  logic valid_strobe;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;

  // DUT instantiation
  fir_filter uut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .valid_strobe(valid_strobe),
    .data_in(data_in),
    .data_out(data_out)
  );

  // Clock generation
  always #5 clk_i = ~clk_i;  // 100MHz clock

  // MEM file data
  logic [DATA_WIDTH-1:0] sin_wave [0:MAX_ADDR-1];
  logic [DATA_WIDTH-1:0] sin_high [0:MAX_ADDR-1];
  logic [DATA_WIDTH-1:0] sin_low [0:MAX_ADDR-1];
  logic [DATA_WIDTH-1:0] sin_comb [0:MAX_ADDR-1];

  initial begin
    // Initialize signals
    clk_i = 0;
    rst_ni = 0;
    valid_strobe = 0;
    data_in = 0;

    // Reset
    #20;
    rst_ni = 1;

    // Load sin wave from MEM files
    $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_siyu/risc-v-lab-group-01/build_fir_test/fir_test/fir_test.sim/sin.mem", sin_wave);
    $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_siyu/risc-v-lab-group-01/build_fir_test/fir_test/fir_test.sim/sin_low.mem", sin_low);
    $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_siyu/risc-v-lab-group-01/build_fir_test/fir_test/fir_test.sim/sin_high.mem", sin_high);
    $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_siyu/risc-v-lab-group-01/build_fir_test/fir_test/fir_test.sim/sin_combined.mem", sin_comb);

    // Apply sin wave data
    for (int i = 0; i < MAX_ADDR; i++) begin
      #10;
      valid_strobe = 1;
      data_in = sin_wave[i];
      #10;
      valid_strobe = 0;
    end

    // Wait for output processing to complete
    #2000;

    // Apply sin_low wave data
    for (int i = 0; i < MAX_ADDR; i++) begin
      #10;
      valid_strobe = 1;
      data_in = sin_low[i];
      #10;
      valid_strobe = 0;
    end

    // Wait for output processing to complete
    #2000;

    // Apply sin_high wave data
    for (int i = 0; i < MAX_ADDR; i++) begin
      #10;
      valid_strobe = 1;
      data_in = sin_high[i];
      #10;
      valid_strobe = 0;
    end

    // Wait for output processing to complete
    #2000;

    // Apply sin_comb wave data
    for (int i = 0; i < MAX_ADDR; i++) begin
      #10;
      valid_strobe = 1;
      data_in = sin_comb[i];
      #10;
      valid_strobe = 0;
    end

    // Wait for output processing to complete
    #2000;

    // End simulation
    $stop;
  end

endmodule

