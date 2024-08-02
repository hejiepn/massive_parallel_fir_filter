module student_fir_DAC_SDATA_tb;

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

  // Clock and reset signals
  logic clk_i;
  logic rst_ni;

  // Input signals
  logic [DATA_SIZE-1:0] sample_in;

  // Output signals
//   logic compute_finished_out;
  logic [DATA_SIZE-1:0] sample_shift_out;
  logic [DATA_SIZE_FIR_OUT-1:0] y_out;

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
  logic [DATA_SIZE-1:0] Data_O_R; //Data from Codec to HW (mono Channel)
  logic [DATA_SIZE-1:0] Data_O_L; //Data from Codec to HW (mono Channel)
  logic valid_strobe_out;

  logic AC_DAC_SDATA;
  logic AC_ADC_SDATA;
  logic valid_strobe;

  tlul_pkg::tl_h2d_t tl_student_fir_i[1:0];
  tlul_pkg::tl_d2h_t tl_student_fir_o[1:0];

  tlul_test_host bus(
    .clk_i(clk_i),
    .rst_no(rst_ni),
    .tl_i(tl_d2h),
    .tl_o(tl_h2d)
  );


  student_tlul_mux #(
  .NUM(2),
  .ADDR_OFFSET(16)
  ) tlul_mux_dpram (
      .clk_i,
      .rst_ni,
      .tl_host_i(tl_h2d),
      .tl_host_o(tl_d2h),
      .tl_device_i(tl_student_fir_i),
      .tl_device_o(tl_student_fir_o)
  );

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
    .valid_strobe_in(valid_strobe),
    .sample_in(Data_O_L),
    .valid_strobe_out(valid_strobe_out),
    .y_out(y_out),
  .tl_i(tl_student_fir_i[0]),
  .tl_o(tl_student_fir_o[0])
  );

 
  student_iis_handler_top #(
  .DATA_SIZE(DATA_SIZE),
  .DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT)
  ) student_iis_handler_top_ins (
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .AC_MCLK(AC_MCLK),
  .AC_BCLK(AC_BCLK),
  .AC_LRCLK(AC_LRCLK),
  .AC_DAC_SDATA(AC_DAC_SDATA), //send to codec
  .AC_ADC_SDATA(AC_ADC_SDATA), //get from codec
  .Data_I_R('0),
  .Data_I_L(y_out),
  .valid_strobe_I(valid_strobe_out),
  .Data_O_L(Data_O_L), //use left channel
  .Data_O_R(Data_O_R),
  .tl_i(tl_student_fir_i[1]),
  .tl_o(tl_student_fir_o[1]),
  .valid_strobe(valid_strobe)
);

    // IIS Dummy Device Instanciation

  logic [DATA_SIZE-1:0] TEST_Data_I_L;
  logic [DATA_SIZE-1:0] TEST_Data_I_R;

  logic [DATA_SIZE_FIR_OUT-1:0] TEST_Data_O_L;
  logic [DATA_SIZE_FIR_OUT-1:0] TEST_Data_O_R;
    

  iis_dummy_device iis_dummy(
    .clk_i (clk_i),
    .rst_ni(rst_ni),

    .AC_MCLK (AC_MCLK),  // Codec Master Clock
    .AC_BCLK (AC_BCLK),  // Codec Bit Clock
    .AC_LRCLK(AC_LRCLK),  // Codec Left/Right Clock
    .AC_ADC_SDATA(AC_ADC_SDATA), // Codec ADC Serial Data
    .AC_DAC_SDATA(AC_DAC_SDATA), // Codec DAC Serial Data

    .TEST_DATA_IN_L(TEST_Data_I_L),  // Data that is sent to the IIS_Handler (Left Channel)
    .TEST_DATA_IN_R(TEST_Data_I_R),  // Data that is sent to the IIS_Handler (Right Channel)

    .TEST_DATA_OUT_L(TEST_Data_O_L), // Data that came from the IIS_Handler (Left Channel)
    .TEST_DATA_OUT_R(TEST_Data_O_R)  // Data that came from the IIS_Handler (Right Channel)
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
    sample_in = 0;
    round_begin =0;
    TEST_Data_I_L = '0;
    TEST_Data_I_R = '0;

    // Load the sin.mem file
  if (DEBUGMODE == 1) begin
    $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie_copy_2/risc-v-lab-group-01/src/rtl/student/data/sin_low_debug.mem", sin_mem);
  end else begin
    $readmemh("/home/rvlab/groups/rvlab01/Desktop/dev_hejie_fir_testing/risc-v-lab-group-01/src/rtl/student/data/random.mem", sin_mem);
  end

  bus.reset();
    // Wait for reset to propagate
    #40;
  bus.wait_cycles(20);

  $display("Testbench started");

  // Apply test stimulus
  $display("Apply test stimulus:");
  

  for (int i = 0; i < MaxAddr; i = i + 1) begin
    TEST_Data_I_L = {'0, sin_mem[i]}; // Zero-pad the 8-bit value to 16 bits
    @(posedge valid_strobe);
    counting = 1;
    wait(valid_strobe_out == 1); // Wait for valid_strobe_out to go high
    counting = 0;
    $display("Number of clock cycles from valid_strobe_in to valid_strobe_out: %0d", clk_count);
    clk_count = 0; // Reset counter for next iteration
  end
  


    // Finish simulation
    #200000;

  // Testresultat
  /*
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
    $monitor("Time: %0t | valid_strobe: %0b | sample_in: %0h | sample_shift_out: %0h | valid_strobe_out: %0b | y_out: %0h",
             $time, valid_strobe, sample_in, sample_shift_out, valid_strobe_out, y_out);
  end

endmodule
