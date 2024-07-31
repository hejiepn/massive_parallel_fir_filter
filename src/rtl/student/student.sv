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


localparam int unsigned ADDR_WIDTH = 10;
localparam int unsigned DATA_SIZE = 16;
localparam int unsigned DATA_SIZE_FIR_OUT = 24;
localparam int unsigned DEBUGMODE = 0;
localparam int unsigned NUM_FIR = 8; //only numbers which are power of 2 are supported

logic [7:0] led;
logic mclk;
logic lrclk;
logic bclk;
logic dac_sdata;
logic sda_oe;
logic scl_oe;
//logic pmod_a_oe;
logic pmod_a_out;
//logic pmod_b_oe;
logic pmod_b_out;

  // ------ IIC -------
  logic sda_i;
  logic scl_i;
  assign sda_i = userio_i.sda;
  assign scl_i = userio_i.scl;

  assign userio_o = '{
          led: led,
          ac_mclk: mclk,
          ac_lrclk: lrclk,
          ac_bclk: bclk,
          ac_dac_sdata: dac_sdata,
          sda_oe: sda_oe,
          scl_oe: scl_oe,
          pmod_a_oe: {'0,5'b1},
          pmod_a_out: {'0,bclk,lrclk,dac_sdata,scl_i,sda_i},
          default: '0
      };

  assign irq_o = '0;
  assign tl_host_o = '{a_opcode: tlul_pkg::PutFullData, default: '0};
  assign tl_device_fast_o = '{d_opcode: tlul_pkg::AccessAck, default: '0};

// ------ TLUL MUX -------
  localparam TLUL_DEVICES = 4;
  //tl_student_i/o [index] is depended from the address you give to them in rvlab.h

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

  // ------ RLIGHT -------
  student_rlight rlight_i (
      .clk_i,
      .rst_ni,
      .tl_i(tl_student_i[0]),
      .tl_o(tl_student_o[0]),
      .led_o(led)
  );

  logic [DATA_SIZE-1:0] Data_iis_O;
  logic [DATA_SIZE-1:0] Data_iis_o_R;
  logic valid_strobe_2FIR;
  logic compute_finished_out;
  logic [DATA_SIZE-1:0] sample_shift_out;
  logic valid_strobe_out;
  logic [DATA_SIZE_FIR_OUT+$clog2(NUM_FIR)-1:0] y_out;
  //logic [DATA_SIZE_FIR_OUT-1:0] y_out;

  student_iis_handler_top #(
	.DATA_SIZE(DATA_SIZE),
	.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT)
  ) dut_student_iis (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
	.AC_MCLK(mclk),       // Codec Master Clock
	.AC_BCLK(bclk),       // Codec Bit Clock
    .AC_LRCLK(lrclk),      // Codec Left/Right Clock
    .AC_ADC_SDATA(userio_i.ac_adc_sdata),  // Codec ADC Serial Data
    .AC_DAC_SDATA(dac_sdata),  // Codec DAC Serial Data
	
	.Data_I_R(y_out), 	 //Data from HW to Codec (mono Channel)
  .Data_I_L('0),
	.Data_O_L(Data_iis_O),	 //Data from Codec to HW (mono Channel)
  .Data_O_R(Data_iis_o_R),
	.valid_strobe_I(valid_strobe_out), // Valid strobe from HW
	.valid_strobe(valid_strobe_2FIR),    // Valid strobe to HW
  .tl_i(tl_student_i[3]),  //master input (incoming request)
    .tl_o(tl_student_o[3])  //slave output (this module's response)

);

  student_iic_ctrl dut_student_iic(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
  .sda_i(sda_i),
  .scl_i(scl_i),
  .sda_oe(sda_oe),
  .scl_oe(scl_oe),
   .tl_i(tl_student_i[1]),  //master input (incoming request)
    .tl_o(tl_student_o[1])  //slave output (this module's response)
);

student_fir_parallel #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.DATA_SIZE(DATA_SIZE),
	.DEBUGMODE(DEBUGMODE),
	.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT),
	.NUM_FIR(NUM_FIR) //only numbers which are power of 2 are supported
) dut_fir_parallel(
	.clk_i(clk_i),
    .rst_ni(rst_ni),
	.valid_strobe_in(valid_strobe_2FIR),
    .sample_in(Data_iis_O),
	.valid_strobe_out(valid_strobe_out),
    .y_out(y_out),
	.tl_i(tl_student_i[2]),  //master input (incoming request)
	.tl_o(tl_student_o[2])  //slave output (this module's response)
);

endmodule