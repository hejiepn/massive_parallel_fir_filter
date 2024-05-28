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

  localparam integer mux_num = 2;

  tlul_pkg::tl_h2d_t device_select_o [mux_num-1:0];
  tlul_pkg::tl_d2h_t device_select_i [mux_num-1:0] ;

     student_tlul_mux #(
    .NUM(mux_num)
    ) tlul_mux_i (
    .clk_i,
    .rst_ni,
    .tl_host_o(tl_device_peri_o),
    .tl_host_i(tl_device_peri_i),
    .tl_device_o(device_select_i),
    .tl_device_i(device_select_o)
  );

  student_rlight rlight_i (
    .clk_i,
    .rst_ni,
    .tl_o (device_select_i[0]),
    .tl_i (device_select_o[0]),
    .led_o(led)
  );
    student_dma dma_i (
    .clk_i,
    .rst_ni,
    .tl_o (tl_device_fast_o),
    .tl_i (tl_device_fast_i),
    .tl_host_o,
    .tl_host_i
  );
 

endmodule
