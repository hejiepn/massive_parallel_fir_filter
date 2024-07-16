module student_tlul_mux #(
    parameter int NUM = 2,
    parameter int ADDR_WIDTH = 4,
    parameter int ADDR_OFFSET = 20,
    parameter int CURR_OFFSET = 24,
    parameter int CURR_WIDTH = 8,
    parameter int CURR_VAL = 16
) (
    input logic clk_i,
    input logic rst_ni,

    input  tlul_pkg::tl_h2d_t tl_host_i,
    output tlul_pkg::tl_d2h_t tl_host_o,

    input  tlul_pkg::tl_d2h_t tl_device_o[NUM-1:0],
    output tlul_pkg::tl_h2d_t tl_device_i[NUM-1:0]
);

  // Address decoding
  logic [3:0] select;
  logic is_curr;

  assign select = tl_host_i.a_address[ADDR_OFFSET+ADDR_WIDTH-1:ADDR_OFFSET];

  always_comb begin
    is_curr = 0;
    if ((tl_host_i.a_address[CURR_OFFSET+CURR_WIDTH-1:CURR_OFFSET] == CURR_VAL) && tl_host_i.a_valid) begin // Check if the request is for the current device which starts always with 0x1xxxxxxx
      is_curr = 1;
    end
  end

  // TL-UL multiplexing
  always_comb begin
    for (int i = 0; i < NUM; i++) begin
      tl_device_i[i] = '0;
      tl_device_i[i].d_ready = 1;
    end
    if (is_curr) begin
      tl_device_i[select] = tl_host_i;
    end
    tl_host_o = '0;
    tl_host_o.a_ready = 1;
    for (int i = 0; i < NUM; i++) begin
      if (tl_device_o[i].d_valid) begin
        tl_host_o = tl_device_o[i];
      end
    end
  end
endmodule