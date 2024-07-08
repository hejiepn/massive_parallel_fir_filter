module student_fir (
    input logic clk_i,
    input logic rst_ni,

    input logic valid_strobe_in,
    input logic [15:0] sample_in,

	input logic valid_strobe_coeff_in,
    input logic [15:0] coeff_in, 

    output logic [15:0] sample_shift_out,
    output logic [15:0] y_out

);

  // Define constants for memory definition
  localparam ADDR_WIDTH = 10;
  localparam MAX_ADDR = 2 ** ADDR_WIDTH;
  localparam ROM_FILE = "./data/zeros.mem";  // File for memory initialization

  // Read and write pointers
  logic [ADDR_WIDTH-1:0] wr_addr;
  logic [ADDR_WIDTH-1:0] rd_addr;
  logic [15:0] read_coeff_out;
  logic [15:0] read_sample_out;
  logic strobe_pos_edge;
  logic valid_strobe_delay;

  // Positive edge detection
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      valid_strobe_delay <= 1'b0;
    end else begin
      valid_strobe_delay <= valid_strobe_in;
    end
  end

  assign strobe_pos_edge = valid_strobe & ~valid_strobe_delay;

  // Write address generation
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      wr_addr <= MAX_ADDR - 1;
    end else begin
      // Count down on positive edge of valid_strobe
      if (strobe_pos_edge) begin
        if (wr_addr - 1 >= (MAX_ADDR - 1)) begin
          // Reset write address if underflow is reached
          wr_addr <= MAX_ADDR - 1;
        end else begin
          // Decrement write address
          wr_addr <= wr_addr - 1;
        end
      end
    end
  end

  // Read address calculation
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      rd_addr <= 16'h0;
    end else begin
      // Check if read address is within bounds
      if (wr_addr + delay > (MAX_ADDR - 1)) begin
        // Wrap around
        rd_addr <= (wr_addr + delay) - MAX_ADDR;
      end else begin
        rd_addr <= wr_addr + delay;
      end
    end
  end

  student_dpbram #(
      .AddrWidth(ADDR_WIDTH),
      .DataSize(16),
      .INIT_F(ROM_FILE)  // specify the path to the .mem file
  ) sample_dpram (
      .clk_i (clk_i),
      .wvalid(strobe_pos_edge),
      .wdata (sample_in),
      .waddr (wr_addr),
      .rdata (read_sample_out),
      .raddr (rd_addr)
  );

 student_dpbram #(
      .AddrWidth(ADDR_WIDTH),
      .DataSize(16),
      .INIT_F(ROM_FILE)  // specify the path to the .mem file
 ) coeff_dpram (
      .clk_i (clk_i),
      .wvalid(valid_strobe_coeff_in),
      .wdata (coeff_in),
      .waddr (wr_addr),
      .rdata (read_coeff_out),
      .raddr (rd_addr)
  );

 enum logic[1:0] {idle, shift_in, compute, shift_out} fir_state; 

 always_ff @(posedge clk_i, negedge rst_ni) begin
	if (~rst_ni) begin
      fir_state <= idle;
	end else begin
		if (strobe_pos_edge) begin
			fir_state <= shift_in;
		end
		if (fir_state == shift_in) begin
			fir_state <= compute;
		end;
		if (compute_finshed) begin
			fir_state <= shift_out;
		end
		if( fir_state == shift_out) begin
			fir_state <= idle;
		end
	end
 end

  // FIR computation
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      data_out <= 16'h0;
      fir_sum <= 16'h0;
      coef_addr <= 3'h0;
    end else if (valid_strobe) begin
		case (fir_state)
			idel: begin

			end
			shift_in: begin


			end 
			compute: begin
				fir_sum <= 16'h0;
				for (int i = 0; i < 5; i++) begin
					coef_addr <= i[2:0];
					fir_sum <= fir_sum + delay_line_out[i] * coefficient;
				end
				 data_out <= fir_sum;

			end 
			shift_out: begin

			end
			default: begin
			end // default
		endcase
    end
  end

endmodule
