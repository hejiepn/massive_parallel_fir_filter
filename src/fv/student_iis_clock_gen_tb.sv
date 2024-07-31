module student_iis_clock_gen_tb;

  // Clock and reset
  logic clk_i;
  logic rst_ni;

  // Clock signals generated by the DUT (Device Under Test)
  logic AC_MCLK;
  logic AC_BCLK;
  logic AC_LRCLK;

  // Edge indicators
  logic BCLK_Fall_int;
  logic BCLK_Rise_int;
  logic LRCLK_Fall_int;
  logic LRCLK_Rise_int;

  int bclk_fall_count;
  int bclk_rise_count;

  // Parameters
  localparam int DATA_SIZE = 16;

  // DUT instantiation
  student_iis_clock_gen #(
    .DATA_SIZE(DATA_SIZE)
  ) student_iis_clock_gen_inst (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .AC_MCLK(AC_MCLK),
    .AC_BCLK(AC_BCLK),
    .BCLK_Fall(BCLK_Fall_int),
    .BCLK_Rise(BCLK_Rise_int),
    .AC_LRCLK(AC_LRCLK),
    .LRCLK_Fall(LRCLK_Fall_int),
    .LRCLK_Rise(LRCLK_Rise_int)
  );

  // Clock generation: 50 MHz
  initial begin
    clk_i = 0;
    forever #10 clk_i = ~clk_i;  // 50 MHz clock period = 20 ns (10 ns high, 10 ns low)
  end

  // Test sequence
  initial begin
    $display("Start testbench...\n");

    // Apply reset
    rst_ni = 0;
    #100;  // 100 ns of reset
    rst_ni = 1;

    // Wait for some time to observe the clocks
    #2000;  // Observe clocks for 2000 ns
    
	@(posedge LRCLK_Fall_int);
	bclk_fall_count = 0;
  @(posedge LRCLK_Rise_int);
  bclk_rise_count = 0;
	$display("Number of BCLK fall between two LRCLK edges: %d", bclk_fall_count);
	@(posedge LRCLK_Fall_int);
  $display("Number of BCLK rise between two LRCLK edges: %d", bclk_rise_count);
	@(posedge LRCLK_Rise_int);
	

    // Check the generated clocks
    check_clock_signals();

    $display("End testbench...\n");
    $finish;
  end

  // Procedure to check the generated clocks
  task check_clock_signals;
    begin
      // Check AC_MCLK
      if ($isunknown(AC_MCLK)) begin
        $error("AC_MCLK is unknown!");
      end else begin
        $display("AC_MCLK is toggling correctly.");
      end

      // Check AC_BCLK
      if ($isunknown(AC_BCLK)) begin
        $error("AC_BCLK is unknown!");
      end else begin
        $display("AC_BCLK is toggling correctly.");
      end

      // Check AC_LRCLK
      if ($isunknown(AC_LRCLK)) begin
        $error("AC_LRCLK is unknown!");
      end else begin
        $display("AC_LRCLK is toggling correctly.");
      end

      // Check edge signals
      if ($isunknown(BCLK_Rise_int) || $isunknown(BCLK_Fall_int)) begin
        $error("BCLK edges are unknown!");
      end else begin
        $display("BCLK edges are generated correctly.");
      end

      if ($isunknown(LRCLK_Rise_int) || $isunknown(LRCLK_Fall_int)) begin
        $error("LRCLK edges are unknown!");
      end else begin
        $display("LRCLK edges are generated correctly.");
      end
    end
  endtask
/**
  // Monitor the clock edges (for debug purposes)
  always @(posedge AC_BCLK) begin
    $display("AC_BCLK rising edge at time %t", $time);
  end

  always @(negedge AC_BCLK) begin
    $display("AC_BCLK falling edge at time %t", $time);
  end

  always @(posedge AC_LRCLK) begin
    $display("AC_LRCLK rising edge at time %t", $time);
  end

  always @(negedge AC_LRCLK) begin
    $display("AC_LRCLK falling edge at time %t", $time);
  end
**/
   // Monitor the BCLK fall edge and count
  always @(posedge clk_i) begin
    if (BCLK_Fall_int) begin
      bclk_fall_count = bclk_fall_count + 1;
    end
	if (BCLK_Rise_int) begin
      bclk_rise_count = bclk_rise_count + 1;
    end
  end

endmodule