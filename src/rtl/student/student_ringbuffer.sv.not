module student_ringbuffer (
    input logic clk_i,
    input logic rst_ni,

    input logic valid_strobe,
    input logic [15:0] delay,
    input logic [15:0] left_in,
    input logic [15:0] right_in,

    output logic [15:0] left_out,
    output logic [15:0] right_out
);

  // Define constants for memory definition
  //localparam ADDR_WIDTH = 4;
  localparam ADDR_WIDTH = 16;
  localparam MAX_ADDR = 2 ** ADDR_WIDTH;
  localparam ROM_FILE = "./zeros.mem";  // File for memory initialization

  // Signals for positive edge detection
  logic valid_strobe_delay;
  logic pos_edge;

  // Read and write pointers
  logic [ADDR_WIDTH-1:0] wr_addr;
  logic [ADDR_WIDTH-1:0] rd_addr;

  // Instantiate memory for left channel
  student_bram #(
      .AddrWidth(ADDR_WIDTH),
      .DataSize(16),
      .INIT_F(ROM_FILE)  // specify the path to the .mem file
  ) left_student_bram_i (
      .clk_i (clk_i),
      .wvalid(pos_edge),
      .wdata (left_in),
      .waddr (wr_addr),
      .rdata (left_out),
      .raddr (rd_addr)
  );

  // Instantiate memory for right channel
  student_bram #(
      .AddrWidth(ADDR_WIDTH),
      .DataSize(16),
      .INIT_F(ROM_FILE)  // specify the path to the .mem file
  ) right_student_bram_i (
      .clk_i (clk_i),
      .wvalid(pos_edge),
      .wdata (right_in),
      .waddr (wr_addr),
      .rdata (right_out),
      .raddr (rd_addr)
  );

  // Positive edge detection
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      valid_strobe_delay <= 1'b0;
    end else begin
      valid_strobe_delay <= valid_strobe;
    end
  end

  assign pos_edge = valid_strobe & ~valid_strobe_delay;

  // Write address generation
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      wr_addr <= MAX_ADDR - 1;
    end else begin
      // Count down on positive edge of valid_strobe
      if (pos_edge) begin
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

endmodule
