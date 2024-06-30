module student_iic_ctrl_tb;
  logic clk;
  logic rst_n;
  logic stb;
  logic [7:0] address;
  logic [7:0] data_in;
  logic done;
  logic err;
  wire sda;
  wire scl;
  wire sda_oe;
  wire scl_oe;

  logic [23:0] rcvd_data;
  logic slave_rcvd_done;

  // 50 MHz
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

  student_iic_ctrl DUT (
      .clk_i(clk),
      .rst_ni(rst_n),
      .stb_i(stb),
      .addr_i(address),
      .data_i(data_in),
      .done_o(done),
      .err_o(err),
      .sda_i(sda),
      .scl_i(scl),
      .sda_oe(sda_oe),
      .scl_oe(scl_oe)
  );

  iic_dummy_slave iic_dummy (
    .sda(sda),
    .scl(scl),
    .data(rcvd_data),
    .done(slave_rcvd_done)
  );

  initial begin
    rst_n = 0;
    #10000;
    rst_n = 1;
    $display(" Writing value 8'hAC to address 0");
    $display("Configuring master");
    @(posedge clk);
    data_in     = 8'h40;        //writing to slave register 1
    address   = 8'b01110110;  //slave address
    $display("Enabling master");
    stb       = 1; 
    @(posedge done);
    data_in = 8'h05;
    @(posedge done);
    data_in = 8'hAC;
    @(posedge done);
    $display("Master has finsihed writing");
    @(posedge slave_rcvd_done);
    if(rcvd_data == 23'h4005AC) $display("Successful: Slave: rcvd data %h = Master: written data %h", rcvd_data, 23'h4005AC);
    else $display("Failed: Slave data %h != Written data %h", rcvd_data, 23'h4005AC);
    $finish;
  end

endmodule
