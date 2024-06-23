module student_audio_init_tb;
  logic clk;
  logic rst_n;
  wire sda;
  wire scl;
  wire sda_oe;
  wire scl_oe;
  logic [23:0] rcvd_data;
  logic slave_rcvd_done;
  logic audio_init_done = 0;
  integer fd;
  integer rcvd_counter = 1;
  tlul_pkg::tl_d2h_t tl_d2h;
  tlul_pkg::tl_h2d_t tl_h2d;


  always begin
    clk = '1;
    #10000;
    clk = '0;
    #10000;
  end

  pullup pullup_sda (sda);
  pullup pullup_scl (scl);

  assign sda = ~sda_oe ? 1'bz : 1'b0;
  assign scl = ~scl_oe ? 1'bz : 1'b0;

  student_audio_init DUT (
      .clk_i(clk),
      .rst_ni(rst_n),
      .sda_i(sda),
      .scl_i(scl),
      .sda_oe,
      .scl_oe,
      .tl_i(tl_h2d),
      .tl_o(tl_d2h)
  );

  tlul_test_host bus(
    .clk_i(clk),
    .rst_no(rst_n),
    .tl_i(tl_d2h),
    .tl_o(tl_h2d)
  );

  iic_dummy_slave iic_dummy (
      .sda (sda),
      .scl (scl),
      .data(rcvd_data),
      .done(slave_rcvd_done)
  );

  always_ff @(posedge slave_rcvd_done) begin
    $fdisplay(fd, "%d: %h", rcvd_counter, rcvd_data);
    rcvd_counter++;
  end

  initial begin
    bus.reset();
    bus.wait_cycles(50);

    fd = $fopen("./iic_data.txt", "w");
    if (fd) $display("File opened successfully: %0d", fd);
    else $display("File could not be opened");
    
    bus.put_word(32'h10200000, 32'h00000001);
    
    while (audio_init_done == 0) begin
      bus.get_word(32'h10200004, audio_init_done);
    end
    
    @(posedge slave_rcvd_done);

    $display("Audio init done");

    bus.wait_cycles(50);
    $fclose(fd);
    $finish;
  end

endmodule
