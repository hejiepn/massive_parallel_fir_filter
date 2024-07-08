module student_dpbram_coeff #(
	parameter int unsigned AddrWidth = 10,
    parameter int unsigned CoeffDataSize = 16,
    parameter string INIT_F = ""
	) (
    input logic clk_i,
  	input logic rst_ni,
	input logic enb,
	input logic [AddrWidth-1:0] addrb,
	output logic [CoeffDataSize-1:0] dob,

	// TL-UL interface
	input  tlul_pkg::tl_h2d_t tl_i,
	output tlul_pkg::tl_d2h_t tl_o
);

  localparam int DataSize = 32;  //for the tlul_adapter_sram 32 is fixed

  logic        req;
  logic        we;
  logic [AddrWidth-1:0] addr;
  logic [DataSize-1:0] wdata;
  logic [DataSize-1:0] wmask;
  logic [DataSize-1:0] rdata;
  logic        rvalid;


  tlul_adapter_sram #(
    .SramAw     (AddrWidth),
    .SramDw     (DataSize),
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

	(* ram_style = "block" *) logic [31:0] mem[0:2**AddrWidth];

	  // Independent read interface for coefficient data
    always @(posedge clk_i) begin
        if (enb) begin
            dob <= mem[addrb][CoeffDataSize-1:0]; // Extract lower 16 bits
        end
    end

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
			// Read access:
			rdata <= mem[addr];
		end
	end

	always @(posedge clk_i, negedge rst_ni) begin
		if (!rst_ni) begin
			rvalid <= '0;
		end else begin
			rvalid <= (req && !we);
		end
	end

	// Load data from the INIT_F file during the initial block
	initial begin
		if (INIT_F != "") begin
			$display("Loading initialization file %s into BRAM.", INIT_F);
			$readmemh(INIT_F, mem);
		end
	end

endmodule
