module student_tlul_mux #(
    parameter int NUM = 2
) (
    input logic clk_i,
    input logic rst_ni,

    input  tlul_pkg::tl_h2d_t tl_host_i,
    output tlul_pkg::tl_d2h_t tl_host_o,

    input  tlul_pkg::tl_d2h_t  tl_device_o [NUM-1:0],
    output tlul_pkg::tl_h2d_t  tl_device_i [NUM-1:0]
);

  // Implement TL-UL multiplexer here.

  logic [3:0] selected_device;

always_comb begin
	selected_device='0;
	if (tl_host_i.a_valid=='1) begin
		selected_device=tl_host_i.a_address[23:20];
		$display("selected device by host %b",selected_device);
	end 
	else begin
	    for (int i = 0; i < NUM; i++) 
	    begin
	      if (tl_device_o[i].d_valid=='1) begin
			selected_device=i;
			$display("device response from %b",selected_device);
	      end
        end
	end
	tl_host_o = tl_device_o[selected_device];
	$display("tl_host_o is %b",tl_device_o[selected_device]);
	for (int i = 0; i < NUM; i++) begin
			tl_device_i[i] = '0;
		end
        tl_device_i[selected_device] = tl_host_i;
		$display("tl_device_i is %b",tl_device_i[selected_device]);
		$display("tl_host_i is %b",tl_host_i);
    end

endmodule


/*
  always_comb begin
	selected_device = '0;
      case (tl_host_i.a_address[23:20])
        0: begin
            tl_device_i[0] <= tl_host_i;
            $display("case no: %d",tl_host_i.a_address);
            $display("tl_host_i %d", tl_host_i.a_address);
        end
        1: begin
            tl_device_i[1] <= tl_host_i;
            $display("case no: %d",tl_host_i.a_address);
            $display("tl_host_i %d", tl_host_i.a_address);
        end
        default: ;
        endcase
    end

endmodule
*/