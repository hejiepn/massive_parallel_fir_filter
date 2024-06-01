module student_tlul_mux #(
    parameter int NUM = 2
) (
    input logic clk_i,
    input logic rst_ni,

    output tlul_pkg::tl_d2h_t tl_mux_o,
    input  tlul_pkg::tl_h2d_t tl_mux_i,

    input  tlul_pkg::tl_d2h_t  tl_device_o [NUM-1:0],
    output tlul_pkg::tl_h2d_t  tl_device_i [NUM-1:0]
);

  // Implement TL-UL multiplexer here.

  always_comb begin
      case (tl_mux_i.a_address[23:20])
        0: begin
            tl_device_i[0] <= tl_mux_i;
            $display("case no: %d",tl_mux_i.a_address);
            $display("tl_mux_i %d", tl_mux_i.a_address);
        end
        1: begin
            tl_device_i[1] <= tl_mux_i;
            $display("case no: %d",tl_mux_i.a_address);
            $display("tl_mux_i %d", tl_mux_i.a_address);
        end
        default: ;
        endcase
    end

endmodule
