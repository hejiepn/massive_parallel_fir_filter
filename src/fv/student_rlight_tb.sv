module student_rlight_tb;
  logic clk;
  logic rst_n;
  logic [7:0] led;
  tlul_pkg::tl_d2h_t tl_d2h;
  tlul_pkg::tl_h2d_t tl_h2d;

  // 50 MHz
  always begin
    clk = '1;
    #10000;
    clk = '0;
    #10000;
  end

  student_rlight DUT (
    .clk_i (clk),
    .rst_ni(rst_n),
    .tl_i  (tl_h2d),
    .tl_o  (tl_d2h),
    .led_o (led)
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

    // write and read pattern register 2x:

    bus.put_word(32'h00000000, 32'h000000FF);
    bus.get_word(32'h00000000, rdata);
    $display("read pattern: 0x%08x", rdata);
    
    bus.wait_cycles(20);

    bus.put_word(32'h00000000, 32'h000000AA);
    bus.get_word(32'h00000000, rdata);
    $display("read pattern: 0x%08x", rdata);
    
    bus.wait_cycles(20);
    
    // ...

    $finish;
  end


endmodule
