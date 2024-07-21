module student_fir_parallel #(
	parameter int unsigned ADDR_WIDTH = 10,
	parameter int unsigned DATA_SIZE = 16,
	parameter int unsigned DEBUGMODE = 0,
	parameter int unsigned DATA_SIZE_FIR_OUT = 32,
	parameter int unsigned NUM_FIR = 4 //only even numbers
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

  tlul_pkg::tl_h2d_t tl_student_fir_i[NUM_FIR:0];
  tlul_pkg::tl_d2h_t tl_student_fir_o[NUM_FIR:0];

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

  import student_fir_parallel_reg_pkg::*;

  student_fir_parallel_reg2hw_t reg2hw;
  student_fir_parallel_hw2reg_t hw2reg;

  student_fir_parallel_reg_top student_fir_parallel_reg_top (
	.clk_i(clk_i),
	.rst_ni(rst_ni),

	.tl_i(tl_student_fir_i[NUM_FIR]),
	.tl_o(tl_student_fir_o[NUM_FIR]),

	.reg2hw(reg2hw),
	.hw2reg(hw2reg),

	.devmode_i(1'b1)
  );

  logic [DATA_SIZE-1:0] sample_shift_out_internal[NUM_FIR-1:0];
  logic valid_strobe_out_internal[NUM_FIR-1:0];
  logic [DATA_SIZE_FIR_OUT-1:0] y_out_internal [NUM_FIR-1:0];

    // Edge detection for valid_strobe_in
  logic valid_strobe_in_prev;
  logic valid_strobe_in_pos_edge;

  always_ff @(posedge clk_i) begin
    if (~rst_ni) begin
      valid_strobe_in_prev <= 0;
    end else begin
      valid_strobe_in_prev <= valid_strobe_in;
    end
  end

  assign valid_strobe_in_pos_edge = reg2hw.fir_write_in_samples.qe? 1'b1 : valid_strobe_in && ~valid_strobe_in_prev;
  assign sample_in_internal = reg2hw.fir_write_in_samples.qe? reg2hw.fir_write_in_samples.q : sample_in;

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
					.valid_strobe_in(valid_strobe_in_pos_edge),
					.sample_in(sample_in_internal),
					.sample_shift_out(sample_shift_out_internal[i]),
					.valid_strobe_out(valid_strobe_out_internal[i]),
					.y_out(y_out_internal[i]),
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
					.y_out(y_out_internal[i]),
					.tl_i(tl_student_fir_i[i]),
					.tl_o(tl_student_fir_i[i])
				);
			end
		end
	endgenerate

	//implement adder tree for y_out_internal[i] depending on valid_strobe_out_internal[i]
	 // Implementing the Adder Tree with Valid Strobe Check
    logic [DATA_SIZE_FIR_OUT-1:0] adder_tree[NUM_FIR-1:0];
    logic valid_strobe_tree[NUM_FIR-1:0];

    // Stage 1
    generate
        for (i = 0; i < NUM_FIR; i = i + 2) begin : adder_stage_1
            always_ff @(posedge clk_i or negedge rst_ni) begin
                if (!rst_ni) begin
                    adder_tree[i/2] <= 0;
                    valid_strobe_tree[i/2] <= 0;
                end else if (valid_strobe_out_internal[i] && valid_strobe_out_internal[i+1]) begin
                    adder_tree[i/2] <= y_out_internal[i] + y_out_internal[i+1];
                    valid_strobe_tree[i/2] <= 1;
                end else begin
                    valid_strobe_tree[i/2] <= 0;
                end
            end
        end
    endgenerate

    // Continue stages
    genvar stage;
    generate
        for (stage = 1; stage < $clog2(NUM_FIR); stage = stage + 1) begin : adder_stages
            for (i = 0; i < (NUM_FIR >> stage); i = i + 2) begin : adder_stage
                always_ff @(posedge clk_i or negedge rst_ni) begin
                    if (!rst_ni) begin
                        adder_tree[(NUM_FIR >> stage) + i/2] <= 0;
                        valid_strobe_tree[(NUM_FIR >> stage) + i/2] <= 0;
                    end else if (valid_strobe_tree[(NUM_FIR >> (stage-1)) + i] && valid_strobe_tree[(NUM_FIR >> (stage-1)) + i+1]) begin
                        adder_tree[(NUM_FIR >> stage) + i/2] <= adder_tree[(NUM_FIR >> (stage-1)) + i] + adder_tree[(NUM_FIR >> (stage-1)) + i+1];
                        valid_strobe_tree[(NUM_FIR >> stage) + i/2] <= 1;
                    end else begin
                        valid_strobe_tree[(NUM_FIR >> stage) + i/2] <= 0;
                    end
                end
            end
        end
    endgenerate

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            y_out <= 0;
            valid_strobe_out <= 0;
        end else if (valid_strobe_tree[0]) begin
            y_out <= adder_tree[0];
            valid_strobe_out <= 1;
        end else begin
            valid_strobe_out <= 0;
        end
    end

endmodule


	 /**
    logic [DATA_SIZE_FIR_OUT-1:0] adder_tree [NUM_FIR-1:0];
	logic valid_adder_stage[NUM_FIR-1:0];

    // Stage 1
    generate
        for (i = 0; i < NUM_FIR; i = i + 2) begin : adder_stage_1
            if (i+1 < NUM_FIR) begin
                assign adder_tree[i/2] = y_out_internal[i] + y_out_internal[i+1];
            end
        end
    endgenerate

    // Continue stages
    genvar stage;
    generate
        for (stage = 1; stage < $clog2(NUM_FIR); stage = stage + 1) begin : adder_stages
            for (i = 0; i < (NUM_FIR >> stage); i = i + 2) begin : adder_stage
                assign adder_tree[(NUM_FIR >> stage) + i/2] = adder_tree[(NUM_FIR >> (stage-1)) + i] + adder_tree[(NUM_FIR >> (stage-1)) + i+1];
            end
        end
    endgenerate

    assign y_out = adder_tree[0];
	// Assign valid_strobe_out based on the last valid strobe of the FIR chain
    assign valid_strobe_out = valid_strobe_out_internal[NUM_FIR-1];


endmodule
**/