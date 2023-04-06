module student_rlight (
  input logic clk_i,
  input logic rst_ni,

  output tlul_pkg::tl_d2h_t tl_o,  //slave output (this module's response)
  input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)

  output logic [7:0] led_o
);


  logic [3:0] reg_addr;
  logic reg_we;
  logic reg_re;
  logic [31:0] reg_wdata;
  logic [31:0] reg_rdata;

  tlul_adapter_reg #(
    .RegAw(4),
    .RegDw(32)
  ) adapter_reg_i (
    .clk_i,
    .rst_ni,

    .tl_i,
    .tl_o,

    .we_o   (reg_we),
    .re_o   (reg_re),
    .addr_o (reg_addr),
    .wdata_o(reg_wdata),
    .be_o   (),
    .rdata_i(reg_rdata),
    .error_i('0)
  );

  localparam logic [3:0] ADDR_PATTERN = 4'h0;
  localparam logic [3:0] ADDR_MODE = 4'h4;
  localparam logic [3:0] ADDR_PRESCALER = 4'h8;
  localparam logic [3:0] ADDR_OUTPUT = 4'hC;

  localparam logic [1:0] MODE_OFF = 2'b00;
  localparam logic [1:0] MODE_ROTLEFT = 2'b01;
  localparam logic [1:0] MODE_ROTRIGHT = 2'b10;
  localparam logic [1:0] MODE_PINGPONG = 2'b11;

  // Bus writes
  // ----------

  logic [ 7:0] pattern;

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      pattern   <= 8'b11110000;
    end else begin
      if (reg_we) begin
        case (reg_addr)
          ADDR_PATTERN:   pattern <= reg_wdata[7:0];
          // Implement additional writes here.
          default: begin
          end
        endcase
      end
    end
  end

  // Bus reads
  // ---------

  always_comb begin
    case (reg_addr)
      ADDR_PATTERN:   reg_rdata = pattern;
      // Implement additional reads here.
      default:        reg_rdata = '0;
    endcase
  end

  // Running light logic
  // -------------------

  // ...

  assign led_o = pattern; // Just output pattern for now.

endmodule
