module student_fir_parallel_i2s_clk_tb;

  localparam int AddrWidth = 10; // Address width
  localparam int MaxAddr = 2**AddrWidth; // Maximum address
  localparam int DATA_SIZE = 16; // Data size
  localparam int DEBUGMODE = 0; // activate debugMode when AddrWidth != 10 
  localparam int DATA_SIZE_FIR_OUT = 24; // activate debugMode when AddrWidth != 10
  localparam int dpram_no_inside_fir = 2;
  localparam int dpram_samples_address = 0;
  localparam int dpram_coeff_address = 1;
  localparam int fir_reg_address = 2;
  localparam int SramAw = 12;
  localparam int NUM_FIR = 8;
  localparam int firtlulOffset = 16;
  localparam int dpram_tlul_offset = 12;
  localparam int dpram_address_offset_max = 11;
  localparam int dpram_address_offset_min = 2; 

  
  // the 19-16 bits are depended from NUM_FIR
  localparam int sample_write_in_reg = 32'h10080000;
  localparam int sample_shift_out_reg = 32'h10080004;
  localparam int y_out_upper_reg = 32'h10080008;
  localparam int y_out_lower_reg = 32'h1008000C;
  localparam int STUDENT_FIR_PARALLEL_SINE_ENABLE = 32'h10080010;

  // Clock and reset signals
  logic clk_i;
  logic rst_ni;

  // Input signals
  logic valid_strobe_in;
  logic [DATA_SIZE-1:0] sample_in;

  // Output signals
