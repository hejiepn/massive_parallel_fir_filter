module student_fir_parallel #(
	parameter int unsigned ADDR_WIDTH = 10,
	parameter int unsigned DATA_SIZE = 16,
	parameter int unsigned DEBUGMODE = 0,
	parameter int unsigned DATA_SIZE_FIR_OUT = 32,
	parameter int unsigned NUM_FIR = 10
) (
	input logic clk_i,
    input logic rst_ni,
	input logic valid_strobe_in,
    input logic [DATA_SIZE-1:0] sample_in,

    //output logic compute_finished_out,
    //output logic [DATA_SIZE-1:0] sample_shift_out,
	output logic valid_strobe_out,
    output logic [DATA_SIZE_FIR_OUT-1:0] y_out,
	
	input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)
    output tlul_pkg::tl_d2h_t tl_o  //slave output (this module's response)
);

  tlul_pkg::tl_h2d_t tl_student_fir_i[NUM_FIR-1:0];
  tlul_pkg::tl_d2h_t tl_student_fir_o[NUM_FIR-1:0];

  student_tlul_mux #(
	.NUM(NUM_FIR),
	.ADDR_OFFSET(16)
  ) tlul_mux_dpram (
      .clk_i,
      .rst_ni,
      .tl_host_i(tl_i),
      .tl_host_o(tl_o),
      .tl_device_i(tl_student_fir_i),
      .tl_device_o(tl_student_fir_o)
  );

  logic [DATA_SIZE-1:0] sample_shift_out_internal[NUM_FIR-1:0];
  logic valid_strobe_out_internal[NUM_FIR-1:0];
  logic [DATA_SIZE_FIR_OUT-1:0] y_out [NUM_FIR-1:0];

	genvar i;
	generate
		for(i = 0; i < NUM_FIR; i++) begin : fir
			if (i == 0) begin
				student_fir #(
					.ADDR_WIDTH(ADDR_WIDTH),
					.DATA_SIZE(DATA_SIZE),
					.DEBUGMODE(DEBUGMODE),
					.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT)
				) fir_i_first (
					.clk_i(clk_i),
					.rst_ni(rst_ni),
					.valid_strobe_in(valid_strobe_in),
					.sample_in(sample_in),
					.sample_shift_out(sample_shift_out_internal[i]),
					.valid_strobe_out(valid_strobe_out_internal[i]),
					.y_out(y_out[i]),
					.tl_i(tl_student_fir_i[i]),
					.tl_o(tl_student_fir_i[i])
				);
			end else begin
				student_fir #(
					.ADDR_WIDTH(ADDR_WIDTH),
					.DATA_SIZE(DATA_SIZE),
					.DEBUGMODE(DEBUGMODE),
					.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT)
				) fir_i_middle (
					.clk_i(clk_i),
					.rst_ni(rst_ni),
					.valid_strobe_in(valid_strobe_out_internal[i-1]),
					.sample_in(sample_shift_out_internal[i-1]),
					.sample_shift_out(sample_shift_out_internal[i]),
					.valid_strobe_out(valid_strobe_out_internal[i]),
					.y_out(y_out[i]),
					.tl_i(tl_student_fir_i[i]),
					.tl_o(tl_student_fir_i[i])
				);
			end
		end
	endgenerate


	//implement adder tree for y_out[i] depending on valid_strobe_out_internal[i]
	 // Implementing the Adder Tree
    logic [DATA_SIZE_FIR_OUT-1:0] adder_tree [NUM_FIR-1:0];

    // Stage 1
    generate
        for (i = 0; i < NUM_FIR; i = i + 2) begin : adder_stage_1
            if (i+1 < NUM_FIR) begin
                assign adder_tree[i/2] = y_out_internal[i] + y_out_internal[i+1];
            end else begin
                assign adder_tree[i/2] = y_out_internal[i];
            end
        end
    endgenerate

    // Continue stages
    genvar stage;
    generate
        for (stage = 1; stage < $clog2(NUM_FIR); stage = stage + 1) begin : adder_stages
            for (i = 0; i < NUM_FIR >> stage; i = i + 2) begin : adder_stage
                if (i+1 < (NUM_FIR >> stage)) begin
                    assign adder_tree[(NUM_FIR >> stage) + i/2] = adder_tree[(NUM_FIR >> (stage-1)) + i] + adder_tree[(NUM_FIR >> (stage-1)) + i+1];
                end else begin
                    assign adder_tree[(NUM_FIR >> stage) + i/2] = adder_tree[(NUM_FIR >> (stage-1)) + i];
                end
            end
        end
    endgenerate

    assign y_out = adder_tree[0];


endmodule