module student_tlul_mux #(
    parameter int NUM = 2
) (
    input logic clk_i,
    input logic rst_ni,

    output tlul_pkg::tl_d2h_t tl_o,  //slave output (this module's response)
    input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)

    input  tlul_pkg::tl_d2h_t  children_o [NUM-1:0], // d_stuff
    output tlul_pkg::tl_h2d_t  children_i [NUM-1:0]  // a_stuff
);

  // Implement TL-UL multiplexer here.

endmodule
