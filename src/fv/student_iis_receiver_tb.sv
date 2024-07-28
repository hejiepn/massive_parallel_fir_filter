module student_iis_receiver_tb;

localparam int DATA_SIZE = 16;
localparam int DATA_SIZE_FIR_OUT = 32;
localparam int test_tlul = 0;
localparam int tlul_serial_in = 32'h00000000;
localparam int tlul_serial_out = 32'h00000004;
localparam int tlul_pcm_out = 32'h00000008;
localparam int tlul_pcm_in = 32'h0000000C;

tlul_pkg::tl_d2h_t tl_d2h;
tlul_pkg::tl_h2d_t tl_h2d;

logic clk_i;
logic rst_ni;

// 50 MHz Clock Generation
always begin
  clk_i = '1;
  #10000;
  clk_i = '0;
  #10000;
end

// Student IIS Handler Instanciation
logic AC_MCLK;
logic AC_BCLK;
logic AC_LRCLK;
logic AC_ADC_SDATA;
logic AC_DAC_SDATA;

logic [DATA_SIZE-1:0] Data_rx;

logic valid_strobe_rx;

logic BCLK_Fall_int;
logic BCLK_Rise_int;
logic LRCLK_Fall_int;
logic LRCLK_Rise_int;

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

student_iis_receiver #(
  .DATA_SIZE(DATA_SIZE)
)student_iis_receiver_inst(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .AC_ADC_SDATA(AC_ADC_SDATA),
  .AC_LRCLK(AC_LRCLK),
  .LRCLK_Rise(LRCLK_Rise_int),
  .LRCLK_Fall(LRCLK_Fall_int),
  .BCLK_Rise(BCLK_Rise_int),
  .Data_O(Data_rx),
  .valid_strobe(valid_strobe_rx)
);

// IIS Dummy Device Instanciation
logic [DATA_SIZE-1:0] TEST_Data_I;

int fd_r;
int fd_w;

int num_cycles = 10;
int succeeded = 0;
int failed = 0;
int failed_cycle [];
int index_failed_cycle = 0;

int f_err = 0;

initial begin
  $display("Start testbench...\n");

  // open file with input Test Data
  fd_r = $fopen("../../../src/fv/data/test.hex", "r");
  if (fd_r) $display("File opened successfully: %0d", fd_r);
  else $display("File could not be opened");

  // open file with output Test Data
  fd_w = $fopen("./test_out_receiver.hex", "w");
  if (fd_w) $display("File opened successfully: %0d", fd_w);
  else $display("File could not be opened");

  // Create NegEdge for reset
  rst_ni = '1;
  #10000;
  rst_ni = '0;
  #10000;
  rst_ni = '1;

  // Simulation Loop
  for (int cycle = 0; cycle < num_cycles; cycle++) begin
    // Read input data
    f_err = $fscanf(fd_r, "%h", TEST_Data_I);

    // // Check for end of file
    // if (f_err == 0 || f_err == -1) begin
    //   $display("End of input file reached.");
    //   disable sim_loop;
    // end

    // Drive input data bit by bit
    for (int bit_idx = DATA_SIZE-1; bit_idx >= 0; bit_idx--) begin
      AC_ADC_SDATA = TEST_Data_I[bit_idx];
	  $display("Cycle %0d: Data: %h", cycle, AC_ADC_SDATA);

      // Wait for BCLK falling edge
      @(negedge BCLK_Fall_int);

      // Capture and check the received data
      if (valid_strobe_rx) begin
        $fwrite(fd_w, "%h\n", Data_rx);
        if (Data_rx != TEST_Data_I) begin
          failed++;
          failed_cycle[index_failed_cycle] = cycle;
          index_failed_cycle++;
          $display("Cycle %0d: Mismatch - Expected: %h, Received: %h", cycle, TEST_Data_I, Data_rx);
        end else begin
          succeeded++;
          $display("Cycle %0d: Success - Data: %h", cycle, Data_rx);
        end
      end
    end

    // Insert some delay (simulate real-time processing)
    #10000;
  end

  $display("Simulation completed.");
  $display("Succeeded: %0d, Failed: %0d", succeeded, failed);

  // Close files
  $fclose(fd_r);
  $fclose(fd_w);

  $finish;
end
endmodule
