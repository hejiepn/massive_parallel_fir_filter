module student_dac_out (
	input logic clk_i,
	input logic rst_ni,
	output logic dac_sdata_out
);

	logic dac_sdata_int;

	always_ff @(posedge clk_i or negedge rst_ni) begin
	if (!rst_ni) begin
		dac_sdata_int <= 1'b0;
	end else begin 
		dac_sdata_int <= ~dac_sdata_int;
	end 
end

assign dac_sdata_out = dac_sdata_int;

endmodule