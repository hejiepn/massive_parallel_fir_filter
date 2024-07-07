module student_dpbram #(
    parameter int unsigned AddrWidth = 10,
    parameter int unsigned DataSize = 16,
    parameter string INIT_F = ""
) (
    input                  clk_i,
    // write port
    input                  wvalid,
    input  [DataSize-1:0] wdata,
    input  [AddrWidth-1:0] waddr,
    // read port
    output [DataSize-1:0] rdata,
    input  [AddrWidth-1:0] raddr,

	 // TL-UL interface
	input  tlul_pkg::tl_h2d_t tl_i,
	output tlul_pkg::tl_d2h_t tl_o
);

  logic        req;
  logic        we;
  logic [15:0] addr;
  logic [31:0] wmask;
  logic [31:0] rdata;
  logic        rvalid;

  tlul_adapter_sram #(
    .SramAw     (AddrWidth),
    .SramDw     (32),
    .Outstanding(1)
  ) adapter_i (
    .clk_i,
    .rst_ni,

    .tl_i,
    .tl_o,

    .req_o   (req),
    .gnt_i   (1'b1),    // Always grant as only one requester exists
    .we_o    (we),
    .addr_o  (addr),
    .wdata_o (wdata),
    .wmask_o (wmask),
    .rdata_i (rdata),
    .rvalid_i(rvalid),
    .rerror_i(2'b00)
  );

  (* ram_style = "block" *) logic [DataSize-1:0] storage[0:2**AddrWidth];
  
  logic [DataSize-1:0] storage_rdata;

  always @(posedge clk_i) begin
   rdata <= '0;
    if (req) begin
      if (we) begin
        // Write access:
        if (wmask[0]) mem[addr][7:0] <= wdata[7:0];
        if (wmask[8]) mem[addr][15:8] <= wdata[15:8];
        if (wmask[16]) mem[addr][23:16] <= wdata[23:16];
        if (wmask[24]) mem[addr][31:24] <= wdata[31:24];
      end
      storage_rdata <= mem[addr];
  end

  assign rdata = storage_rdata;
  end

  // Load data from the INIT_F file during the initial block
  initial begin
    if (INIT_F != "") begin
      $display("Loading initialization file %s into BRAM.", INIT_F);
      $readmemh(INIT_F, storage);
    end
  end

endmodule
