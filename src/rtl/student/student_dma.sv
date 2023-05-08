module student_dma (
  input logic clk_i,
  input logic rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  input  tlul_pkg::tl_d2h_t tl_host_i,
  output tlul_pkg::tl_h2d_t tl_host_o
);
  import student_dma_reg_pkg::*;

  student_dma_reg2hw_t reg2hw;
  student_dma_hw2reg_t hw2reg;

  student_dma_reg_top reg_top_i (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .reg2hw,
    .hw2reg,
    .devmode_i('1)
  );
  
  typedef enum logic [6:0] {
    IDLE,
    READ_DESC_SEND,
    READ_DESC_RECV,
    MEMSET_WRITING, // ready to try to write next thing
    MEMSET_WAIT_RESP // still trying to send next thing
  } state_dma_t;
  
  state_dma_t current_state;
  state_dma_t next_state;

  logic [31:0] now_dadr;
  
  typedef enum logic [1:0] {
    STATUS_IDLE = 2'd0,
    STATUS_READING_DESC = 2'd1,
    STATUS_MEMSET_BUSY = 2'd2,
    STATUS_MEMCPY_BUSY = 2'd3
  } dma_status_t;

  typedef enum logic [0:0] {
    DESC_OP_MEMSET = 1'b0,
    DESC_OP_MEMCPY = 1'b1
  } dma_desc_operation_t;

  dma_status_t status;
  logic [31:0] src_adr;
  logic [31:0] dst_adr;
  logic [31:0] length;
  logic [31:0] length_recv;
  logic [31:0] offset;
  logic still_sending;
  logic desc_addr_write;
  logic desc_read_finished;
  dma_desc_operation_t operation;
  logic desc_response_received;
  logic write_done;


  assign hw2reg.status.d = status;
  assign hw2reg.length.d = length;
  assign hw2reg.src_adr.d = src_adr;
  assign hw2reg.dst_adr.d = dst_adr;
  
  assign desc_addr_write = reg2hw.now_dadr.qe;

  logic cmd_stop_strobe;

  assign cmd_stop_strobe = reg2hw.cmd.qe && reg2hw.cmd.q;

    
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end
  
  always_comb begin
  	next_state = current_state;
    case(current_state)
    	IDLE: begin
    		if(desc_addr_write) begin
    			next_state = READ_DESC_SEND;
			 end
  	 end
  		READ_DESC_SEND: begin
  			next_state = READ_DESC_RECV;
  		end
  		READ_DESC_RECV: begin
      		if(desc_response_received)
      			next_state = READ_DESC_SEND;
      		if (desc_read_finished && (operation == DESC_OP_MEMSET))
      			next_state = MEMSET_WRITING;
          if (desc_read_finished && (operation == DESC_OP_MEMCPY))
            next_state = IDLE; // <-- memcpy not implemented yet.
  		end
  		MEMSET_WRITING: begin
  			if (length == 0) next_state = MEMSET_WAIT_RESP;
  			if (length_recv == 0 && length == 0) next_state = IDLE;
  		end
  		MEMSET_WAIT_RESP: begin
  			if (length_recv == 0) next_state = IDLE;
  		end
  		default: begin
  			$display("dma fsm default case");
  			next_state = current_state;
  		end
    endcase
	 
   if (cmd_stop_strobe) next_state = IDLE;
  end
  

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      src_adr <= '0;
      dst_adr <= '0;
      now_dadr <= '0;
      length <= '0;
      length_recv <= '0;
    end else begin	  
      if (current_state == IDLE) begin
      	  
      end
    end
  end
  
  // TL-UL host handling
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
    	tl_host_o <= '{
        a_opcode: tlul_pkg::PutFullData,
        a_mask: '1,
        a_source: '0,
        a_valid: '0,
        default: '0
      };
    	desc_read_finished <= '0;
      still_sending <= 0;
    	offset <= '0;
    	operation <= '0;
    	desc_response_received <= '0;
    	write_done <= '0;
    	status <= STATUS_IDLE;
    	
    end else begin
      tl_host_o <= '{
        a_opcode: tlul_pkg::PutFullData,
        a_mask: '1,
        a_source: '0,
        a_valid: '0,
        default: '0
      };
      status <= STATUS_IDLE;
  		desc_read_finished <= '0;
  		tl_host_o.a_valid <= '0;
      tl_host_o.a_source <= 8'h30000000;
  		desc_response_received <= '0;
  		write_done <= '0;
      tl_host_o.a_mask <= '1; // mask not needed here
    	case(next_state)
        IDLE: begin
          if(desc_addr_write) begin
            now_dadr <= reg2hw.now_dadr.q;
          end
          
          tl_host_o <= '{a_opcode: tlul_pkg::PutFullData, default: '0};
          tl_host_o.d_ready <= '1;
          offset <= '0;
        end
			READ_DESC_SEND: begin
    		status <= STATUS_READING_DESC;
				if (tl_host_i.a_ready) begin
					tl_host_o <= '{a_opcode: tlul_pkg::Get, default: '0};
					tl_host_o.a_valid <= '1;
					tl_host_o.a_size <= 2; // Request size (requested size is 2^a_size, thus 0 = byte, 1 = 16b, 2 = 32b, 3 = 64b, etc)
					tl_host_o.a_source <= 32'h30000000;
					tl_host_o.a_address <= now_dadr + offset;
					tl_host_o.a_data <= src_adr;
					tl_host_o.d_ready <= '1;
					
    			end
			end
			READ_DESC_RECV: begin
    			status <= STATUS_READING_DESC;
    			if(tl_host_i.d_valid == 1) begin
					desc_response_received <= '1;
    				if (offset == 0)
    					operation <= tl_host_i.d_data;
    				if (offset == 4) begin
    					length <= tl_host_i.d_data;
    					length_recv <= tl_host_i.d_data;
    				end
    				if (offset == 8)
    					src_adr <= tl_host_i.d_data;
    				if (offset == 12) begin
    					dst_adr <= tl_host_i.d_data;
  						desc_read_finished <= '1;
  						offset <= '0;
  					end
    				offset <= offset + 4;
				end
			end
			
    		MEMSET_WRITING: begin
    			status <= STATUS_MEMSET_BUSY;
					tl_host_o <= '{a_opcode: tlul_pkg::PutFullData, default: '0};
					tl_host_o.a_valid <= '1;
					tl_host_o.a_size <= 2; // Request size (requested size is 2^a_size, thus 0 = byte, 1 = 16b, 2 = 32b, 3 = 64b, etc)
					
					tl_host_o.a_address <= dst_adr;
					tl_host_o.a_data <= src_adr;
					tl_host_o.d_ready <= '1;
				if (tl_host_i.a_ready) begin
    				dst_adr <= dst_adr + 4;
    				length <= length - 4;
				end
				if (tl_host_i.d_valid) begin
					length_recv <= length_recv - 4;
				end
    		end
    		MEMSET_WAIT_RESP: begin
    			status <= STATUS_MEMSET_BUSY;
  				if (tl_host_i.d_valid) begin
  					length_recv <= length_recv - 4;
  				end
    		end
    		
        default: begin

        end
    	endcase
    end
  end

endmodule
