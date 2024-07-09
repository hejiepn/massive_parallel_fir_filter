`timescale 1ns/1ps

module fir_filter_tb;

  // Parameters
  localparam CLK_PERIOD = 20; // Clock period in nanoseconds (50 MHz)

  // Testbench signals
  logic clk_i;
  logic rst_ni;
  logic [9:0] coef_len;
  logic [15:0] coef_data;
  logic [15:0] audio_data;
  logic coef_wr;
  logic audio_wr;
  logic [31:0] audio_out;  // Adjusted width to match DUT
  logic valid_out;

  // Instantiate the DUT (Device Under Test)
  fir_filter dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .coef_len(coef_len),
    .coef_data(coef_data),
    .audio_data(audio_data),
    .coef_wr(coef_wr),
    .audio_wr(audio_wr),
    .audio_out(audio_out),
    .valid_out(valid_out)
  );

  // Clock generation
  initial begin
    clk_i = 0;
    forever #(CLK_PERIOD / 2) clk_i = ~clk_i;
  end

  // Testbench process
  initial begin
    // Initialize signals
    rst_ni = 0;
    coef_len = 10; // Example coefficient length
    coef_data = 0;
    audio_data = 0;
    coef_wr = 0;
    audio_wr = 0;

    // Apply reset
    #(CLK_PERIOD * 5);
    rst_ni = 1;

    // Load coefficient data from file
    $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_siyu/risc-v-lab-group-01/build_fir_0630/src/coe_lp.mem", coef_mem);

    // Load audio data from file
    $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_siyu/risc-v-lab-group-01/build_fir_0630/src/sin_low.mem", audio_mem);

    // Write coefficient data to DUT
    for (int i = 0; i < coef_len; i++) begin
      coef_data = coef_mem[i];
      coef_wr = 1;
      #(CLK_PERIOD);
      coef_wr = 0;
    end

    // Simulate continuous audio data input
    for (int i = 0; i < 1024; i++) begin
      audio_data = audio_mem[i];
      audio_wr = 1;
      #(CLK_PERIOD);
      audio_wr = 0;
    end

    // Wait for FIR computation to complete
    #(CLK_PERIOD * 100);

    // Finish simulation
    $stop;
  end

  // Memory arrays for test data
  reg [15:0] coef_mem [0:1023]; // Coefficient memory (adjust size as needed)
  reg [15:0] audio_mem [0:1023]; // Audio memory (adjust size as needed)

endmodule
