module dummy_device (
    input logic clk_i,
    input logic rst_ni,

    output tlul_pkg::tl_d2h_t tl_o,
    input  tlul_pkg::tl_h2d_t tl_i
);

  logic delay;
  logic [31:0] reg_0;
  logic [31:0] reg_1;
  logic [31:0] reg_2;
  logic [31:0] reg_3;

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      tl_o <= '{d_opcode: tlul_pkg::AccessAck, default: '0};
      delay <= '0;
      reg_0 <= '0;
      reg_1 <= '0;
      reg_2 <= '0;
      reg_3 <= '0;
    end else begin
      tl_o.a_ready <= !delay;
      tl_o.d_valid <= delay;
      if (delay) begin
      	  delay <= '0;
      end
      if (tl_i.a_valid && (delay == 0)) begin
	    tl_o.d_size <= tl_i.a_size;
	    //tl_o.d_source <= tl_o.a_source;
	    //tl_o.d_sink <= tl_o.a_sink;
        delay <= '1;
        case (tl_i.a_opcode)
          tlul_pkg::PutFullData,tlul_pkg::PutPartialData: begin
          	  tl_o.d_opcode <= tlul_pkg::AccessAck;
              case(tl_i.a_address[3:0])
              	  0: begin
              	  	reg_0 <= tl_i.a_data;
              	  end
              	  4: begin
              	  	reg_1 <= tl_i.a_data;
              	  end
              	  8: begin
              	  	reg_2 <= tl_i.a_data;
              	  end
              	  12: begin
              	  	reg_3 <= tl_i.a_data;
              	  end
              	  default: ;
              endcase
          end
          tlul_pkg::Get: begin
          	  tl_o.d_opcode <= tlul_pkg::AccessAckData;
              case(tl_i.a_address[3:0])
              	  0: begin
              	  	tl_o.d_data <= reg_0;
              	  end
              	  4: begin
              	  	tl_o.d_data <= reg_1;
              	  end
              	  8: begin
              	  	tl_o.d_data <= reg_2;
              	  end
              	  12: begin
              	  	tl_o.d_data <= reg_3;
              	  end
              	  default: ;
              endcase
          end
          default: ;
        endcase
      end
    end
  end 

endmodule
