module student_dpram_samples_tlul #(
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

	always_ff @(posedge clk_i or negedge rst_ni) begin : proc_
			if(~rst_ni) begin
				 ena_i <= '0;
				 enb_i <= '0;
				 wea_i <= '0;
				 addra_i <= '0;
				 addrb_i <= '0;
				 dia_i <= '0;
			end else begin
				ena_i <= ena;
				 enb_i <= enb;
				 wea_i <= wea;
				 addra_i <= addra;
				 addrb_i <= addrb;
				 dia_i <= dia;
				 dob <= dob_i;
				 rdata <= '0;
				if (req) begin
						if (we) begin
								// Write access:
								addra_i <= addr;
								if (wmask[0]) dia_i[7:0] <= wdata[7:0];
								if (wmask[8]) dia_i[15:8] <= wdata[15:8];
								// if (wmask[16]) bram[addr][23:16] <= wdata[23:16];
								// if (wmask[24]) bram[addr][31:24] <= wdata[31:24];
						end
				// Read access:
					addrb_i <= addr;
					rdata <= {16'b0,dob};
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