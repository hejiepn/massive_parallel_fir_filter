module student_rlight (
  input logic clk_i,
  input logic rst_ni,

  output tlul_pkg::tl_d2h_t tl_o,  //slave output (this module's response)
  input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)

  output logic [7:0] led_o
);


  logic [3:0] addr;
  logic we;
  logic re;
  logic [31:0] wdata;
  logic [31:0] rdata;

  tlul_adapter_reg #(
    .RegAw(4),
    .RegDw(32)
  ) adapter_reg_i (
    .clk_i,
    .rst_ni,

    .tl_i,
    .tl_o,

    .we_o   (we),
    .re_o   (re),
    .addr_o (addr),
    .wdata_o(wdata),
    .be_o   (),
    .rdata_i(rdata),
    .error_i('0)
  );

  localparam logic [3:0] ADDR_REGA = 4'h0;
  localparam logic [3:0] ADDR_REGB = 4'h4;
  localparam integer cnt_delay = 3;

  logic [31:0] regA;
  logic [ 7:0] regB;

  // Bus reads
  // ---------

  always_comb begin
    rdata = '0;  // !!!
    if (re) begin
      case (addr)
        ADDR_REGA:  rdata[31:0] = regA;
        ADDR_REGB:  rdata[ 7:0] = regB;
        default:    rdata       = '0;
      endcase
    end
  end


  // Bus writes
  // ----------

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      regA   <= 32'h0000AFFE; // reset value
      regB   <= '0;           // reset value
    end else begin
      if (we) begin
        case (addr)
          ADDR_REGA: regA <= wdata[31:0];
          ADDR_REGB: regB <= wdata[ 7:0];
          default: ;
        endcase
      end // if(we)
    end // if (~rst_ni) else
  end 


  // Demo FSM. Replace with your rlight
  // ----------------------------------
  enum logic[1:0] {ping_pong, rot_left, rot_right, stop} state; 
    logic [7:0] led;
    logic [2:0] cnt;
    logic [3:0] cnt_pp;
    logic [7:0] temp_pp;

  always_ff @(posedge clk_i, negedge rst_ni) begin
  	if (~rst_ni) begin
	      state   <= ping_pong;
	      led     <= 8'hfe;
	      cnt     <= cnt_delay;
	      cnt_pp <= '0;
	      temp_pp [7:0] <= 8'b00000000;
    	end //if ~rst_ni
    	else begin
    	      case (regB)
		    	0: begin
			  state   <= ping_pong;
			end // 0
			1: begin
			  state   <= rot_left;
			end // 1
			2: begin
			  state   <= rot_right;
			end // 2
			3: begin
			  state   <= stop;
			end // 3
			default: begin
			  state <= ping_pong;
			end // default
	      endcase
	      case (state)
    		//ping pong
      			ping_pong: begin
				if(cnt != 0) begin
				cnt <= cnt - 1;
				end 
				else begin
					if (cnt_pp[3] == 'b0) begin
					      temp_pp[7:1] <= temp_pp[6:0];
					      temp_pp[0] <= led[7];
					      led[7:1] <= led[6:0];
					      cnt_pp <= cnt_pp + 1;
					      if (cnt_pp[2:0] == 3'b110) begin
						  cnt_pp[3] <= 'b1;
				      		end
				  	end
				  	else begin
					      led[6:0] <= led[7:1];
					      led[7] <= temp_pp[0];
					      temp_pp[6:0] <= temp_pp[7:1];
					      cnt_pp <= cnt_pp - 1;
					      if (cnt_pp[2:0] == 3'b000) begin
						  cnt_pp[3] <='b0;
					      end
          				end
				cnt <= cnt_delay;
        			end//else
     			end//ping_pong
     		//rot_left
     			rot_left: begin
				if(cnt != 0) begin
				   cnt <= cnt - 1;
				end 
				else begin
				   led[0] <= led[7];
				   led[7:1] <= led[6:0];
				   cnt <= cnt_delay;
				end
			end//rot_left	
		//rot_right
			rot_right: begin
				if(cnt != 0) begin
					cnt <= cnt - 1;
			       	end 
			       	else begin
					led[7] <= led[0];
					led[6:0] <= led[7:1];
					cnt <= cnt_delay;
				end
			end//rot_right
			stop: begin
			    
			end//stop
			default: begin
			
			end//default

    		endcase
    	end //else ~rst_ni
  end //  always_ff
 
  assign led_o = led; // output assignment

endmodule
