module student_dpram_samples_tlul_copy #(
    parameter int unsigned AddrWidth = 10,
    parameter int unsigned DataSize = 16,
	parameter int unsigned DebugMode = 0,
    parameter string INIT_F = ""
	) (
	input logic clk_i,
	input logic rst_ni,
	input logic ena,
	input logic enb,
	input logic wea,
	input logic [AddrWidth-1:0] addra,
	input logic [AddrWidth-1:0] addrb,
	input logic [DataSize-1:0] dia,
	output logic [DataSize-1:0] dob,

	// TL-UL interface
	input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)
	output tlul_pkg::tl_d2h_t tl_o  //slave output (this module's response)
	);

	localparam int TL_DataSize = 32;  //for the tlul_adapter_sram 32 is fixed

	logic        				req;
	logic        				we;
	logic [AddrWidth-1:0] 	  addr;
	logic [TL_DataSize-1:0] wdata;
	logic [TL_DataSize-1:0] wmask;
	logic [TL_DataSize-1:0] rdata;
	logic					rvalid;

	logic ena_i;
	logic enb_i;
	logic wea_i;
	logic [AddrWidth-1:0] addra_i;
	logic [AddrWidth-1:0] addrb_i;
	logic [DataSize-1:0] dia_i;
	logic [DataSize-1:0] dob_i;

	logic [TL_DataSize-1:0] dia_i_tlul;
	logic [TL_DataSize-1:0] dia_i_tlul_prev;;
	logic [TL_DataSize-1:0] dia_o_tlul;
    // logic write_active_tlul; // new signal to track write status
	// logic read_active_tlul;

	tlul_adapter_sram #(
    .SramAw     (AddrWidth),
    .SramDw     (TL_DataSize),
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

  student_dpram_samples #(
  	.AddrWidth(AddrWidth),
    .DataSize(DataSize),
	.DebugMode(DebugMode),
    .INIT_F(INIT_F)
	) dpram_samples (
	.clk_i,
	.ena(ena_i),
	.enb(enb_i),
	.wea(wea_i),
	.addra(addra_i),
	.addrb(addrb_i),
	.dia(dia_i),
	.dob(dob_i)
	);

	assign ena_i = ena || req;
	assign enb_i = enb || rvalid;
	assign wea_i = wea || we;
	assign addra_i = we? addr : addra; //tlul priority
	assign addrb_i = rvalid? addr : addrb; //tlul priority
	assign dia_i = we? dia_i_tlul[DataSize-1:0] : dia; //tlul priority
	assign dob = dob_i;
	assign dia_o_tlul = {'0,dob_i};


	always_ff @(posedge clk_i or negedge rst_ni) begin : tlul_read_write_proc
		if (!rst_ni) begin
			dia_i_tlul <= '0;
			dia_i_tlul_prev <= '0;
		end else begin
			rdata <= '0;
			if (req) begin
				if (we) begin
				// Write access:
					if (wmask[0]) dia_i_tlul[7:0] <= wdata[7:0];
					if (wmask[8]) dia_i_tlul[15:8] <= wdata[15:8];
					if (wmask[16]) dia_i_tlul[23:16] <= wdata[23:16];
					if (wmask[24]) dia_i_tlul[31:24] <= wdata[31:24];
					//$display("we and req high:wdata[7:0]: %2x", wdata[7:0]);
					// $display("we and req high:wdata[15:8]: %2x", wdata[15:8]);
					// $display("dia_i_tlul: %8x", dia_i_tlul);
					//dia_i_tlul_prev <= dia_i_tlul;
				end
			// Read access:
				rdata <= dia_o_tlul;
				// $display("dob_i:%4x", dob_i);
				// $display("dia_o_tlul: %8x", dia_o_tlul);
			end
		end
	end

	always @(posedge clk_i, negedge rst_ni) begin
		if (!rst_ni) begin
			rvalid <= '0;
		end else begin
			rvalid <= (req && !we);
		end
	end

endmodule