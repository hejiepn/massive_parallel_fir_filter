//file: student_iis_handler_tb.sv
//description: Testbench for student_iis_handler.sv. Tests the functionality by reading a file with test data, passing this data to the IIS_Dummy_Device,
//             which sends it to the IIS_Handler. The IIS_Handler then passes the data to the Effect_Dummy, which sends it back to the IIS_Handler.
//             The IIS_Handler then sends the data to the IIS_Dummy_Device, which writes it to a file again.   

//Block diagram of the testbench:
/*
                    ┌──────────────────────┐                ┌──────────────────────┐             ┌─────────────────────┐
                    │                      ◄──────MCLK──────┤                      │             │                     │
   TEST_DATA_IN─────►                      │                │                      │             │                     │
                    │                      │                │                      ├─DATA_O_L────►                     │
                    │                      ◄──────BCLK──────┤                      │             │                     │
                    │                      │                │                      │             │                     │
                    │                      │                │                      │             │                     │
                    │    IIS_Dummy_Device  ◄──────LRCLK─────┤     IIS_Handler      │             │     Effect_Dummy    │
                    │                      │                │                      │             │                     │
                    │                      │                │                      │             │                     │
                    │                      │                │                      │             │                     │
◄───TEST_DATA_OUT───┤                      │                │                      ◄──DATA_I_L───┤                     │
                    │                      ├────ADC_SDATA───►                      │             │                     │
                    │                      │                │                      │             │                     │
                    │                      ◄────DAC_SDATA───┤                      │             │                     │
                    └──────────────────────┘                └──────────────────────┘             └─────────────────────┘
*/

module dummy_effect_device (
    input logic clk_i,
    input logic rst_ni,

    input  logic        valid_strobe,  // 
    input  logic [15:0] Data_I_L,      // Data from IIS handler (Left Channel)
    input  logic [15:0] Data_I_R,      // Data from IIS handler (Right Channel)
    output logic [15:0] Data_O_L,      // Data to IIS handler (Left Channel)
    output logic [15:0] Data_O_R       // Data to IIS handler (Right Channel)

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

  // Set Data_O_L and Data_O_R to Data_I_L and Data_I_R when valid_strobe rises
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      Data_O_L <= 16'd0;
      Data_O_R <= 16'd0;
    end else begin
      if (valid_strobe_Rise) begin
        Data_O_L <= Data_I_L;
        Data_O_R <= Data_I_R;
      end
    end
  end

endmodule


module student_iis_handler_tb;
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

  logic [15:0] Data_I_L;
  logic [15:0] Data_I_R;
  logic [15:0] Data_O_L;
  logic [15:0] Data_O_R;

  logic valid_strobe;

  student_iis_handler DUT (
      .clk_i (clk),
      .rst_ni(rst_n),

      // To Audio Codec
      .AC_MCLK (AC_MCLK),  // Codec Master Clock
      .AC_BCLK (AC_BCLK),  // Codec Bit Clock
      .AC_LRCLK(AC_LRCLK),  // Codec Left/Right Clock
      .AC_ADC_SDATA(AC_ADC_SDATA), // Codec ADC Serial Data
      .AC_DAC_SDATA(AC_DAC_SDATA), // Codec DAC Serial Data

      // // To/From HW
      .Data_I_L(Data_I_L),         // Data from Effect Module to be sent to Codec (Left Channel)
      .Data_I_R(Data_I_R),         // Data from Effect Module to be sent to Codec (Right Channel)
      .Data_O_L(Data_O_L),         // Data from the Codec to be sent to Effect Module (Left Channel)
      .Data_O_R(Data_O_R),         // Data from the Codec to be sent to Effect Module (Right Channel)
      .valid_strobe(valid_strobe)  // Valid strobe to Effect Module
  );


  // IIS Dummy Device Instanciation
  logic [15:0] TEST_Data_I_L;
  logic [15:0] TEST_Data_I_R;

  logic [15:0] TEST_Data_O_L;
  logic [15:0] TEST_Data_O_R;

    iis_dummy_device iis_dummy(
      .clk_i (clk),
      .rst_ni(rst_n),

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


  // Effect Dummy Device Instanciation
  dummy_effect_device effect_dummy(
      .clk_i (clk),
      .rst_ni(rst_n),

      .valid_strobe(valid_strobe),         // Codec valid_strobe

      .Data_I_L(Data_O_L),         // Data IIS Handler (Left Channel)
      .Data_I_R(Data_O_R),         // Data IIS Handler (Right Channel)
      .Data_O_L(Data_I_L),         // Data to IIS Handler (Left Channel)
      .Data_O_R(Data_I_R)          // Data to IIS Handler (Right Channel)
  );


  // Testbench specific signals
  logic [15:0] temp_l;
  logic [15:0] temp_r;

  int fd_r;
  int fd_w;
  logic [15:0] line;

  int num_cycles = 150;
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
    fd_w = $fopen("./test_out.hex", "w");
    if (fd_w) $display("File opened successfully: %0d", fd_w);
    else $display("File could not be opened");

    // load first data
    // f_err = $fgets(TEST_Data_I_L, fd_r);
    // f_err = $fgets(TEST_Data_I_R, fd_r);
	f_err = $fscanf(fd_r, "%h", TEST_Data_I_L);
	f_err = $fscanf(fd_r, "%h", TEST_Data_I_R);

    // initialize temp variables
    temp_l = 0;
    temp_r = 0;

    // Create NegEdge for reset
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
      $display("TEST_Data_I_L = %h \t TEST_Data_I_R = %h", TEST_Data_I_L, TEST_Data_I_L);
      $display("TEST_Data_O_L = %h \t TEST_Data_O_R = %h", TEST_Data_O_L, TEST_Data_O_R);

      // Check if Data matches with previous data
      if (TEST_Data_O_L == temp_l && TEST_Data_O_R == temp_r) begin
        $display("Success!");
        succeeded++;
      end else begin
        $display("Data_O is incorrect");
        failed++;
		failed_cycle[index_failed_cycle] = num_cycles;
		index_failed_cycle++;
      end

      // Write Data to file again
    //   $fwrite(fd_w, "%c%c",TEST_Data_O_L[7-:8],TEST_Data_O_L[15-:8]);
    //   $fwrite(fd_w, "%c%c",TEST_Data_O_R[7-:8],TEST_Data_O_R[15-:8]);
	  // Write Data to file again
		$fdisplay(fd_w, "%h", TEST_Data_O_L);
		$fdisplay(fd_w, "%h", TEST_Data_O_R);


      temp_l = TEST_Data_I_L;
      temp_r = TEST_Data_I_R;

      //get new data from file
    //   TEST_Data_I_L[7-:8]=$fgetc(fd_r);
    //   TEST_Data_I_L[15-:8]=$fgetc(fd_r);
    //   TEST_Data_I_R[7-:8]=$fgetc(fd_r);
    //   TEST_Data_I_R[15-:8]=$fgetc(fd_r);
	 f_err = $fscanf(fd_r, "%h", TEST_Data_I_L);
	 f_err = $fscanf(fd_r, "%h", TEST_Data_I_R);
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

    $finish;
  end


endmodule