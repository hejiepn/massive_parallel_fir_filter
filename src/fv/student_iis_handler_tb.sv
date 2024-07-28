//file: student_iis_handler_tb.sv
//Block diagram of the testbench:
/*
                    ┌──────────────────────┐                ┌──────────────────────┐             ┌─────────────────────┐
                    │                      ◄──────MCLK──────┤                      │             │                     │
   TEST_DATA_IN─────►                      │                │                      │             │                     │
                    │                      │                │                      ├─DATA_O--────►                     │
                    │                      ◄──────BCLK──────┤                      │             │                     │
                    │                      │                │                      │             │                     │
                    │                      │                │                      │             │                     │
                    │    IIS_Dummy_Device  ◄──────LRCLK─────┤     IIS_Handler      │             │     Effect_Dummy    │
                    │                      │                │                      │             │                     │
                    │                      │                │                      │             │                     │
                    │                      │                │                      │             │                     │
◄───TEST_DATA_OUT───┤                      │                │                      ◄──Data_I───--┤                     │
                    │                      ├────ADC_SDATA───►                      │             │                     │
                    │                      │                │                      │             │                     │
                    │                      ◄────DAC_SDATA───┤                      │             │                     │
                    └──────────────────────┘                └──────────────────────┘             └─────────────────────┘
*/

localparam int DATA_SIZE = 16;
localparam int DATA_SIZE_FIR_OUT = 16;
localparam int test_tlul = 0;
localparam int tlul_serial_in = 32'h00000000;
localparam int tlul_serial_out = 32'h00000004;
localparam int tlul_pcm_out = 32'h00000008;
localparam int tlul_pcm_in = 32'h0000000C;

module dummy_effect_device (
    input logic clk_i,
    input logic rst_ni,

    input  logic valid_strobe,  // 
    input  logic [DATA_SIZE_FIR_OUT-1:0] Data_I,      // Data from effect dummy
	output logic valid_strobe_O,
    output logic [DATA_SIZE-1:0] Data_O      // Data to effect dummy
);

  // Detect rising edge of valid_strobe
  logic valid_strobe_Rise;
  logic valid_strobe_last;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      valid_strobe_Rise <= 1'b0;
      valid_strobe_last <= 1'b0;
    end else begin
      valid_strobe_Rise <= !valid_strobe_last && valid_strobe;
      valid_strobe_last <= valid_strobe;
    end
  end

  // Detect falling edge of valid_strobe
  logic valid_strobe_Fall;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      valid_strobe_Fall <= 1'b0;
    end else begin
      valid_strobe_Fall <= valid_strobe_last && !valid_strobe;
    end
  end

  // Set Data_O and Data_I when valid_strobe rises
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Data_O <= 16'd0;
	  valid_strobe_O <= 1'b0;
    end else begin
      if (valid_strobe_Rise) begin
        Data_O <= Data_I;
		valid_strobe_O <= 1'b1;
	  end else begin
		valid_strobe_O <= 1'b0;
	  end
    end
  end

endmodule


module student_iis_handler_tb;

  tlul_pkg::tl_d2h_t tl_d2h;
  tlul_pkg::tl_h2d_t tl_h2d;

  logic clk;
  logic rst_n;

  // 50 MHz Clock Generation
  always begin
    clk = '1;
    #10000;
    clk = '0;
    #10000;
  end


  // Student IIS Handler Instanciation
  logic AC_MCLK;
  logic AC_BCLK;
  logic AC_LRCLK;
  logic AC_ADC_SDATA;
  logic AC_DAC_SDATA;

  logic [DATA_SIZE_FIR_OUT-1:0] Data_I;
  logic [DATA_SIZE-1:0] Data_O;

  logic valid_strobe;
  logic valid_strobe_O;