//   logic compute_finished_out;
  logic [DATA_SIZE-1:0] sample_shift_out;
  logic valid_strobe_out;
  logic signed [DATA_SIZE_FIR_OUT-1:0] y_out;

  // Memory to store the input samples from sin.mem
  logic [7:0] sin_mem [0:1023]; // Adjust the size based on your file
  //integer i; // Loop variable
  logic [31:0] address_sram;
  logic [31:0] tlul_write_data;
  logic [31:0] tlul_read_data;

  tlul_pkg::tl_h2d_t tl_h2d;
  tlul_pkg::tl_d2h_t tl_d2h;

  logic error_flag = 0;

  logic AC_LRCLK;
  logic LRCLK_Fall;
  logic LRCLK_Rise;
  logic AC_MCLK;
  logic AC_BCLK;
  logic BCLK_Fall;
  logic BCLK_Rise;
  logic round_begin;

  logic [31:0] address_fir_single;


  // Instantiate the DUT (Device Under Test)
  student_fir_parallel #(
	.ADDR_WIDTH(AddrWidth),
	.DATA_SIZE(DATA_SIZE),
	.DEBUGMODE(DEBUGMODE),
	.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT),
	.NUM_FIR(NUM_FIR)
  ) dut_fir_parallel (
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

  student_iis_clock_gen #(
	.DATA_SIZE(DATA_SIZE)
  ) i2s_clock_gen (
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.AC_MCLK(AC_MCLK),
	.AC_BCLK(AC_BCLK),
	.BCLK_Fall(BCLK_Fall),
	.BCLK_Rise(BCLK_Rise),
	.AC_LRCLK(AC_LRCLK),
	.LRCLK_Fall(LRCLK_Fall),
	.LRCLK_Rise(LRCLK_Rise)
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
    round_begin =0;

    // Load the sin.mem file
	if (DEBUGMODE == 1) begin
		$readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie_copy_2/risc-v-lab-group-01/src/rtl/student/data/sin_low_debug.mem", sin_mem);
	end else begin
		$readmemh("/home/rvlab/groups/rvlab01/Desktop/data/sin_low.mem", sin_mem);
	end

	bus.reset();
    // Wait for reset to propagate
    #40;
	bus.wait_cycles(20);

	$display("Testbench started");

	// Apply test stimulus
	$display("Apply test stimulus:");
	
//for(int j = 0; j < 6; j = j+1) begin
	for (int i = 0; i < MaxAddr; i = i + 1) begin
		sample_in = {'0, sin_mem[i]}; // Zero-pad the 8-bit value to 16 bits
		@(posedge LRCLK_Rise);
		valid_strobe_in <= 1;
		counting = 1;
		@(posedge LRCLK_Fall);
		valid_strobe_in <= 0;
		wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high
		counting = 0;
		$display("Number of clock cycles from valid_strobe_in to valid_strobe_out: %0d", clk_count);
		clk_count = 0; // Reset counter for next iteration
		bus.get_word(sample_shift_out_reg, tlul_read_data);
		bus.get_word(y_out_upper_reg, tlul_read_data);
		bus.get_word(y_out_lower_reg, tlul_read_data);
		@(posedge clk_i);
	end
//end
	/*

	// Apply test stimulus with tlul sample in
	$display("Apply test stimulus with tlul sample in");
	for (int i = 0; i < MaxAddr; i = i + 1) begin
		 bus.put_word(sample_write_in_reg, 16'hFFaa);
		@(posedge LRCLK_Rise);
		valid_strobe_in <= 1;
		counting = 1;
		@(posedge LRCLK_Fall);
		valid_strobe_in <= 0;
		wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high
		counting = 0;
		$display("Number of clock cycles from valid_strobe_in to valid_strobe_out: %0d", clk_count);
		clk_count = 0; // Reset counter for next iteration
		//read sample_shift_out_internal
		bus.get_word(sample_shift_out_reg, tlul_read_data);
		//read y out
		bus.get_word(y_out_upper_reg, tlul_read_data);
		bus.get_word(y_out_lower_reg, tlul_read_data);
		@(posedge clk_i);
  	end
  


	$display("use sine wave signal");
		bus.put_word(STUDENT_FIR_PARALLEL_SINE_ENABLE, 32'd1);
    #200000;
    	bus.put_word(STUDENT_FIR_PARALLEL_SINE_ENABLE, 32'd0);
    	$display("use sine wave signal end");


// Apply test stimulus with tlul sample in
	$display("Apply test stimulus with tlul sample in");
	for (int i = 0; i < MaxAddr; i = i + 1) begin
		
		//write into single fir register
		
		for(int j = 0; j < NUM_FIR; j = j + 1) begin
			address_fir_single[31:firtlulOffset+4] = 12'h100;
			address_fir_single[firtlulOffset+3:firtlulOffset] = j;
			address_fir_single[firtlulOffset-1:dpram_tlul_offset] = 2;
			address_fir_single[dpram_tlul_offset-1:0] = '0;
			bus.put_word(address_fir_single, 16'hF0F0);
		end
		
		//write into single fir dpram sample
		for(int j = 0; j < NUM_FIR; j = j + 1) begin
			address_fir_single[31:firtlulOffset+4] = 12'h100;
			address_fir_single[firtlulOffset+3:firtlulOffset] = j;
			address_fir_single[firtlulOffset-1:dpram_tlul_offset] = 0;
			address_fir_single[dpram_address_offset_max:dpram_address_offset_min] = i;
			address_fir_single[dpram_address_offset_min-1:0] = '0;
			bus.put_word(address_fir_single, 16'hcaca);
		end
		//write into single fir dpram coeff
		for(int j = 0; j < NUM_FIR; j = j + 1) begin
			address_fir_single[31:firtlulOffset+4] = 12'h100;
			address_fir_single[firtlulOffset+3:firtlulOffset] = j;
			address_fir_single[firtlulOffset-1:dpram_tlul_offset] = 1;
			address_fir_single[dpram_address_offset_max:dpram_address_offset_min] = i;
			address_fir_single[dpram_address_offset_min-1:0] = '0;
			bus.put_word(address_fir_single, 16'hdbdb);
		end

		bus.put_word(sample_write_in_reg, 16'hFFaa);
		@(posedge LRCLK_Rise);
		valid_strobe_in <= 1;
		counting = 1;
		@(posedge LRCLK_Fall);
		valid_strobe_in <= 0;
		wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high
		counting = 0;
		$display("Number of clock cycles from valid_strobe_in to valid_strobe_out: %0d", clk_count);
		clk_count = 0; // Reset counter for next iteration
		//read sample_shift_out_internal
		bus.get_word(sample_shift_out_reg, tlul_read_data);
		//read y out
		bus.get_word(y_out_upper_reg, tlul_read_data);
		bus.get_word(y_out_lower_reg, tlul_read_data);
		@(posedge clk_i);
  
  end
    // Finish simulation





	// Testresultat
	if (error_flag) begin
		$display("Test fehlgeschlagen.");
	end else begin
		$display("Test erfolgreich.");
	end
	@(posedge clk_i);
*/
    $stop;
  end

  // Clock cycle counter
  always @(posedge clk_i) begin
    if (counting) begin
      clk_count <= clk_count + 1;
    end
  end

  // Monitor to print values
//   initial begin
//     $monitor("Time: %0t | valid_strobe_in: %0b | sample_in: %0h | compute_finished_out: %0b | sample_shift_out: %0h | valid_strobe_out: %0b | y_out: %0h",
//              $time, valid_strobe_in, sample_in, compute_finished_out, sample_shift_out, valid_strobe_out, y_out);
//   end
  initial begin
    $monitor("Time: %0t | valid_strobe_in: %0b | sample_in: %0h | sample_shift_out: %0h | valid_strobe_out: %0b | y_out: %0h",
             $time, valid_strobe_in, sample_in, sample_shift_out, valid_strobe_out, y_out);
  end

endmodule
