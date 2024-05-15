module student_rlight (
  input logic clk_i,
  input logic rst_ni,

  output tlul_pkg::tl_d2h_t tl_o,  //slave output (this module's response)
  input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)

  output logic [7:0] led_o
);

/*
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
  */
  
  import student_rlight_reg_pkg::*;
  student_rlight_reg2hw_t reg2hw; //write
  student_rlight_hw2reg_t hw2reg; //read

  student_rlight_reg_top student_rlight_reggen_module(
  .clk_i,
  .rst_ni,
  .tl_i,
  .tl_o,
  .reg2hw,
  .hw2reg,
  .devmode_i('0)
  );
  
  localparam logic [3:0] ADDR_REGA = 4'h0;
  localparam logic [3:0] ADDR_REGB = 4'h4;
  localparam logic [3:0] ADDR_REGC = 4'h8;
  
  localparam integer reset_cnt_delay = 3;
  localparam logic [7:0] reset_led_pattern = 8'h3C;
  localparam logic [31:0] reset_register_pattern = 32'h00003C3C;
  localparam logic [7:0] reset_register_mode = 8'h00;


  logic [ 7:0] regA;
  logic [ 7:0] regB;
  logic [ 7:0] regC;

/*
  // Bus reads
  // ---------

  always_comb begin
    rdata = '0;  // !!!
    if (re) begin
      case (addr)
        ADDR_REGA:  rdata[31:0] = regA;
        ADDR_REGB:  rdata[ 7:0] = regB;
        ADDR_REGC:  rdata[ 7:0] = regC;
        default:    rdata       = '0;
      endcase
    end
  end
*/

//register reads
  always_comb begin
       if (reg2hw.rega.qe) begin
           regA <= reg2hw.rega.q;
       end;
       if (reg2hw.regb.qe) begin
           regB <= reg2hw.regb.q;
       end;
       if (reg2hw.regc.qe) begin
           regC <= reg2hw.regc.q;
       end;
   end

/*
  // Bus writes
  // ----------

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      regA   <= reset_register_pattern; // reset value
      regB   <= reset_register_mode; // reset value
      regC   <= reset_cnt_delay; // reset value
    end else begin
      if (we) begin
        case (addr)
          ADDR_REGA: regA <= wdata[31:0];
          ADDR_REGB: regB <= wdata[ 7:0];
          ADDR_REGC: regC <= wdata[ 7:0];
          default: ;
        endcase
      end // if(we)
    end // if (~rst_ni) else
  end 
*/

//register write

 always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      hw2reg.rega.d <= reset_led_pattern;
      hw2reg.regb.d <= reset_register_mode;
      hw2reg.regc.d <= reset_cnt_delay;
      hw2reg.regd.d <= reset_led_pattern;
    end
    else begin
       if (hw2reg.rega.de) begin
           hw2reg.rega.d <= regA;
       end;
       if (hw2reg.regb.de) begin
           hw2reg.regb.d <= regB;
       end;
       if (hw2reg.regc.de) begin
           hw2reg.regc.d <= regC;
       end;
    end // else (~rst_ni)
 end 

 // Demo FSM. Replace with your rlight
  // ----------------------------------
  enum logic[1:0] {ping_pong, rot_left, rot_right, stop} mode; 
    logic [7:0] led;
    logic [7:0] cnt;
    logic [7:0] cnt_pre_value;
    logic [3:0] cnt_pp;
    logic [7:0] temp_pp;
    logic [7:0] pattern_pre;

  always_ff @(posedge clk_i, negedge rst_ni) begin
  	if (~rst_ni) begin
	      mode   <= ping_pong;
	      led     <= reset_led_pattern;
	      cnt     <= reset_cnt_delay;
	      cnt_pre_value <= reset_cnt_delay;
	      cnt_pp <= '0;
	      temp_pp [7:0] <= 8'b00000000;
              pattern_pre <= reset_led_pattern;
    	end //if ~rst_ni
    	else begin
    	      case (regB)
		    	0: begin
			  mode   <= ping_pong;
			end // 0
			1: begin
			  mode   <= rot_left;
			end // 1
			2: begin
			  mode   <= rot_right;
			end // 2
			3: begin
			  mode   <= stop;
			end // 3
			default: begin
			  mode <= ping_pong;
			end // default
	      endcase
// delay register check
	      if (regC != cnt_pre_value) begin
	      	cnt <= regC;
	      	cnt_pre_value <= regC;
	      end
	      else if (cnt == 0) begin
	      	cnt <= regC;
	      end
// pattern register check
              if (regA != pattern_pre) begin
                 pattern_pre <= regA;
                 led <= regA;
              end
	      case (mode)
	      		ping_pong: begin
				if(cnt == 0) begin
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
        			end//if
                                else begin
                                   cnt -= 1;
                                end //else
     			end//ping_pong
	      		rot_right: begin
                                 if(cnt == 0) begin
                                    led[7] <= led[0];
		               	    led[6:0] <= led[7:1];
			       	 end 
			       	 else begin	
                                   cnt -= 1;
				 end
	      		end//rot_right
			rot_left: begin
				if(cnt == 0) begin
				   led[0] <= led[7];
				   led[7:1] <= led[6:0];
				end
				else begin
				   cnt -= 1;
				end
			end//rot_left	
			stop: begin
		
			end//stop
			default: begin
			
			end//default
    		endcase
        hw2reg.regd.d <= led; //keep track of led status
    	end //else ~rst_ni
  end //  always_ff

  assign led_o = led; // output assignment

endmodule
