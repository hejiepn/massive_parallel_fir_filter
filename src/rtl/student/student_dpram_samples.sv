module student_dpram_samples #(
    parameter int unsigned AddrWidth = 10,
    parameter int unsigned DataSize = 16,
    parameter string INIT_F = ""
	) (
	input logic clk_i,
	input logic ena,
	input logic enb,
	input logic wea,
	input logic [AddrWidth-1:0] addra,
	input logic [AddrWidth-1:0] addrb,
	input logic [DataSize-1:0] dia,
	output logic [DataSize-1:0] dob
	);

	//logic [DataSize-1:0] read_data;

	(* ram_style = "block" *) logic [DataSize-1:0] bram[0:2**AddrWidth];

	//dpram in read-first mode, recommended by amd when simple synchronous clock dpram
	always @(posedge clk_i) begin
		if (enb) begin
			dob <= bram[addrb];
		end
		if (ena) begin
			if (wea) begin
				bram[addra] <= dia;
			end
		end
	end

	//assign dob = read_data;

	// Load data from the INIT_F file during the initial block
	initial begin
		if (INIT_F != "") begin
			$display("Loading initialization file %s into BRAM.", INIT_F);
			$readmemh(INIT_F, bram);
			$display("Initialization file %s loaded successfully.", INIT_F);
    	end else begin
        	$display("Initialization file not specified.");
    	end
	end

endmodule
