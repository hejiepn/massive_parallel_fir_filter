module student_fir_tb;

  localparam int AddrWidth = 2; // Address width
  localparam int MaxAddr = 2**AddrWidth; // Maximum address
  localparam int DATA_SIZE = 16; // Data size
  localparam int DEBUGMODE = 1; // activate debugMode when AddrWidth != 10 
  localparam int DATA_SIZE_FIR_OUT = 32; // activate debugMode when AddrWidth != 10
  localparam int dpram_tlul_offset = 12;
  localparam int dpram_no_inside_fir = 2;
  localparam int dpram_samples_address = 0;
  localparam int dpram_coeff_address = 1;
  localparam int fir_reg_address = 2;

  
  localparam int sample_write_in_reg = 32'h10002000;
  localparam int sample_shift_out_reg = 32'h10002004;
  localparam int y_out_upper_reg = 32'h10002008;
  localparam int y_out_lower_reg = 32'h1000200C;

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
  logic [DATA_SIZE*2-1:0] y_out;

  // Memory to store the input samples from sin.mem
  logic [7:0] sin_mem [0:1023]; // Adjust the size based on your file
  //integer i; // Loop variable
  logic [31:0] address_sram;
  logic [31:0] tlul_write_data;
  logic [31:0] tlul_read_data;

  tlul_pkg::tl_h2d_t tl_h2d;
  tlul_pkg::tl_d2h_t tl_d2h;

  logic error_flag = 0;


  // Instantiate the DUT (Device Under Test)
  student_fir #(
	.ADDR_WIDTH(AddrWidth),
	.DATA_SIZE(DATA_SIZE),
	.DEBUGMODE(DEBUGMODE),
	.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT)
  ) dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .valid_strobe_in(valid_strobe_in),
    .sample_in(sample_in),
    // .compute_finished_out(compute_finished_out),
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
		$readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/fv/data/sin_comb.mem", sin_mem);
	end

	bus.reset();
    // Wait for reset to propagate
    #40;
	bus.wait_cycles(20);

	// Apply test stimulus
	$display("Apply test stimulus:");
	for (int i = 0; i < MaxAddr; i = i + 1) begin
		sample_in = {8'b0, sin_mem[i]}; // Zero-pad the 8-bit value to 16 bits
		valid_strobe_in <= 1;
		counting = 1;
		@(posedge clk_i);
		valid_strobe_in <= 0;
		wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high
		//read sample_shift_out_internal
		bus.get_word(sample_shift_out_reg, tlul_read_data);
		//read y out
		bus.get_word(y_out_upper_reg, tlul_read_data);
		bus.get_word(y_out_lower_reg, tlul_read_data);
		counting = 0;
		$display("Number of clock cycles from valid_strobe_in to valid_strobe_out: %0d", clk_count);
        clk_count = 0; // Reset counter for next iteration
		@(posedge clk_i);
	end

	//apply tlul write on coeff dpram:
	$display("Apply tlul write on coeff dpram:");
	for (int i = 0; i < MaxAddr; i++) begin
		address_sram = 32'h00000000; // Basisadresse setzen
		address_sram[31:24] = 8'h10; // Aktuelle Geräteadresse setzen
		address_sram[23:dpram_tlul_offset+4] = '0; // Bereich auf Null setzen
		address_sram[dpram_tlul_offset+4-1:dpram_tlul_offset] = dpram_coeff_address; // tlul_dpram_device auswählen
		address_sram[dpram_tlul_offset-1:AddrWidth+2] = '0; // Bereich auf Null setzen
		address_sram[AddrWidth+1:2] = i; // Adresse innerhalb des dpram setzen
		address_sram[1:0] = '0; // Niedrigste zwei Bits auf Null setzen		
		tlul_write_data = {'0,8'h02};
		bus.put_word(address_sram, tlul_write_data);
		bus.get_word(address_sram, tlul_read_data);
		$display("tlul_read_data: %4x and expected_data: %4x",tlul_read_data, tlul_write_data);
		if (tlul_read_data !== tlul_write_data) begin
			$display("Fehler: Erwartet %0d, aber tlul_read_data ist %h", tlul_write_data, tlul_read_data);
			error_flag = 1;
		end
	end

	//apply tlul write on samples dpram:
	$display("Apply tlul write on samples dpram:");
	for (int i = 0; i < MaxAddr; i++) begin
		address_sram = 32'h00000000; // Basisadresse setzen
		address_sram[31:24] = 8'h10; // Aktuelle Geräteadresse setzen
		address_sram[23:dpram_tlul_offset+4] = '0; // Bereich auf Null setzen
		address_sram[dpram_tlul_offset+4-1:dpram_tlul_offset] = dpram_samples_address; // tlul_dpram_device auswählen
		address_sram[dpram_tlul_offset-1:AddrWidth+2] = '0; // Bereich auf Null setzen
		address_sram[AddrWidth+1:2] = i; // Adresse innerhalb des dpram setzen
		address_sram[1:0] = '0; // Niedrigste zwei Bits auf Null setzen		
		tlul_write_data = {'0,8'h00};
		bus.put_word(address_sram, tlul_write_data);
		bus.get_word(address_sram, tlul_read_data);
		$display("tlul_read_data: %4x and expected_data: %4x",tlul_read_data, tlul_write_data);
		if (tlul_read_data !== tlul_write_data) begin
			$display("Fehler: Erwartet %0d, aber tlul_read_data ist %h", tlul_write_data, tlul_read_data);
			error_flag = 1;
		end
	end

	// Apply test stimulus with tlul sample in
	$display("Apply test stimulus with tlul sample in");
	//for (int i = 0; i < MaxAddr; i = i + 1) begin
		//sample_in = {8'b0, sin_mem[i]}; // Zero-pad the 8-bit value to 16 bits
		//valid_strobe_in <= 1;
		bus.put_word(sample_write_in_reg, {'0,8'h01});
		counting = 1;
		@(posedge clk_i);
		//valid_strobe_in <= 0;
		wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high
		//read sample_shift_out_internal
		bus.get_word(sample_shift_out_reg, tlul_read_data);
		//read y out
		bus.get_word(y_out_upper_reg, tlul_read_data);
		bus.get_word(y_out_lower_reg, tlul_read_data);
		counting = 0;
		$display("Number of clock cycles from valid_strobe_in to valid_strobe_out: %0d", clk_count);
        clk_count = 0; // Reset counter for next iteration
	//end



    // Finish simulation
    #200;

	// Testresultat
	if (error_flag) begin
		$display("Test fehlgeschlagen.");
	end else begin
		$display("Test erfolgreich.");
	end
	@(posedge clk_i);

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