//    tlul_test_host bus(
//     .clk_i(clk),
//     .rst_no(rst_n),
//     .tl_i(tl_d2h),
//     .tl_o(tl_h2d)
//   );


  student_iis_handler #(
	.DATA_SIZE(DATA_SIZE),
	.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT)
  ) DUT (
	.clk_i (clk),
	.rst_ni(rst_n),

	// To Audio Codec
	.AC_MCLK (AC_MCLK),  // Codec Master Clock
	.AC_BCLK (AC_BCLK),  // Codec Bit Clock
	.AC_LRCLK(AC_LRCLK),  // Codec Left/Right Clock
	.AC_ADC_SDATA(AC_ADC_SDATA), // Codec ADC Serial Data
	.AC_DAC_SDATA(AC_DAC_SDATA), // Codec DAC Serial Data

	// // To/From HW
	.Data_I(Data_I),         // Data from Effect Module to be sent to Codec 
	.Data_O(Data_O),         // Data from the Codec to be sent to Effect Module
	.valid_strobe_I(valid_strobe_O),
	.valid_strobe(valid_strobe),  // Valid strobe to Effect Module
	.tl_i(tl_h2d),
	.tl_o(tl_d2h)
  );


  // IIS Dummy Device Instanciation
  logic [DATA_SIZE-1:0] TEST_Data_I;
  logic [DATA_SIZE_FIR_OUT-1:0] TEST_Data_O;

    iis_dummy_device #(
	.DATA_SIZE(DATA_SIZE),
	.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT)
	)iis_dummy(
      .clk_i (clk),
      .rst_ni(rst_n),

      .AC_MCLK (AC_MCLK),  // Codec Master Clock
      .AC_BCLK (AC_BCLK),  // Codec Bit Clock
      .AC_LRCLK(AC_LRCLK),  // Codec Left/Right Clock
      .AC_ADC_SDATA(AC_ADC_SDATA), // Codec ADC Serial Data
      .AC_DAC_SDATA(AC_DAC_SDATA), // Codec DAC Serial Data

      .TEST_DATA_IN(TEST_Data_I),  // Data that is sent to the IIS_Handler (Left Channel)

      .TEST_DATA_OUT(TEST_Data_O) // Data that came from the IIS_Handler (Left Channel)
  );


  // Effect Dummy Device Instanciation
  dummy_effect_device effect_dummy(
      .clk_i (clk),
      .rst_ni(rst_n),

      .valid_strobe(valid_strobe),         // Codec valid_strobe
	  .valid_strobe_O(valid_strobe_O),

      .Data_I(Data_O),         // Data IIS Handler (Left Channel)
      .Data_O(Data_I)         // Data to IIS Handler (Left Channel)
  );


  // Testbench specific signals
  logic [DATA_SIZE-1:0] temp_l;

  int fd_r;
  int fd_w;

  int num_cycles = 10;
  int succeeded = 0;
  int failed = 0;
  int failed_cycle [];
  int index_failed_cycle = 0;

  int f_err = 0;

  initial begin

  	// if(!test_tlul) begin
	 	//bus.reset();

  		$display("Start testbench...\n");

  		// open file with input Test Data
  		fd_r = $fopen("../../../src/fv/data/test.hex", "r");
  		if (fd_r) $display("File opened successfully: %0d", fd_r);
  		else $display("File could not be opened");

  		// open file with output Test Data
  		fd_w = $fopen("./test_out.hex", "w");
  		if (fd_w) $display("File opened successfully: %0d", fd_w);
  		else $display("File could not be opened");

  		// load first data
  		f_err = $fscanf(fd_r, "%h", TEST_Data_I);

  		// initialize temp variables
  		temp_l = 0;

      
  		//Create NegEdge for reset


  		rst_n = '1;
  		#10000;
  		rst_n = '0;
  		#10000;
  		rst_n = '1;
      
  		// Loop through the dummy data and compare output of the handler with the previous input
  		for (int i = 0; i < num_cycles; i++) begin

  		$display("______________Cycle %0d of %0d_____________", i, num_cycles);

  		// wait until valid_strobe is high
  		@(posedge clk);
  		while (valid_strobe == 1'b0) begin
  			@(posedge clk);
  		end

  		// wait until valid_strobe is low 
  		@(posedge clk);
  		while (valid_strobe == 1'b1) begin
  			@(posedge clk);
  		end

  		// Display Current In and Out Data
  		$display("TEST_Data_I = %h \t", TEST_Data_I);
  		$display("TEST_Data_O = %h \t", TEST_Data_O);

  		// Check if Data matches with previous data
  		if (TEST_Data_O == temp_l) begin
  			$display("Success!");
  			succeeded++;
  		end else begin
  			$display("Data_O is incorrect");
  			failed++;
  			failed_cycle[index_failed_cycle] = num_cycles;
  			index_failed_cycle++;
  		end

  		// Write Data to file again
  			$fdisplay(fd_w, "%h", TEST_Data_O);

  		temp_l = TEST_Data_I;

  		//get new data from file
  		f_err = $fscanf(fd_r, "%h", TEST_Data_I);
  		end

  		// Close files
  		$fclose(fd_r);
  		$fclose(fd_w);


  		// Display Summary
  		$display("________________Summary__________________________");
  		$display("Total: %0d   Succeeded: %0d   Failed: %0d", num_cycles, succeeded, failed);
  		for(int j = 0; j < index_failed_cycle; j++) begin
  			$display("Failed Cycle in %0d", failed_cycle[j]);
  		end
  		$display("Completed testbench.\n");

  	//end
	//else begin
  	// 	logic [31:0] rdata;

    //   bus.reset();

    //   $display("write word over tlul to serial in",);
    //   bus.put_word(tlul_serial_in, 32'h00001010);
    //   // wait until valid_strobe is high
    //   @(posedge clk);
    //   while (valid_strobe == 1'b0) begin
    //     @(posedge clk);
    //   end

    //   // wait until valid_strobe is low 
    //   @(posedge clk);
    //   while (valid_strobe == 1'b1) begin
    //     @(posedge clk);
    //   end
    //   bus.get_word(tlul_pcm_out, rdata);
    //   $display("read pcm_out: 0x%08x", rdata);
    //   bus.wait_cycles(10);

    //   $display("write word over tlul to pcm in",);
    //   bus.put_word(tlul_pcm_in, 32'hffffffff);
	//   bus.wait_cycles(10);
	//   valid_strobe_O = '1;
	//   @(posedge clk);

	// bus.get_word(tlul_serial_out, rdata);
	// $display("read serial_out: 0x%08x", rdata);
	// bus.wait_cycles(4000);

  //end
  //end

    $finish;
	end
endmodule