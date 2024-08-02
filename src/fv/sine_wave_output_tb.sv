module sine_wave_output_tb;

 	logic clk;
 	logic rst_ni;
    logic [23:0] sine_wave_out;
    tlul_pkg::tl_h2d_t tl_h2d;
  tlul_pkg::tl_d2h_t tl_d2h;

    sine_wave_output sin_wave_ins (
    .clk(clk),
    .rst_ni(rst_ni),
    .sine_wave_out(sine_wave_out)
	);

	    tlul_test_host bus(
    .clk_i(clk),
    .rst_no(rst_ni),
    .tl_i(tl_d2h),
    .tl_o(tl_h2d)
  );



    // 50 MHz
  always begin
    clk = '1;
    #10000;
    clk = '0;
    #10000;
  end

    initial begin

    		bus.reset();
    // Wait for reset to propagate
    #40;
	bus.wait_cycles(1000);


    $finish;
  end


endmodule