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

  // ------ IIC -------
	logic sda_i;
	logic scl_i;
	logic adc_i;
	logic mclk;
	logic lrclk;
	logic bclk;
	logic dac_sdata;
	logic sda_oe;
	logic scl_oe;

  assign sda_i = userio_i.sda;
  assign scl_i = userio_i.scl;
  assign adc_i = userio_i.ac_adc_sdata;

  logic [7:0] led;
  assign userio_o = '{
		led: led,
		ac_mclk: mclk,
		ac_lrclk: lrclk,
		ac_bclk: bclk,
		ac_dac_sdata: dac_sdata,
		sda_oe: sda_oe,
		scl_oe: scl_oe,
		pmod_b_oe: 8'b00111111,
		pmod_b_out: {'0,adc_i,adc_i,scl_i,scl_i,sda_i,sda_i},
		pmod_a_oe: 8'b00111111,
		pmod_a_out: {'0,lrclk,lrclk,bclk,bclk,dac_sdata,dac_sdata},
		default: '0
		};

  assign irq_o         = '0;

  // ------ TLUL MUX -------
  localparam TLUL_DEVICES = 2;

  tlul_pkg::tl_h2d_t tl_student_i[TLUL_DEVICES-1:0];
  tlul_pkg::tl_d2h_t tl_student_o[TLUL_DEVICES-1:0];

  student_tlul_mux #(
	.NUM(TLUL_DEVICES),
	.ADDR_WIDTH(4),
	.ADDR_OFFSET(20)
  ) tlul_mux_i (
      .clk_i,
      .rst_ni,

      .tl_host_i(tl_device_peri_i),
      .tl_host_o(tl_device_peri_o),

      .tl_device_o(tl_student_o),
      .tl_device_i(tl_student_i)
  );

  student_rlight rlight_i (
    .clk_i,
    .rst_ni,
    .tl_o (tl_student_o[0]),
    .tl_i (tl_student_i[0]),
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

	student_iic_ctrl dut_student_iic(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
  	.sda_i(sda_i),
  	.scl_i(scl_i),
  	.sda_oe(sda_oe),
  	.scl_oe(scl_oe),
	.tl_o(tl_student_o[1]),
   	.tl_i(tl_student_i[1])
);

endmodule
