`timescale 1ns/1ps

module fir_filter (
  input logic clk_i,           // Clock input
  input logic rst_ni,          // Asynchronous reset, active low
  input logic [9:0] coef_len,  // Length of FIR filter coefficients
  input logic [15:0] coef_data, // FIR coefficient data input
  input logic [15:0] audio_data, // Audio data input
  input logic coef_wr,         // Coefficient write enable
  input logic audio_wr,        // Audio data write enable
  output logic [31:0] audio_out, // Filtered audio data output (wider bit-width for accumulation)
  output logic valid_out       // Output valid signal
);

  // Internal parameters and signals
  localparam AddrWidth = 10;  // Address width: 10 bits (32 KB of memory)
  logic [9:0] coef_wr_ptr;    // Coefficient write pointer
  logic [9:0] audio_wr_ptr;   // Audio write pointer
  logic [9:0] coef_rd_ptr;    // Coefficient read pointer
  logic [9:0] audio_rd_ptr;   // Audio read pointer
  logic [31:0] coef_mem_rdata; // Coefficient memory read data
  logic [31:0] audio_mem_rdata; // Audio memory read data
  logic [31:0] sum;           // Accumulated sum for FIR computation
  logic [9:0] count;          // Counter for FIR computation

  // State machine states
  typedef enum logic [1:0] {
    IDLE,
    COMPUTE,
    OUTPUT
  } state_t;
  
  state_t state, next_state;

  // Instantiate coefficient memory (dpram_main)
  dpram_main coef_mem (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .req_a(coef_wr),
    .we_a(coef_wr),
    .addr_a(coef_wr_ptr),
    .wdata_a({16'b0, coef_data}),  // Write coefficient data
    .wmask_a(32'h0000FFFF),       // Write mask
    .req_b(state == COMPUTE),
    .addr_b(coef_rd_ptr),
    .rdata_b(coef_mem_rdata)
  );

  // Instantiate intermediate result memory (dpram_main)
  dpram_main audio_mem (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .req_a(audio_wr),
    .we_a(audio_wr),
    .addr_a(audio_wr_ptr),
    .wdata_a({16'b0, audio_data}), // Write audio data
    .wmask_a(32'h0000FFFF),       // Write mask
    .req_b(state == COMPUTE),
    .addr_b(audio_rd_ptr),
    .rdata_b(audio_mem_rdata)
  );

  // FIR filter FSM
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)
      state <= IDLE;
    else
      state <= next_state;
  end

  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (audio_wr)
          next_state = COMPUTE;
      end
      COMPUTE: begin
        if (count == coef_len)
          next_state = OUTPUT;
      end
      OUTPUT: begin
        next_state = IDLE;
      end
    endcase
  end

  // Coefficient and audio write pointer control
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      coef_wr_ptr <= 0;
      audio_wr_ptr <= 0;
    end else begin
      if (coef_wr) begin
        coef_wr_ptr <= (coef_wr_ptr == coef_len - 1) ? 0 : coef_wr_ptr + 1;
      end
      if (audio_wr) begin
        audio_wr_ptr <= (audio_wr_ptr == (1 << AddrWidth) - 1) ? 0 : audio_wr_ptr + 1;
      end
    end
  end

  // Coefficient and audio read pointer control and computation
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      coef_rd_ptr <= 0;
      audio_rd_ptr <= 0;
      count <= 1;
      sum <= 0;
      valid_out <= 0;
      audio_out <= 0;
    end else begin
      case (state)
        IDLE: begin
          coef_rd_ptr <= 0;
          audio_rd_ptr <= audio_wr_ptr;  // Start reading from the latest audio data
          count <= 1;
          sum <= 0;
          valid_out <= 0;
          audio_out <= 0;
        end
        COMPUTE: begin
          sum <= sum + (coef_mem_rdata[15:0] * audio_mem_rdata[15:0]);
          coef_rd_ptr <= (coef_rd_ptr == coef_len - 1) ? 0 : coef_rd_ptr + 1;
          audio_rd_ptr <= (audio_rd_ptr == (1 << AddrWidth) - 1) ? 0 : audio_rd_ptr + 1;
          count <= count + 1;
        end
        OUTPUT: begin
          audio_out <= sum; // Output the accumulated result
          valid_out <= 1;
          sum <= 0;
        end
      endcase
    end
  end

endmodule

// 0.5s calculation time
// 44kh/48k
// 