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
  localparam TLUL_DEVICES = 4;

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
  
  logic valid_strobe_2FIR;
  logic [DATA_SIZE-1:0] Data_iis_O_L;
  logic [DATA_SIZE-1:0] Data_iis_O_R;
  logic valid_strobe_out;
  logic signed [DATA_SIZE_FIR_OUT-1:0] y_out_l;
  logic signed [DATA_SIZE_FIR_OUT-1:0] y_out_r;
  logic [DATA_SIZE-1:0] sample_shift_out;

    logic [15:0] sine_input;


	student_fir_parallel #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.DATA_SIZE(DATA_SIZE),
	.DEBUGMODE(DEBUGMODE),
	.DATA_SIZE_FIR_OUT(DATA_SIZE_FIR_OUT),
	.NUM_FIR(NUM_FIR) 
	) dut_fir_parallel_left(
	.clk_i(clk_i),
    .rst_ni(rst_ni),
	.valid_strobe_in(valid_strobe_2FIR),
    .sample_in(Data_iis_O_L),
	.valid_strobe_out(valid_strobe_out),
    .y_out(y_out_l),
	.tl_i(tl_student_i[2]),  //master input (incoming request)
	.tl_o(tl_student_o[2])  //slave output (this module's response)
);

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
    //.AC_ADC_SDATA('1),  // Codec ADC Serial Data
    .AC_DAC_SDATA(dac_sdata),  // Codec DAC Serial Data
	
  	.Data_I_R('0), 	 	//Data from HW to Codec (mono Channel)
    .Data_I_L(y_out_l),
  	.Data_O_L(Data_iis_O_L),	 //Data from Codec to HW (mono Channel)
    .Data_O_R(Data_iis_O_R),
  	.valid_strobe_I(valid_strobe_out), // Valid strobe from HW
  	.valid_strobe(valid_strobe_2FIR),    // Valid strobe to HW
    .tl_i(tl_student_i[3]),  //master input (incoming request)
    .tl_o(tl_student_o[3])  //slave output (this module's response)
);
	

   sine_wave_output sine_wave_ins (
   .clk(clk_i),
   .rst_ni(rst_ni),
   .lrclk(lrclk),
   .sine_wave_out(sine_input)
);

    /*

student_iis_handler iss_handler(
     .clk_i(clk_i),
     .rst_ni(rst_ni),

     .AC_MCLK(mclk),       // Codec Master Clock
     .AC_BCLK(bclk),       // Codec Bit Clock
     .AC_LRCLK(lrclk),      // Codec Left/Right Clock
     //.AC_ADC_SDATA(userio_i.ac_adc_sdata),  // Codec ADC Serial Data
     .AC_ADC_SDATA('1),  // Codec ADC Serial Data
     .AC_DAC_SDATA(dac_sdata),  // Codec DAC Serial Data

     .Data_I_L(y_out_l),     // Data from HW to Codec (Left Channel)
     .Data_I_R('0),     // Data from HW to Codec (Right Channel)
     .Data_O_L(Data_iis_O_L),     // Data from Codec to HW (Left Channel)
     .Data_O_R(Data_iis_O_R),     // Data from Codec to HW (Right Channel)
     .valid_strobe(valid_strobe_2FIR),  // Valid strobe to HW
	.tl_i(tl_student_i[3]),  //master input (incoming request)
    .tl_o(tl_student_o[3])  //slave output (this module's response)
 );


*/
 

endmodule
