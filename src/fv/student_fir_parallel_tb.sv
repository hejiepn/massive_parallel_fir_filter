module student_fir_parallel_tb;

  localparam int unsigned ADDR_WIDTH = 2;
  localparam int unsigned DATA_SIZE = 16;
  localparam int unsigned DEBUGMODE = 1;
  localparam int unsigned DATA_SIZE_FIR_OUT = 32;
  localparam int unsigned NUM_FIR = 8;

  localparam int dpram_tlul_offset = 16;
  localparam int dpram_no_inside_fir = 2;
  localparam int dpram_samples_address = 0;
  localparam int dpram_coeff_address = 1;
  localparam int fir_reg_address = 2;

  localparam int sample_write_in_reg = 32'h00080000;
  localparam int sample_shift_out_reg = 32'h00080004;
  localparam int y_out_upper_reg = 32'h10080008;
  localparam int y_out_lower_reg = 32'h1008000C;

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

  logic [31:0] tlul_read_data;


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
/**
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
**/
    //Apply test stimulus
	$display("Apply test stimulus");
    for (int i = 1; i>=0; i--) begin
			sample_in = i;  // Incremental test pattern
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
    bus.wait_cycles(100);

	$display("apply test stimulus finished");

	$display("apply test tlul write and read");


		bus.put_word(sample_write_in_reg, {'0,8'hff});
		//read sample_shift_out_internal
		bus.get_word(sample_shift_out_reg, tlul_read_data);
		//read y out
		bus.get_word(y_out_upper_reg, tlul_read_data);
		bus.get_word(y_out_lower_reg, tlul_read_data);

	$display("apply test tlul write and read");
	

    $finish;  // End simulation
  end

  // Monitor to print values
  initial begin
    $monitor("Time: %0t | valid_strobe_in: %0b | sample_in: %0h | valid_strobe_out: %0b | y_out: %0h",
             $time, valid_strobe_in, sample_in, valid_strobe_out, y_out);
  end

endmodule
