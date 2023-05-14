module student_tlul_mux_tb #(
	parameter int CONNECTED_SLAVES = 2);
  logic clk;
  logic rst_n;
  logic [7:0] led;
  tlul_pkg::tl_d2h_t tl_d2h;
  tlul_pkg::tl_h2d_t tl_h2d;
  
  tlul_pkg::tl_d2h_t children_o [CONNECTED_SLAVES];
  tlul_pkg::tl_h2d_t children_i [CONNECTED_SLAVES];

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
    .tl_i  (tl_h2d),
    .tl_o  (tl_d2h),
    .children_o,
    .children_i
  );
  
  genvar i;
  
  generate
  	  for (i = 0; i < CONNECTED_SLAVES; i=i+1) begin
  	  	dummy_device u0 (
  	  		.clk_i (clk),
  	  		.rst_ni(rst_n),
  	  		.tl_o(children_o[i]),
  	  		.tl_i(children_i[i])
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
    logic [31:0] rdata;
    logic [31:0] wdata;
    logic [31:0] addr; 
    bus.reset();

    // write and read pattern register 2x:
    for (int j = 0; j < CONNECTED_SLAVES; j=j+1) begin
    	//assumption is addresses are fifth bit
    	addr = j << 4; // remove blocking or irrelevant?
    	wdata = j + 1;
    	bus.put_word(addr, wdata);
    	$display("			wrote RegA: 0x%08x", wdata);
    end
    
    for (int j = 0; j < CONNECTED_SLAVES; j=j+1) begin
    	//assumption is addresses are fifth bit
    	addr = j << 4; // remove blocking or irrelevant?
    	rdata = '0;
    	bus.get_word(addr, rdata);
    	$display("			read  RegA: 0x%08x", rdata);
    end

    $finish;
  end


endmodule
