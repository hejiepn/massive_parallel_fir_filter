module fir_ringbuffer (
    input logic clk_i,
    input logic rst_ni,
    input logic valid_strobe,
    input logic [15:0] data_in,
    output logic [15:0] data_out [4:0]  // 输出5个延迟值
);

  // Define constants for memory definition
  localparam ADDR_WIDTH = 3;  // 5阶FIR滤波器，只需3位地址
  localparam MAX_ADDR = 2 ** ADDR_WIDTH;

  // Signals for positive edge detection
  logic valid_strobe_delay;
  logic pos_edge;

  // Write pointer
  logic [ADDR_WIDTH-1:0] wr_addr;

  // Define initial values for memory (all zeros as an example)
//   localparam logic [15:0] INIT_VALUES [0:MAX_ADDR-1] = '{default: 16'h0000};

  // Instantiate memory for the delay line
  dp_bram #(
      .AddrWidth(ADDR_WIDTH),
      .DataSize(16)
  ) data_bram (
      .clk_i (clk_i),
      .wvalid(pos_edge),
      .wdata (data_in),
      .waddr (wr_addr),
      .rdata (data_out[0]),  // 最新数据输出
      .raddr (wr_addr)
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
      wr_addr <= 0;
    end else begin
      if (pos_edge) begin
        wr_addr <= (wr_addr + 1) % MAX_ADDR;
      end
    end
  end

  // Generate delayed outputs
  generate
    genvar i;
    for (i = 1; i < 5; i++) begin
      always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni) begin
          data_out[i] <= 16'h0;
        end else if (pos_edge) begin
          data_out[i] <= data_out[i-1];
        end
      end
    end
  endgenerate

endmodule
