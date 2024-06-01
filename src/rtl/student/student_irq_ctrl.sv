module irq_controller #(
	parameter int N = 16
) (
    input logic clk_i,
    input logic rst_ni,

    input logic [N-1:0] irq_i,    					// irq inputs
	output logic irq_en_o 						// IRQ enable output

	output tlul_pkg::tl_d2h_t tl_o,  //slave output (this module's response)
  	input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)
);

    //logic [N-1:0] mask;
	//logic [N-1:0] former_status;
    logic [$clog2(N)-1:0] irq__no,  // current IRQ number
    logic [N-1:0] irq_masked;
    logic [N-1:0] irq_prio;


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
	devmode_i('0)
	);

    // Mask and status register logic
    always_ff @(posedge clk, negedge reset) begin
        if (~reset) begin
            hw2reg.mask.d <= '0;
			hw2reg.status.d <= '0;
        end else begin
			hw2reg.mask.d <= (reg2hw.mask.q | reg2hw.mask_set.q) & ~reg2hw.mask_clr.q;
			hw2reg.status.d <= irq_i;
        end
    end

    // IRQ masking logic assign is a combinatorial logic statement
    assign irq_masked = irq_i & reg2hw.mask.q;

    // Priority encoder
    always_comb begin
        for (int i = 0; i < N; i++) begin
            if (irq_masked[i]) begin
                hw2reg.irq_no.d = i;
                break;
            end
        end
    end

endmodule
