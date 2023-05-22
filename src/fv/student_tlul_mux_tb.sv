module student_tlul_mux_tb;
  localparam CONNECTED_SLAVES = 2;

  logic clk;
  logic rst_n;
  tlul_pkg::tl_d2h_t tl_host_d2h;  // tl_host_d2h
  tlul_pkg::tl_h2d_t tl_host_h2d;

  tlul_pkg::tl_d2h_t tl_device_d2h[CONNECTED_SLAVES];
  tlul_pkg::tl_h2d_t tl_device_h2d[CONNECTED_SLAVES];

  // 50 MHz
  always begin
    clk = '1;
    #10000;
    clk = '0;
    #10000;
  end

  student_tlul_mux #(
      .NUM(CONNECTED_SLAVES)
  ) DUT (
      .clk_i(clk),
      .rst_ni(rst_n),
      .tl_host_i(tl_host_h2d),
      .tl_host_o(tl_host_d2h),
      .tl_device_o(tl_device_d2h),
      .tl_device_i(tl_device_h2d)
  );

  localparam SHIFTOUT_OFFSET = 0;
  localparam SHIFTIN_OFFSET = 4;
  localparam SHIFTCFG_OFFSET = 8;

  genvar i;
  generate
    for (i = 0; i < CONNECTED_SLAVES; i = i + 1) begin
      rvlab_regdemo u0 (
          .clk_i (clk),
          .rst_ni(rst_n),
          .tl_o  (tl_device_d2h[i]),
          .tl_i  (tl_device_h2d[i])
      );
    end
  endgenerate

  tlul_test_host bus (
      .clk_i (clk),
      .rst_no(rst_n),
      .tl_i  (tl_host_d2h),
      .tl_o  (tl_host_h2d)
  );

  //this assumes that bus.reset() is done as first call
  //the negedge is here to prevent assertion errors before the reset
  assert property (@(negedge clk) !$isunknown(tl_host_d2h));
  assert property (@(negedge clk) !$isunknown(tl_host_h2d));
  assert property (@(negedge clk) !$isunknown(tl_device_d2h));
  assert property (@(negedge clk) !$isunknown(tl_device_h2d));


  initial begin
    logic [31:0] res;
    logic [31:0] wdata;
    logic [31:0] addr;
    logic [31:0] errcnt;

    logic [31:0] expected_value;

    bus.reset();
    errcnt = '0;

    for (int j = 0; j < CONNECTED_SLAVES; j = j + 1) begin
      //assumption is that bottom 6 bits are for internal addressing
      //inside the TL-UL MUX devices
      //feel free to change this if you require more/less
      addr  = j << 6;
      wdata = j + 1;
      bus.put_word(addr + SHIFTIN_OFFSET, wdata);
      bus.put_word(addr + SHIFTCFG_OFFSET, 6'b000010);
    end


    for (int j = 0; j < CONNECTED_SLAVES; j = j + 1) begin
      //the assumption here is same as before
      addr = j << 6;
      bus.get_word(addr + SHIFTIN_OFFSET, res);
      expected_value = j + 1;
      if (res != expected_value) begin
        $error("SHIFTIN is incorrect: should be %u, is %u", expected_value, res);
        errcnt = errcnt + 1;
      end

      bus.get_word(addr + SHIFTOUT_OFFSET, res);
      expected_value = (j + 1) << 1;
      if (res != expected_value) begin
        $error("SHIFTOUT is incorrect: should be %u, is %u", expected_value, res);
        errcnt = errcnt + 1;
      end
    end

    if (errcnt > 0) begin
      $display("### TESTS FAILED WITH %d ERRORS###", errcnt);
    end else begin
      $display("### TESTS PASSED ###");
    end
    $finish;
  end


endmodule
