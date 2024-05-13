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

 //start with rotate left
    bus.put_word(32'h00000004, 32'hFFFFFF01);
    bus.get_word(32'h00000004, rdata);
    $display("read RegB: 0x%08x", rdata);
    bus.wait_cycles(5);

//While the running light is running with a pause time of 5 cycles: A write access (writing 0x42) to the delay register followed by a read access.

    bus.put_word(32'h00000008, 32'hFFFFFF42);
    bus.get_word(32'h00000008, rdata);
    $display("read RegC: 0x%08x", rdata);
    bus.wait_cycles(5);

//Two complete cycles with the following configurations: #. mode=right, initial pattern=11111110, pause = 1 cycle #. mode=ping-pong, initial pattern=10000000, pause = 0 cycles (i.e. the pattern changes every clock cycle)

    bus.put_word(32'h00000000, 32'hFFFFFFFE);
    bus.get_word(32'h00000000, rdata);
    $display("read RegA: 0x%08x", rdata);

    bus.put_word(32'h00000008, 32'hFFFFFF01);
    bus.get_word(32'h00000008, rdata);
    $display("read RegC: 0x%08x", rdata);

    bus.put_word(32'h00000004, 32'hFFFFFF02); //rotate right
    bus.get_word(32'h00000004, rdata);
    $display("read RegB: 0x%08x", rdata);

    bus.wait_cycles(5);

    bus.put_word(32'h00000000, 32'hFFFFFF80);
    bus.get_word(32'h00000000, rdata);
    $display("read RegA: 0x%08x", rdata);

    bus.put_word(32'h00000008, 32'hFFFFFF00);
    bus.get_word(32'h00000008, rdata);
    $display("read RegC: 0x%08x", rdata);

    bus.put_word(32'h00000004, 32'hFFFFFF00);//ping pong
    bus.get_word(32'h00000004, rdata);
    $display("read RegB: 0x%08x", rdata);

    bus.wait_cycles(5);

//A read access to the pattern register which clearly shows the delayed arrival of the data at register bus after the rising clock edge.

    bus.get_word(32'h00000008, rdata);
    $display("read RegC: 0x%08x", rdata);
    
    bus.wait_cycles(5);
 

    $finish;
  end


endmodule



