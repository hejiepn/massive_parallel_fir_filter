module student_audio_init (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic sda_i,
    input  logic scl_i,
    output logic sda_oe,
    output logic scl_oe,

    input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)
    output tlul_pkg::tl_d2h_t tl_o   //slave output (this module's response)
);

  import student_audio_init_reg_pkg::*;

  student_audio_init_reg2hw_t reg2hw;
  student_audio_init_hw2reg_t hw2reg;

  student_audio_init_reg_top student_audio_init_reg_top (
      .clk_i,
      .rst_ni,

      .tl_i,
      .tl_o,

      .reg2hw,
      .hw2reg,

      .devmode_i(1'b1)
  );

  enum logic [2:0] {
    stRegAddr1,
    stRegAddr2,
    stData,
    stDone,
    stError,
    stDelay,
    stIdle
  } state;

  logic [23:0] initWord;
  logic [4:0] initA;
  logic delayEn;
  logic [31:0] delayCnt;
  logic stb;
  logic [7:0] data_i;
  logic done;
  logic error;

  // I2C address of the ADAU1761
  localparam [7:0] iicAddr = 8'b01110110;

  // 29 control registers to initialize
  localparam INIT_VECTORS = 29;

  localparam delay = 1000 * 24;

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      delayCnt <= '0;
    end else begin
      if (delayEn == 1) begin
        delayCnt <= delayCnt - 1;
      end else delayCnt <= delay;
    end
  end

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      initWord <= 24'h000000;
    end else begin
      case (initA)
        0: initWord <= 24'h400003;  //Clock Control
        1: initWord <= 24'h401500;  //Serial Port Control 0
        2: initWord <= 24'h401600;  //Serial Port Control 1
        3: initWord <= 24'h401700;  //Converter Control
        4: initWord <= 24'h40F800;  //Serial Port Sample Rate
        5: initWord <= 24'h401913;  //ADC Control | both ADCs on
        6: initWord <= 24'h402A03;  //DAC Control | both DACs on
        7: initWord <= 24'h402903;  //Playback Power Management | both Playbacks on
        8: initWord <= 24'h40F201;  //Serial Input Route Control | Serial Input [L0,RO] to DACs
        9: initWord <= 24'h40F97F;  //Clock Enable 0
        10: initWord <= 24'h40FA03;  //Clock Enable 1
        11: initWord <= 24'h402003;  //Playback L/R Mixer Left (Mixer 5) Line Output Control
        12: initWord <= 24'h402200;  //Playback L/R Mixer Mono Output (Mixer 7) Control
        13: initWord <= 24'h402109;  //Playback L/R Mixer Right (Mixer 6) Line Output Control
        14: initWord <= 24'h4025E6;  //Playback Line Output Left Volume Control | 0dB
        15: initWord <= 24'h4026E6;  //Playback Line Output Right Volume Control | 0dB
        16: initWord <= 24'h402700;  //Playback Mono Output Control
        17: initWord <= 24'h4023E6;  //Playback Headphone Left Volume Control
        18: initWord <= 24'h4024E6;  //Playback Headphone Right Volume Control
        19: initWord <= 24'h400A01;  //Record Mixer Left (Mixer 1) Control 0
        20: initWord <= 24'h400B05;  //Record Mixer Left (Mixer 1) Control 1
        21: initWord <= 24'h400C01;  //Record Mixer Right (Mixer 2) Control 0
        22: initWord <= 24'h400D05;  //Record Mixer Right (Mixer 2) Control 1
        23: initWord <= 24'h401C21;  //Playback Mixer Left (Mixer 3) Control 0
        24: initWord <= 24'h401D00;  //Playback Mixer Left (Mixer 3) Control 1
        25: initWord <= 24'h401E41;  //Playback Mixer Right (Mixer 4) Control 0
        26: initWord <= 24'h401F00;  //Playback Mixer Right (Mixer 4) Control 1
        27: initWord <= 24'h40F301;  //Serial Output Route Control | ADCs to Serial Output [L0,RO]
        28: initWord <= 24'h40F400;  //Serial Data/GPIO Pin Configuration
        default: initWord <= 24'h000000;
      endcase
    end
  end

  // I2C master module to write conform data
  student_iic_master iic_master (
      .clk_i(clk_i),
      .rst_ni(rst_ni),
      .stb_i(stb),
      .a_i(iicAddr),
      .d_i(data_i),
      .done_o(done),
      .err_o(error),
      .sda_i,
      .scl_i,
      .sda_oe,
      .scl_oe
  );

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      stb <= 0;
      data_i <= 8'b00000000;
      state <= stIdle;
      initA <= 4'h0;
      delayEn <= 0;
      hw2reg.audio_init_done.d <= 1'b0;
      hw2reg.audio_init_done.de <= 1'b0;
    end else begin
      stb <= 0;
      case (state)
        stIdle: begin
          if (reg2hw.start_audio_init.q == 1) begin
            state <= stRegAddr1;
          end
        end
        stRegAddr1: begin
          if (done == 1) begin
            if (error == 1) state <= stError;
            else state <= stRegAddr2;
          end
          data_i <= initWord[23:16];
          stb <= 1;
        end
        stRegAddr2: begin
          if (done == 1) begin
            if (error == 1) state <= stError;
            else state <= stData;
          end
          data_i <= initWord[15:8];
          stb <= 1;
        end
        stData: begin
          if (done == 1) begin
            if (error == 1) state <= stError;
            else begin
              if (initA == INIT_VECTORS - 1) state <= stDone;
              else state <= stDelay;
            end
          end
          data_i <= initWord[7:0];
          stb <= 1;
        end
        stError: begin
          state <= stRegAddr1;
        end
        stDone: begin
          hw2reg.audio_init_done.d  <= 1'b1;
          hw2reg.audio_init_done.de <= 1'b1;
        end
        stDelay: begin
          delayEn <= 1;
          if (delayCnt == 0) begin
            delayEn <= 0;
            initA   <= initA + 1;
            state   <= stRegAddr1;
          end
        end
        default: begin
          state <= stIdle;
        end
      endcase
    end
  end


endmodule
