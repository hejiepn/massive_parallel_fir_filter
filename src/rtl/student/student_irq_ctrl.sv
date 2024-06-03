module student_irq_ctrl #(
	parameter int N = 16
) (
    input logic clk_i,
    input logic rst_ni,

    input logic [N-1:0] irq_i,    	// irq inputs
	output logic irq_en_o, 			// IRQ enable output

	output tlul_pkg::tl_d2h_t tl_o,  //slave output (this module's response)
  	input  tlul_pkg::tl_h2d_t tl_i  //master input (incoming request)
);
    logic [N-1:0] irq_input;
	logic [N-1:0] mask;
    logic [$clog2(N+1)-1:0] irq_no;  // current IRQ number with one extra bit for 'N'
    logic [N-1:0] irq_masked;
	logic [N-1:0] status;
	logic found;
	logic all_en;

	import irq_ctrl_reg_pkg::*;

	irq_ctrl_reg2hw_t reg2hw; //write
	irq_ctrl_hw2reg_t hw2reg; //read

	irq_ctrl_reg_top irq_ctrl_reggen_module(
	.clk_i,
	.rst_ni,
	.tl_i,
	.tl_o,
	.reg2hw,
	.hw2reg,
	.devmode_i('0)
	);

    // Mask and irq_input register logic
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni) begin
			mask <= '0;
			irq_input <= '0;
        end else begin
			if(tl_i.a_valid) begin 
				$display("interrupt address has been called");
				mask <= reg2hw.mask_set.q & ~reg2hw.mask_clr.q;
				$display("mask is %b",mask);
				if (reg2hw.test.q == 1'b1) begin
					irq_input <= reg2hw.test_irq.q;
				end else begin
					irq_input <= irq_i;
				end
			end
        end
    end

	//status, mask and irq_masked register logic
	always_comb begin
		hw2reg.status.de = '1;
		hw2reg.status.d = irq_input;
		hw2reg.mask.de = '1;
		hw2reg.mask.d = mask;
    	//irq_masked = irq_input & reg2hw.mask.q;
		irq_masked = irq_input & mask;
		hw2reg.status.de = '0;
		hw2reg.mask.de = '0;
	end

	//prio logic 
	always_ff @(posedge clk_i, negedge rst_ni) begin
		if(~rst_ni) begin
			irq_no <= '0;
			found <= '0;
		end else begin
			if(tl_i.a_valid) begin
				for (int i = 0; i < N; i++) begin
            		if (irq_masked[i]) begin
						irq_no <= i;
						found <= '1;
						break;
            		end
        		end
				if (~found) begin
					irq_no <= N;
				end
			end
		end
	end

    // irq_no encoder setter
    always_comb begin
		hw2reg.irq_no.de = '1;
		hw2reg.irq_no.d = irq_no;
		hw2reg.irq_no.de = '0;
    end

	//all_en logic reader
	always_ff @(posedge clk_i, negedge rst_ni) begin
		if(~rst_ni) begin
			all_en <= '0;
		end else begin
			if(tl_i.a_valid) begin
				all_en <= reg2hw.all_en.q;
			end
		end
	end

	// IRQ enable logic
	assign irq_en_o = (|irq_masked) & all_en;

endmodule
