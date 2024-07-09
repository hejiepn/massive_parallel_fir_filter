module student_fir (
    input logic clk_i,
    input logic rst_ni,

    input logic valid_strobe_in,
    input logic [15:0] sample_in,

    output logic compute_finished,
    output logic [15:0] sample_shift_out,
	output logic valid_strobe_out,
    output logic [31:0] y_out
);

  // Define constants for memory definition
  localparam ADDR_WIDTH = 10;
  localparam MAX_ADDR = 2 ** ADDR_WIDTH;
  localparam ROM_FILE = "./data/zeros.mem";  // File for memory initialization

  // Read and write pointers
  logic [ADDR_WIDTH-1:0] wr_addr;
  logic [ADDR_WIDTH-1:0] rd_addr;
  logic [ADDR_WIDTH-1:0] wr_addr_c;
  logic [ADDR_WIDTH-1:0] rd_addr_c;
  logic [15:0] read_coeff;
  logic [15:0] read_sample;
  logic ena_samples;
  logic enb_samples;
  logic ena_coeff;
  logic enb_coeff;
  logic wra_coeff;
  logic [15:0] write_coeff;
  logic [31:0] fir_sum;

  // FIR State Machine
  typedef enum logic[1:0] {IDLE, SHIFT_IN, COMPUTE, SHIFT_OUT} fir_state_t;
  fir_state_t fir_state;

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

  assign valid_strobe_in_pos_edge = valid_strobe_in && ~valid_strobe_in_prev;

  // Write address generation
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      wr_addr <= '0;
    end else begin
      if (valid_strobe_in_pos_edge) begin
        wr_addr <= wr_addr + 1;
      end
    end
  end

  // Read address generation
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      rd_addr <= '0;
	  rd_addr_c <= '1;
    end else begin
      if (fir_state == SHIFT_IN) begin
        rd_addr <= wr_addr + 1;
		rd_addr_c <= '1;
      end else if (fir_state == COMPUTE) begin
        rd_addr <= rd_addr + 1;
		rd_addr_c <= rd_addr_c - 1;
      end
    end
  end

  // Dual Port RAM instances for samples and coefficients
  student_dpram_samples #(
    .AddrWidth(ADDR_WIDTH),
    .DataSize(16),
    .INIT_F(ROM_FILE) 
  ) samples_dpram (
    .clk_i(clk_i),
    .ena(ena_samples),
    .enb(enb_samples),
    .wea(valid_strobe_in_pos_edge),
    .addra(wr_addr),
    .addrb(rd_addr),
    .dia(sample_in),
    .dob(read_sample)
  );

  student_dpram_samples #(
    .AddrWidth(ADDR_WIDTH),
    .DataSize(16),
    .INIT_F(ROM_FILE) 
  ) coeff_dpram (
    .clk_i(clk_i),
    .ena(ena_coeff),
    .enb(enb_coeff),
    .wea(wra_coeff),
    .addra(wr_addr_c),
    .addrb(rd_addr_c),
    .dia(write_coeff),
    .dob(read_coeff)
  );

  // Enable signals control
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if(~rst_ni) begin
      ena_samples <= 0;
      enb_samples <= 0;
      ena_coeff <= 0;
      enb_coeff <= 0;
      wra_coeff <= 0;
    end else begin
      ena_samples <= (fir_state == SHIFT_IN); // Enable samples RAM during SHIFT_IN state
      enb_samples <= (fir_state == COMPUTE);  // Enable samples RAM for reading during COMPUTE state
      enb_coeff <= (fir_state == COMPUTE);    // Enable coefficients RAM for reading during COMPUTE state
    end
  end

  // FIR State Machine
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      fir_state <= IDLE;
    end else begin
      case (fir_state)
        IDLE: begin
          if (valid_strobe_in_pos_edge) begin
            fir_state <= SHIFT_IN;
          end
        end
        SHIFT_IN: begin
          fir_state <= COMPUTE;
        end
        COMPUTE: begin
          if (rd_addr == wr_addr) begin
            fir_state <= SHIFT_OUT;
          end
        end
        SHIFT_OUT: begin
          fir_state <= IDLE;
        end
        default: begin
          fir_state <= IDLE;
        end
      endcase
    end
  end

  // FIR computation
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      y_out <= 32'h0;
      fir_sum <= 32'h0;
      compute_finished <= 0;
	  valid_strobe_out <= 0;
    end else begin
      case (fir_state)
        IDLE: begin
          fir_sum <= 32'h0;
        end
        SHIFT_IN: begin
          // No specific action needed
        end
        COMPUTE: begin
          fir_sum <= fir_sum + read_sample * read_coeff;
          if (rd_addr == wr_addr) begin
            y_out <= fir_sum;
            compute_finished <= 1;
		  end else if( rd_addr == wr_addr - 1) begin
			sample_shift_out <= read_sample;
			valid_strobe_out <= 1;
		  end
        end
        SHIFT_OUT: begin
			compute_finished <= 0;
	  		valid_strobe_out <= 0;
        end
      endcase
    end
  end

endmodule
