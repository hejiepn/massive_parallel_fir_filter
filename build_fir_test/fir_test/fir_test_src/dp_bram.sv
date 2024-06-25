// Block RAM definition

module dp_bram #(
    parameter int unsigned AddrWidth = 16,
    parameter int unsigned DataSize = 16
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

  // Initialize all storage elements to 0
  initial begin
    integer i;
    for (i = 0; i < 2**AddrWidth; i = i + 1) begin
      storage[i] = {DataSize{1'b0}};
    end
  end

endmodule