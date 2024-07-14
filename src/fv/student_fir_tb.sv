module student_fir_tb;

  localparam int AddrWidth = 10; // Address width
  localparam int MaxAddr = 2**AddrWidth; // Maximum address
  localparam int DATA_SIZE = 16; // Data size
  localparam int DEBUGMODE = 0; // activate debugMode when AddrWidth != 10 

  // Clock and reset signals
  logic clk_i;
  logic rst_ni;

  // Input signals
  logic valid_strobe_in;
  logic [DATA_SIZE-1:0] sample_in;

  // Output signals
  logic compute_finished_out;
  logic [DATA_SIZE-1:0] sample_shift_out;
  logic valid_strobe_out;
  logic [DATA_SIZE*2-1:0] y_out;

  // Memory to store the input samples from sin.mem
  logic [7:0] sin_mem [0:1023]; // Adjust the size based on your file
  integer i; // Loop variable
  
  tlul_pkg::tl_h2d_t tl_h2d;
  tlul_pkg::tl_d2h_t tl_d2h;


  // Instantiate the DUT (Device Under Test)
  student_fir #(
	.ADDR_WIDTH(AddrWidth),
	.DATA_SIZE(DATA_SIZE),
	.DEBUGMODE(DEBUGMODE)
  ) dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .valid_strobe_in(valid_strobe_in),
    .sample_in(sample_in),
    .compute_finished_out(compute_finished_out),
    .sample_shift_out(sample_shift_out),
    .valid_strobe_out(valid_strobe_out),
    .y_out(y_out),
	.tl_i(tl_h2d),
	.tl_o(tl_d2h)
  );

    tlul_test_host bus(
    .clk_i(clk_i),
    .rst_no(rst_ni),
    .tl_i(tl_d2h),
    .tl_o(tl_h2d)
  );

  logic [31:0] clk_count;
  logic counting;

  // Clock generation: 50 MHz clock -> period = 20ns
   always begin
    clk_i = '1;
    #10000;
    clk_i = '0;
    #10000;
  end

  // Initial block to apply stimulus
  initial begin
    // Initialize signals
    clk_i = 0;
    valid_strobe_in = 0;
    sample_in = 0;

    // Load the sin.mem file
	if (DEBUGMODE == 1) begin
		$readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/rtl/student/data/sin_low_debug.mem", sin_mem);
	end else begin
		$readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/fv/data/sin_high.mem", sin_mem);
	end

	bus.reset();
    // Wait for reset to propagate
    #40;
	bus.wait_cycles(20);

	// Apply test stimulus
	for (i = 0; i < MaxAddr; i = i + 1) begin
		sample_in = {8'b0, sin_mem[i]}; // Zero-pad the 8-bit value to 16 bits
		valid_strobe_in <= 1;
		counting = 1;
		@(posedge clk_i);
		valid_strobe_in <= 0;
		wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high
		counting = 0;
		$display("Number of clock cycles from valid_strobe_in to valid_strobe_out: %0d", clk_count);
        clk_count = 0; // Reset counter for next iteration
		@(posedge clk_i);
	end

    // Finish simulation
    #200;
    $stop;
  end

  // Clock cycle counter
  always @(posedge clk_i) begin
    if (counting) begin
      clk_count <= clk_count + 1;
    end
  end

  // Monitor to print values
  initial begin
    $monitor("Time: %0t | valid_strobe_in: %0b | sample_in: %0h | compute_finished_out: %0b | sample_shift_out: %0h | valid_strobe_out: %0b | y_out: %0h",
             $time, valid_strobe_in, sample_in, compute_finished_out, sample_shift_out, valid_strobe_out, y_out);
  end

endmodule
