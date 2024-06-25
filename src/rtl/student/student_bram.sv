// Block RAM definition

module student_bram #(
    parameter int unsigned AddrWidth = 16,
    parameter int unsigned DataSize = 16,
    parameter string INIT_F = ""
) (
    input                  clk_i,
    // write port
    input                  wvalid,
    input  [ DataSize-1:0] wdata,
    input  [AddrWidth-1:0] waddr,
    // read port
    output [ DataSize-1:0] rdata,
    input  [AddrWidth-1:0] raddr
);

  (* ram_style = "block" *) logic [DataSize-1:0] storage[0:2**AddrWidth];
  logic [DataSize-1:0] storage_rdata;

  always @(posedge clk_i) begin
    if (wvalid) begin
      storage[waddr] <= wdata;
    end

    storage_rdata <= storage[raddr];
  end

  assign rdata = storage_rdata;

  // Load data from the INIT_F file during the initial block
  initial begin
    if (INIT_F != "") begin
      $display("Loading initialization file %s into BRAM.", INIT_F);
      $readmemh(INIT_F, storage);
    end
  end

endmodule
