module student_fir_parallel_tb;

  localparam int unsigned ADDR_WIDTH = 2;
  localparam int unsigned DATA_SIZE = 16;
  localparam int unsigned DEBUGMODE = 1;
  localparam int unsigned DATA_SIZE_FIR_OUT = 32;
  localparam int unsigned NUM_FIR = 8;

  // Clock and reset signals
  logic clk_i;
  logic rst_ni;

  // Input signals
  logic valid_strobe_in;
  logic [DATA_SIZE-1:0] sample_in;

  // Output signals
  logic valid_strobe_out;
  logic [DATA_SIZE_FIR_OUT+$clog2(NUM_FIR)-1:0] y_out;

  // TileLink interface
  tlul_pkg::tl_h2d_t tl_h2d;
  tlul_pkg::tl_d2h_t tl_d2h;
  
  logic [7:0] sin_mem [0:1023]; // Adjust the size based on your file


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

     tlul_test_host bus(
    .clk_i(clk_i),
    .rst_no(rst_ni),
    .tl_i(tl_d2h),
    .tl_o(tl_h2d)
  );


  // Clock generation: 50 MHz clock -> period = 20ns
   always begin
    clk_i = '1;
    #10000;
    clk_i = '0;
    #10000;
  end

  // Initial block to apply stimulus
  initial begin

	clk_i = 0;
    valid_strobe_in = 0;
    sample_in = 0;

    // Load the sin.mem file
	if (DEBUGMODE == 1) begin
		$readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/rtl/student/data/sin_low_debug.mem", sin_mem);
	end else begin
		$readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/fv/data/sin_comb.mem", sin_mem);
	end

	bus.reset();
    // Wait for reset to propagate
    #40;
	bus.wait_cycles(20);

	$display("Testbench started");
    // Initialize signals

	sample_in = 1;  // Incremental test pattern
	valid_strobe_in = 1;
	@(posedge clk_i);  // Wait for a clock edge
	valid_strobe_in = 0;
	wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high	$display("Output y_out at time %0t: %h", $time, y_out);

	$display("Output y_out at time %0t: %h", $time, y_out);
	@(posedge clk_i);

	sample_in = 2;  // Incremental test pattern
	valid_strobe_in = 1;
	@(posedge clk_i);  // Wait for a clock edge
	valid_strobe_in = 0;
	wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high	$display("Output y_out at time %0t: %h", $time, y_out);

	$display("Output y_out at time %0t: %h", $time, y_out);
	@(posedge clk_i);

	sample_in = 3;  // Incremental test pattern
	valid_strobe_in = 1;
	@(posedge clk_i);  // Wait for a clock edge
	valid_strobe_in = 0;
	wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high	$display("Output y_out at time %0t: %h", $time, y_out);
		$display("Output y_out at time %0t: %h", $time, y_out);
	@(posedge clk_i);

	sample_in = 4;  // Incremental test pattern
	valid_strobe_in = 1;
	@(posedge clk_i);  // Wait for a clock edge
	valid_strobe_in = 0;
	wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high	$display("Output y_out at time %0t: %h", $time, y_out);
		$display("Output y_out at time %0t: %h", $time, y_out);

	@(posedge clk_i);

	sample_in = 5;  // Incremental test pattern
	valid_strobe_in = 1;
	@(posedge clk_i);  // Wait for a clock edge
	valid_strobe_in = 0;
	wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go highn
	$display("Output y_out at time %0t: %h", $time, y_out);
	@(posedge clk_i);

    //Apply test stimulus
	$display("Apply test stimulus");
    for (int i = 0; i < 5; i++) begin
		sample_in = 0;  // Incremental test pattern
		$display("new sample");
		valid_strobe_in <= 1;
		$display("new valid strobe in");
		@(posedge clk_i);  // Wait for a clock edge
		valid_strobe_in <= 0;
		$display("valid strobe in 0");
		wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go highn
		$display("after wait for valid strobe out");
		$display("Output y_out at time %0t: %h", $time, y_out);
		@(posedge clk_i);
		$display("samples number: %d",i);

    end

	$display("Testbench finished");

    $finish;  // End simulation
  end

  // Monitor to print values
  initial begin
    $monitor("Time: %0t | valid_strobe_in: %0b | sample_in: %0h | valid_strobe_out: %0b | y_out: %0h",
             $time, valid_strobe_in, sample_in, valid_strobe_out, y_out);
  end

endmodule
