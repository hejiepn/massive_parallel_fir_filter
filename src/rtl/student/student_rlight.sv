module student_rlight (
    input logic clk_i,
    input logic rst_ni,

    input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)
    output tlul_pkg::tl_d2h_t tl_o,  //slave output (this module's response)

    output logic [7:0] led_o
);

  import student_rlight_reg_pkg::*;

  student_rlight_reg2hw_t reg2hw;
  student_rlight_hw2reg_t hw2reg;

  student_rlight_reg_top student_rlight_reg_top (
      .clk_i,
      .rst_ni,

      .tl_i,
      .tl_o,

      .reg2hw,
      .hw2reg,

      .devmode_i(1'b1)
  );

  enum logic [1:0] {
    pp_left,
    pp_right
  } pp_dir;
  logic [7:0] led;
  logic [1:0] old_state;
  logic [3:0] pp_posMSB;  // Current position of MSB of initial pattern
  logic [21:0] led_r;  // Placeholder register for shifted led pattern
  logic cnt_rdy;

  // FSM: Modes und setzen des Ausgangsregister
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      pp_dir <= pp_right;
      pp_posMSB <= 4'h7;
      led <= 8'b00011000;
      led_r <= 22'b0000000000000000000000;
      old_state <= 2'b00;
      hw2reg.led_status.de <= 1'b1;
      hw2reg.led_status.d <= '0;
    end else begin
      if (cnt_rdy) begin
        case (reg2hw.modes.q)
          //Rotate right
          2'b01: begin
            led[0] <= led[7];
            for (int i = 0; i < 7; i++) led[i+1] <= led[i];
          end
          //Rotate left
          2'b10: begin
            for (int i = 0; i < 7; i++) led[i] <= led[i+1];
            led[7] <= led[0];
          end
          2'b11: begin
            // Check which direction ping pong should move
            if (pp_dir == pp_right) begin
              if (pp_posMSB == 4'hF) begin
                pp_dir <= pp_left;
                led_r <= led_r << 1;
                pp_posMSB <= pp_posMSB - 1;
              end else begin
                led_r <= led_r >> 1;
                pp_posMSB <= pp_posMSB + 1;
              end
            end else if (pp_dir == pp_left) begin
              if (pp_posMSB == 4'h0) begin
                pp_dir <= pp_right;
                led_r <= led_r >> 1;
                pp_posMSB <= pp_posMSB + 1;
              end else begin
                led_r <= led_r << 1;
                pp_posMSB <= pp_posMSB - 1;
              end
            end
            led <= led_r[14:7];
          end
          // Holds pattern
          2'b00: begin
            led <= led;
          end
          default: begin
          end
        endcase
      end
      hw2reg.led_status.de <= 1'b1;
      hw2reg.led_status.d  <= led;
      // Load new values when state changed
      if (old_state != reg2hw.modes.q) begin
        led <= reg2hw.led_pattern.q;
        old_state <= reg2hw.modes.q;
        if (reg2hw.modes.q == 2'b11) begin
          led_r[14:7] <= reg2hw.led_pattern.q;
        end
      end
    end
  end

  // Counter
  logic [31:0] cnt;
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      cnt <= 0;
      cnt_rdy <= 1'b1;
    end else if (cnt != 0) begin
      cnt <= cnt - 1;
      cnt_rdy <= 1'b0;
    end else begin
      cnt_rdy <= 1'b1;
      cnt <= reg2hw.delay.q;
    end
  end

  assign led_o = led;  // output assignment


endmodule
