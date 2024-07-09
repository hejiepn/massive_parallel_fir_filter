module student_fir_tb;

  // Clock and reset signals
  logic clk_i;
  logic rst_ni;

  // Input signals
  logic valid_strobe_in;
  logic [15:0] sample_in;

  // Output signals
  logic compute_finished_out;
  logic [15:0] sample_shift_out;
  logic valid_strobe_out;
  logic [31:0] y_out;

  // Memory to store the input samples from sin.mem
  logic [7:0] sin_mem [0:1023]; // Adjust the size based on your file
  integer i; // Loop variable

  // Instantiate the DUT (Device Under Test)
  student_fir dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .valid_strobe_in(valid_strobe_in),
    .sample_in(sample_in),
    .compute_finished_out(compute_finished_out),
    .sample_shift_out(sample_shift_out),
    .valid_strobe_out(valid_strobe_out),
    .y_out(y_out)
  );

  // Clock generation: 50 MHz clock -> period = 20ns
  always #10 clk_i = ~clk_i;

  // Initial block to apply stimulus
  initial begin
    // Initialize signals
    clk_i = 0;
    rst_ni = 0;
    valid_strobe_in = 0;
    sample_in = 0;

    // Load the sin.mem file
    $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/fv/data/sin_low.mem", sin_mem);

    // Apply reset
    #40 rst_ni = 1; // Wait for 40 ns to apply reset (2 clock cycles)

    // Wait for reset to propagate
    #20;

    // Apply test stimulus
    for (i = 0; i < 1024; i = i + 1) begin
      @(posedge clk_i);
      sample_in = {8'b0, sin_mem[i]}; // Zero-pad the 8-bit value to 16 bits
      valid_strobe_in <= 1;
      @(posedge clk_i);
      valid_strobe_in <= 0;
      wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high
    end

    // Finish simulation
    #200;
    $stop;
  end

  // Monitor to print values
  initial begin
    $monitor("Time: %0t | valid_strobe_in: %0b | sample_in: %0h | compute_finished_out: %0b | sample_shift_out: %0h | valid_strobe_out: %0b | y_out: %0h",
             $time, valid_strobe_in, sample_in, compute_finished_out, sample_shift_out, valid_strobe_out, y_out);
  end

endmodule
