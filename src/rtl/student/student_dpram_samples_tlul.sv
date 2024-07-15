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

	localparam int DataSizeBram = 32;  //for the tlul_adapter_sram 32 is fixed

	logic        				req;
	logic        				we;
	logic [AddrWidth-1:0] 	  addr;
	logic [DataSizeBram-1:0] wdata;
	logic [DataSizeBram-1:0] wmask;
	logic [DataSizeBram-1:0] rdata;
	logic					rvalid;

	logic [DataSize-1:0] temp_bram[0:1023];  // Maximal 1024 Einträge einlesen
	logic [DataSize-1:0] read_data;

	tlul_adapter_sram #(
    .SramAw     (AddrWidth),
    .SramDw     (DataSizeBram),
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

	(* ram_style = "block" *) logic [DataSizeBram-1:0] bram[0:2**AddrWidth-1];

	always @(posedge clk_i) begin
		rdata <= '0;
		if (req) begin
			if (we && !(ena&&wea)) begin
				// Write access:
				if (wmask[0]) bram[addr][7:0] <= wdata[7:0];
				if (wmask[8]) bram[addr][15:8] <= wdata[15:8];
				if (wmask[16]) bram[addr][23:16] <= wdata[23:16];
				if (wmask[24]) bram[addr][31:24] <= wdata[31:24];
			end
			// Read access:
			rdata <= bram[addr];
		end
	end

	always @(posedge clk_i, negedge rst_ni) begin
		if (!rst_ni) begin
			rvalid <= '0;
		end else begin
			rvalid <= (req && !we);
		end
	end

	always @(posedge clk_i) begin
		if (ena) begin
			if (wea) begin
				bram[addra] <= {16'b0,dia};
			end
		end
	end

	always @(posedge clk_i) begin
		if (enb) begin
			if (wea && (addrb == addra)) begin
				read_data <= dia; // Wenn gleiche Adresse, dann den geschriebenen Wert lesen
			end else begin
				read_data <= bram[addrb][DataSize-1:0];
			end
		end
	end

	assign dob = read_data;

	// Load data from the INIT_F file during the initial block
	initial begin
		if (INIT_F != "") begin
			$display("Loading initialization file %s into BRAM.", INIT_F);
				$display("DebugMode is enabled.");
				$readmemh(INIT_F, temp_bram);
				// Daten in BRAM kopieren, angepasst auf die Adressbreite
				for (int i = 0; i < 2**AddrWidth; i++) begin
					bram[i] = {16'b0,temp_bram[i]};
					$display("Initial bram[%0d] = %h", i, bram[i]);  // Debug-Ausgabe hinzufügen
				end
			$display("Initialization file %s loaded successfully.", INIT_F);
    	end else begin
        	$display("Initialization file not specified.");
    	end
	end

endmodule