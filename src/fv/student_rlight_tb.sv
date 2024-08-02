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

    // Default delay is 0 due to simulation. We know that we have to increase the delay (~30 000 000) in real life ;)
    // DUT should start with inital pattern and in pingpong mode
    bus.wait_cycles(100);

    // Write other patter - 00011000
    bus.put_word(32'h00000000, 32'h00000018);
    bus.get_word(32'h00000000, rdata);
    $display("read RegA: 0x%08x", rdata);

    // Change mode rotate left
    bus.put_word(32'h00000008, 32'hFFFFFFF2);
    bus.get_word(32'h00000008, rdata);
    $display("read RegC: 0x%08x", rdata);

    bus.wait_cycles(100);

    // Stop
    bus.put_word(32'h00000008, 32'hFFFFFFF0);
    bus.get_word(32'h00000008, rdata);
    $display("read RegC: 0x%08x", rdata);

    bus.wait_cycles(50);

    // Read current leds
    bus.get_word(32'h0000000C, rdata);
    $display("read RegD: 0x%08x", rdata);

    //  Change mode rotate right
    bus.put_word(32'h00000008, 32'hFFFFFFF1);
    bus.get_word(32'h00000008, rdata);
    $display("read RegC: 0x%08x", rdata);

    // Set Delay to 5
    bus.put_word(32'h00000004, 32'h00000005);
    bus.get_word(32'h00000004, rdata);
    $display("read RegB: 0x%08x", rdata);

    bus.wait_cycles(100);

    $finish;
  end


endmodule
