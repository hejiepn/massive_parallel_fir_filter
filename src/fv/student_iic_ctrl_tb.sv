module student_iic_ctrl_tb;
  logic clk;
  logic rst_n;
  wire sda;
  wire scl;
  tlul_pkg::tl_h2d_t tl_h2d;
  tlul_pkg::tl_d2h_t tl_d2h;

  pullup(sda);
  pullup(scl);

  localparam logic [31:0] reg_SDA_EN = 32'h00000000;
  localparam logic [31:0] reg_SDA_WRITE = 32'h00000004;
  localparam logic [31:0] reg_SDA_READ = 32'h00000008;
  localparam logic [31:0] reg_SCL_EN = 32'h0000000C;
  localparam logic [31:0] reg_SCL_WRITE = 32'h00000010;
  localparam logic [31:0] reg_SCL_READ = 32'h00000014;

  localparam logic [31:0] reg_SET = 32'h00000001;
  localparam logic [31:0] reg_CLR = 32'h00000000;

  int error_cnt = 0;

  // 50 MHz
  always begin
    clk = '1;
    #10000;
    clk = '0;
    #10000;
  end

  student_iic_ctrl DUT (
    .clk_i (clk),
    .rst_ni(rst_n),
    .tl_i  (tl_h2d),
    .tl_o  (tl_d2h),
    .sda	(sda),
	.scl	(scl)
  );

  tlul_test_host bus(
    .clk_i(clk),
    .rst_no(rst_n),
    .tl_i(tl_d2h),
    .tl_o(tl_h2d)
  );
    
  initial begin
    logic [31:0] rdata;
    bus.reset();

    //start driving SDA/SCL pins to high
    bus.put_word(reg_SDA_WRITE, reg_SET);
	bus.put_word(reg_SDA_EN, reg_SET);
	bus.put_word(reg_SCL_WRITE, reg_SET);
	bus.put_word(reg_SCL_EN, reg_SET);
    bus.wait_cycles(20);

    // Check the SDA and SCL outputs
    if (sda != 1) begin
		$fatal("SDA output mismatch");
		error_cnt++;
	end
	$display("SDA output is: %b", sda);
	if (scl != 1) begin
		$fatal("SCL output mismatch");
		error_cnt++;
	end
	$display("SCL output is: %b", scl);

	bus.wait_cycles(20);

    // Disable the SDA and SCL drivers
   	bus.put_word(reg_SDA_EN, reg_CLR);
	bus.put_word(reg_SCL_EN, reg_CLR);
	bus.wait_cycles(20);

    // Check the SDA and SCL inputs
    bus.get_word(reg_SDA_READ, rdata);
    $display("read reg_SDA_READ: %b", rdata[0]);
	if (rdata[0] != sda) begin
		$fatal("SDA read mismatch");
		error_cnt++;
	end
	$display("SDA input is: %b", sda);

	bus.get_word(reg_SCL_READ, rdata);
    $display("read reg_SCL_READ: %b", rdata[0]);
    if (rdata[0] != scl) begin
		$fatal("SCL read mismatch");
		error_cnt++;
	end
	$display("SCL input is: %b", scl);

    bus.wait_cycles(20);

	//driving SDA/SCL pins to low
    bus.put_word(reg_SDA_WRITE, reg_CLR);
	bus.put_word(reg_SDA_EN, reg_SET);
	bus.put_word(reg_SCL_WRITE, reg_CLR);
	bus.put_word(reg_SCL_EN, reg_SET);
    bus.wait_cycles(20);

    // Check the SDA and SCL outputs
    if (sda != 0) begin
		$fatal("SDA output mismatch");
		error_cnt++;
	end
	$display("SDA output is: %b", sda);
	if (scl != 0) begin
		$fatal("SCL output mismatch");
		error_cnt++;
	end
	$display("SCL output is: %b", scl);

	bus.wait_cycles(100);

	// Display the number of errors
    if (error_cnt == 0) begin
      $display("Test passed with no errors.");
    end else begin
      $display("Test failed with %0d errors.", error_cnt);
    end
 
    $finish;
  end

endmodule