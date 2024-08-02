module student_fir_parallel #(
	parameter int unsigned ADDR_WIDTH = 10,
	parameter int unsigned DATA_SIZE = 16,
	parameter int unsigned DEBUGMODE = 0,
	parameter int unsigned DATA_SIZE_FIR_OUT = 24,
	parameter int unsigned NUM_FIR = 2 //only numbers which are power of 2 are supported
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
	.NUM(NUM_FIR+1),
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
  logic [DATA_SIZE-1:0] sample_shift_in_internal[NUM_FIR-1:0];
  logic valid_strobe_out_internal[NUM_FIR-1:0];
  logic [NUM_FIR-1:0] [DATA_SIZE_FIR_OUT-1:0] y_out_internal;
  logic [DATA_SIZE-1:0] sample_in_internal_first;
 
    // Edge detection for valid_strobe_in
  logic valid_strobe_in_prev;
  logic valid_strobe_in_pos_edge;

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      valid_strobe_in_prev <= 0;
    end else begin
      valid_strobe_in_prev <= valid_strobe_in;
    end
  end

  //assign valid_strobe_in_pos_edge = reg2hw.fir_write_in_samples.qe? 1'b1 : valid_strobe_in && ~valid_strobe_in_prev;
  //assign sample_in_internal_first = reg2hw.fir_write_in_samples.qe? reg2hw.fir_write_in_samples.q : sample_in;

 assign valid_strobe_in_pos_edge = valid_strobe_in && ~valid_strobe_in_prev;
 //assign sample_in_internal_first = sample_in;

 logic useTlulSample;

  always_ff @(posedge clk_i, negedge rst_ni) begin
	if (~rst_ni) begin
	  sample_in_internal_first <= '0;
	  useTlulSample <= 1'b0;
	end else begin
	  if (reg2hw.fir_write_in_samples.qe) begin
		useTlulSample <= 1'b1;
	  end
	  if(valid_strobe_in_pos_edge) begin
			if(useTlulSample) begin
				sample_in_internal_first <= reg2hw.fir_write_in_samples.q;
			//$display("fir_write_in_samples.q: %4x", reg2hw.fir_write_in_samples.q);
				useTlulSample <= 1'b0;
			end else begin
				sample_in_internal_first <= sample_in;
			end
	  end
	end
  end

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
					.sample_in(sample_in_internal_first),
					.sample_shift_out(sample_shift_out_internal[i]),
					.valid_strobe_out(valid_strobe_out_internal[i]),
					.y_out(y_out_internal[i]),
					.tl_i(tl_student_fir_i[i]),
					.tl_o(tl_student_fir_o[i])
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
					.valid_strobe_in(valid_strobe_in_pos_edge),
					.sample_in(sample_shift_in_internal[i-1]),
					.sample_shift_out(sample_shift_out_internal[i]),
					.valid_strobe_out(valid_strobe_out_internal[i]),
					.y_out(y_out_internal[i]),
					.tl_i(tl_student_fir_i[i]),
					.tl_o(tl_student_fir_o[i])
				);
			end
		end
	endgenerate


	always_ff @(posedge clk_i, negedge rst_ni) begin
		if (~rst_ni) begin
			for (int i = 0; i < NUM_FIR; i++) begin
      			sample_shift_in_internal[i] <= '0;
    		end
		end else begin
			if(valid_strobe_out_internal[NUM_FIR-1]) begin
				for (int i = 0; i < NUM_FIR; i++) begin
					sample_shift_in_internal[i] <= sample_shift_out_internal[i];
				end
			end
		end
	end


	always_ff @(posedge clk_i, negedge rst_ni) begin
		if (~rst_ni) begin
			hw2reg.fir_read_shift_out_samples.de <= 0;
			hw2reg.fir_read_shift_out_samples.d <= '0;
		end else begin
			if(valid_strobe_out_internal[NUM_FIR-1]) begin
				hw2reg.fir_read_shift_out_samples.de <= 1;
				hw2reg.fir_read_shift_out_samples.d <= sample_shift_out_internal[NUM_FIR-1];
			end else begin
				hw2reg.fir_read_shift_out_samples.de <= 0;
			end
		end
	end

	logic [DATA_SIZE_FIR_OUT+$clog2(NUM_FIR)-1:0] adder_tree_y_out;
	//logic [DATA_SIZE_FIR_OUT+$clog2(NUM_FIR)-1:0] adder_tree_y_out_prev;

	adder_tree #(
		.INPUTS_NUM(NUM_FIR),
		.IDATA_WIDTH(DATA_SIZE_FIR_OUT)
	) adder_tree_i (
		.clk(clk_i),
		.nrst(rst_ni),
		.idata(y_out_internal),
		.odata(adder_tree_y_out)
	);

	localparam int unsigned stageNum = $clog2(NUM_FIR);
	logic [31:0] stageCounter;
	logic waitAdder;

	always_ff @(posedge clk_i, negedge rst_ni) begin
		if (~rst_ni) begin
			y_out <= '0;
			valid_strobe_out <= '0;
			stageCounter <= stageNum;
			waitAdder <= '0;
		end else begin
			if(valid_strobe_out_internal[NUM_FIR-1]) begin
				waitAdder <= '1;
			end
			if(waitAdder) begin
				if(stageCounter == 0) begin
					y_out <= adder_tree_y_out[DATA_SIZE_FIR_OUT-1:0];
					valid_strobe_out <= '1;
					waitAdder <= '0;
					stageCounter <= stageNum;
				end else begin
					stageCounter <= stageCounter - 1;
				end
			end else begin 
				valid_strobe_out <= '0;
			end
		end
	end

	//assign valid_strobe_out = adder_tree_y_out != adder_tree_y_out_prev;
	//assign y_out = adder_tree_y_out;

	always_ff @(posedge clk_i, negedge rst_ni) begin
		if (~rst_ni) begin
			hw2reg.fir_read_y_out_upper.d = '0;
			hw2reg.fir_read_y_out_upper.de = 1'b0;
			hw2reg.fir_read_y_out_lower.d = '0;
			hw2reg.fir_read_y_out_lower.de = 1'b0;
		end else begin
			if(valid_strobe_out) begin
				hw2reg.fir_read_y_out_lower.d = adder_tree_y_out[DATA_SIZE_FIR_OUT-1:0];
				hw2reg.fir_read_y_out_lower.de = 1'b1;
			end else begin
				hw2reg.fir_read_y_out_upper.de = 1'b0;
				hw2reg.fir_read_y_out_lower.de = 1'b0;
			end
		end
	end

endmodule