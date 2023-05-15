module student_tlul_mux_tb;
  localparam CONNECTED_SLAVES = 2;

  logic clk;
  logic rst_n;
  tlul_pkg::tl_d2h_t tl_d2h;
  tlul_pkg::tl_h2d_t tl_h2d;
  
  tlul_pkg::tl_d2h_t tl_device_o [CONNECTED_SLAVES];
  tlul_pkg::tl_h2d_t tl_device_i [CONNECTED_SLAVES];

  // 50 MHz
  always begin
    clk = '1;
    #10000;
    clk = '0;
    #10000;
  end
  
  student_tlul_mux #(.NUM(CONNECTED_SLAVES)) DUT (
    .clk_i (clk),
    .rst_ni(rst_n),
    .tl_host_i  (tl_h2d),
    .tl_host_o  (tl_d2h),
    .tl_device_o,
    .tl_device_i
  );
  
  genvar i;  
  generate
  	  for (i = 0; i < CONNECTED_SLAVES; i=i+1) begin
  	  	dummy_device u0 (
  	  		.clk_i (clk),
  	  		.rst_ni(rst_n),
  	  		.tl_o(tl_device_o[i]),
  	  		.tl_i(tl_device_i[i])
  	  		);
  	  end
  endgenerate

  tlul_test_host bus(
    .clk_i(clk),
    .rst_no(rst_n),
    .tl_i(tl_d2h),
    .tl_o(tl_h2d)
  );
    
  initial begin
    logic [31:0] res;
    logic [31:0] wdata;
    logic [31:0] addr;
    logic [31:0] errcnt;
    
    logic [31:0] plus_res;
    logic [31:0] mul_res;

    bus.reset();
    errcnt = '0;

    // write and read pattern register 2x:
    for (int j = 0; j < CONNECTED_SLAVES; j=j+1) begin
    	//assumption is addresses are fifth bit and onward
    	addr = j << 4; // remove blocking or irrelevant?
    	wdata = j + 1;
    	bus.put_word(addr, wdata);
    	bus.put_word(addr+4, wdata+1);
    end
    
    
    for (int j = 0; j < CONNECTED_SLAVES; j=j+1) begin
    	//assumption is addresses are fifth bit
    	addr = j << 4; // remove blocking or irrelevant?
    	bus.get_word(addr+8, res);
    	plus_res = j+j+3;
    	if (res != plus_res) begin
			$error("res should be %u, is %u", plus_res, res);
			errcnt = errcnt+1;
    	end
    	bus.get_word(addr+12, res);
    	mul_res = (j+1) * (j + 2);
    	if (res != mul_res) begin
			$error("res should be %u, is %u", mul_res, res);
			errcnt = errcnt+1;
    	end
    end
    
    if (errcnt > 0) begin
    	$display("### TESTS FAILED WITH %d ERRORS###", errcnt);
    end
    else begin
    	$display("### TESTS PASSED ###");
    end
    $finish;
  end


endmodule
