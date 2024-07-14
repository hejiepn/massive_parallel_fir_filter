module student_fir #(
	parameter int unsigned ADDR_WIDTH = 10,
	parameter int unsigned DATA_SIZE = 16,
	parameter int unsigned DEBUGMODE = 0
	) (	
    input logic clk_i,
    input logic rst_ni,

    input logic valid_strobe_in,
    input logic [DATA_SIZE-1:0] sample_in,

    output logic compute_finished_out,
    output logic [DATA_SIZE-1:0] sample_shift_out,
	output logic valid_strobe_out,
    output logic [DATA_SIZE*2-1:0] y_out
);

  // Define constants for memory definition
  localparam MAX_ADDR = 2 ** ADDR_WIDTH;
  localparam ROM_FILE_COEFF = (DEBUGMODE == 1) ? "/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/rtl/student/data/coe_lp_debug.mem" : "/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/rtl/student/data/coe_lp.mem";  // File for memory initialization
  localparam ROM_FILE_SAMPLES = "/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/rtl/student/data/sin_high.mem";
 
  // Read and write pointers
  logic [ADDR_WIDTH-1:0] wr_addr;
  logic [ADDR_WIDTH-1:0] rd_addr;
  logic [ADDR_WIDTH-1:0] wr_addr_c;
  logic [ADDR_WIDTH-1:0] rd_addr_c;
  logic [DATA_SIZE-1:0] read_coeff;
  logic [DATA_SIZE-1:0] read_sample;
  logic ena_samples;
  logic enb_samples;
  logic ena_coeff;
  logic enb_coeff;
  logic wra_coeff;
  logic [DATA_SIZE-1:0] write_coeff;
  logic [DATA_SIZE*2-1:0] fir_sum;
  //logic [31:0] ptr_counter;
      

  // FIR State Machine
  typedef enum logic[2:0] {IDLE, SHIFT_IN, DELAY, COMPUTE, SHIFT_OUT} fir_state_t;
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
  assign ena_samples = valid_strobe_in_pos_edge;

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
	  rd_addr_c <= '0;
    end else begin
		if (rd_addr == wr_addr && rd_addr_c != 0 && fir_state == COMPUTE) begin
			rd_addr_c <= rd_addr_c + 1;
		end else if (rd_addr != wr_addr) begin
			rd_addr <= rd_addr - 1;
			rd_addr_c <= rd_addr_c + 1;
    	end
	end
  end

  // Dual Port RAM instances for samples and coefficients
  student_dpram_samples #(
    .AddrWidth(ADDR_WIDTH),
    .DataSize(DATA_SIZE),
	.DebugMode(DEBUGMODE),
    .INIT_F(ROM_FILE_SAMPLES) 
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
    .DataSize(DATA_SIZE),
	.DebugMode(DEBUGMODE),
    .INIT_F(ROM_FILE_COEFF) 
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
      enb_samples <= 0;
      ena_coeff <= 0;
      enb_coeff <= 0;
      wra_coeff <= 0;
    end else begin
		if (ena_samples) begin
        	enb_samples <= 1;
        	enb_coeff <= 1;
      	end else if (fir_state == SHIFT_OUT) begin
        	enb_samples <= 0;
        	enb_coeff <= 0;
      	end
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
			if (rd_addr == wr_addr && rd_addr_c == 0) begin
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
      fir_sum <= '0;
      compute_finished_out <= 0;
	  valid_strobe_out <= 0;
    end else begin
		case (fir_state)
			IDLE: begin
				compute_finished_out <= 0;
				valid_strobe_out <= 0;
				fir_sum <= '0;
				// $display("fir_state: IDLE");
				// $display("wr_addr: %4x rd_addr: %4x rd_addr_c: %4x", wr_addr, rd_addr, rd_addr_c);
				// $display("enb_samples: %1x enb_coeff: %1x", enb_samples, enb_coeff);
				// $display("fir_sum: %d read_sample: %4x read_coeff: %4x", fir_sum, read_sample, read_coeff);
			end
			SHIFT_IN: begin
				// No specific action needed
				// $display("fir_state: SHIFT_IN");
				// $display("wr_addr: %4x rd_addr: %4x rd_addr_c: %4x", wr_addr, rd_addr, rd_addr_c);
				// $display("enb_samples: %1x enb_coeff: %1x", enb_samples, enb_coeff);
				// $display("fir_sum: %d read_sample: %4x read_coeff: %4x", fir_sum, read_sample, read_coeff);

			end
			COMPUTE: begin
				// $display("fir_state: Compute");
				// $display("wr_addr: %4x rd_addr: %4x rd_addr_c: %4x", wr_addr, rd_addr, rd_addr_c);
				// $display("enb_samples: %1x enb_coeff: %1x", enb_samples, enb_coeff);
				// $display("fir_sum: %d read_sample: %4x read_coeff: %4x", fir_sum, read_sample, read_coeff);
				fir_sum <= fir_sum + read_sample * read_coeff;
				if( rd_addr == wr_addr) begin
					sample_shift_out <= read_sample;
				end
			end
			SHIFT_OUT: begin
				// $display("fir_state: Shift Out");
				// $display("wr_addr: %4x rd_addr: %4x rd_addr_c: %4x", wr_addr, rd_addr, rd_addr_c);
				// $display("enb_samples: %1x enb_coeff: %1x", enb_samples, enb_coeff);
				// $display("fir_sum: %d read_sample: %4x read_coeff: %4x", fir_sum, read_sample, read_coeff);
				compute_finished_out <= 1;
				valid_strobe_out <= 1;
			end
		endcase
	end
end

assign y_out = fir_sum;

endmodule