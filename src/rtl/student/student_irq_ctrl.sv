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

    logic [$clog2(N)-1:0] irq__no,  // current IRQ number
    logic [N-1:0] mask;
    logic [N-1:0] irq_masked;
    logic [N-1:0] irq_prio;
	logic [N-1:0] status;

    
    // Register for irq_no and status
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            irq_no <= 0;
            status <= 0;
        end else begin
            irq_no <= irq_prio[3:0];
            status <= |irq_prio;
        end
    end

    // Mask register logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mask <= 0;
        end else begin
            mask <= (mask | mask_set) & ~mask_clr;
        end
    end

    // IRQ masking logic
    assign irq_masked = irq & ~mask;

    // Priority encoder
    always_comb begin
        irq_prio = 0;
        for (int i = 0; i < N; i++) begin
            if (irq_masked[i]) begin
                irq_prio = i;
                break;
            end
        end
    end

endmodule
