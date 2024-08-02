module student_dpram_samples #(
    parameter int unsigned AddrWidth = 10,
    parameter int unsigned DataSize = 16,
	parameter int unsigned DebugMode = 0,
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
	logic [DataSize-1:0] temp_bram[0:1023];  // Maximal 1024 Einträge einlesen
	//logic [DataSize-1:0] read_data;

	(* ram_style = "block" *) logic [DataSize-1:0] bram[0:2**AddrWidth-1];

	always @(posedge clk_i) begin
		if (ena) begin
			if (wea) begin
				bram[addra] <= dia;
			end
		end
	end

	always @(posedge clk_i) begin
		if (enb) begin
			dob <= bram[addrb];
		end
	end

	// Load data from the INIT_F file during the initial block
	initial begin
		if (INIT_F != "") begin
			$display("Loading initialization file %s into BRAM.", INIT_F);
			if (DebugMode) begin
				//$display("DebugMode is enabled.");
				$readmemh(INIT_F, temp_bram);
				// Daten in BRAM kopieren, angepasst auf die Adressbreite
				for (int i = 0; i < 2**AddrWidth; i++) begin
					bram[i] = temp_bram[i];
					$display("Initial bram[%0d] = %h", i, bram[i]);  // Debug-Ausgabe hinzufügen
				end
			end else begin
				$readmemh(INIT_F, bram);
			end
			$display("Initialization file %s loaded successfully.", INIT_F);
    	end else begin
        	$display("Initialization file not specified.");
    	end
	end

endmodule