module student (
  input logic clk_i,
  input logic rst_ni,

  input  top_pkg::userio_board2fpga_t userio_i,
  output top_pkg::userio_fpga2board_t userio_o,

  output logic irq_o,

  input  tlul_pkg::tl_h2d_t tl_device_peri_i,
  output tlul_pkg::tl_d2h_t tl_device_peri_o,
  input  tlul_pkg::tl_h2d_t tl_device_fast_i,
  output tlul_pkg::tl_d2h_t tl_device_fast_o,

  input  tlul_pkg::tl_d2h_t tl_host_i,
  output tlul_pkg::tl_h2d_t tl_host_o
);

  logic [7:0] led;
  assign userio_o = '{
    led: led,
    default: '0
  };

  assign irq_o         = '0;
  assign tl_host_o   = '{a_opcode: tlul_pkg::PutFullData, default: '0};
  assign tl_device_fast_o = '{d_opcode: tlul_pkg::AccessAck, default: '0};

  student_rlight rlight_i (
    .clk_i,
    .rst_ni,
    .tl_o (tl_device_peri_o),
    .tl_i (tl_device_peri_i),
    .led_o(led)
  );

endmodule
