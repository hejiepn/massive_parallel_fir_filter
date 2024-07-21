module student_fir_parallel_tb;

  localparam int unsigned ADDR_WIDTH = 2;
  localparam int unsigned DATA_SIZE = 16;
  localparam int unsigned DEBUGMODE = 1;
  localparam int unsigned DATA_SIZE_FIR_OUT = 32;
  localparam int unsigned NUM_FIR = 4;

  // Clock and reset signals
  logic clk_i;
  logic rst_ni;

  // Input signals
  logic valid_strobe_in;
  logic [DATA_SIZE-1:0] sample_in;

  // Output signals
  logic valid_strobe_out;
  logic [DATA_SIZE_FIR_OUT+NUM_FIR-1:0] y_out;

  // TileLink interface
  tlul_pkg::tl_h2d_t tl_h2d;
  tlul_pkg::tl_d2h_t tl_d2h;

  // Instantiate the Device Under Test (DUT)
  student_fir_parallel #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_SIZE(DATA_SIZE),
    .DEBUGMODE(DEBUGMODE),
    .DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT),
    .NUM_FIR(NUM_FIR)
  ) dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .valid_strobe_in(valid_strobe_in),
    .sample_in(sample_in),
    .valid_strobe_out(valid_strobe_out),
    .y_out(y_out),
    .tl_i(tl_h2d),
    .tl_o(tl_d2h)
  );

  // Clock generation: 50 MHz clock -> period = 20ns
  always begin
    clk_i = 1'b1;
    #10;  // High for 10ns
    clk_i = 1'b0;
    #10;  // Low for 10ns
  end

  // Initial block to apply stimulus
  initial begin
    // Initialize signals
    rst_ni = 1;
    valid_strobe_in = 0;
    sample_in = 0;
    #100;  // Wait for 100ns
    rst_ni = 0;  // Release reset
    #100;
    rst_ni = 1;
    #100;

    // Apply test stimulus
    // for (int i = 0; i < 256; i++) begin
      sample_in = 1;  // Incremental test pattern
      valid_strobe_in = 1;
      @(posedge clk_i);  // Wait for a clock edge
      valid_strobe_in = 0;
      @(posedge valid_strobe_out);  // Wait for output validation
      $display("Output y_out at time %0t: %h", $time, y_out);
      @(posedge clk_i);
    // end

    $finish;  // End simulation
  end

  // Monitor to print values
  initial begin
    $monitor("Time: %0t | valid_strobe_in: %0b | sample_in: %0h | valid_strobe_out: %0b | y_out: %0h",
             $time, valid_strobe_in, sample_in, valid_strobe_out, y_out);
  end

endmodule
