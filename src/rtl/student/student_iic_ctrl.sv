module student_iic_ctrl (
    input logic clk_i,
    input logic rst_ni,

    inout  logic sda,
    inout  logic scl,

    input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)
    output tlul_pkg::tl_d2h_t tl_o  //slave output (this module's response)
);

import student_iic_ctrl_reg_pkg::*;

student_iic_ctrl_reg2hw_t reg2hw; //read SCL and SDA pins

student_iic_ctrl_hw2reg_t hw2reg; //write on SCL and SDA pins/ enable them

student_iic_ctrl_reg_top student_iic_ctrl_reg_top (
  .clk_i,
  .rst_ni,

  .tl_i,
  .tl_o,

  .reg2hw, // read
  .hw2reg, // write

  .devmode_i(1'b1) // If 1, explicit error return for unmapped register access
);

logic sda_o;
logic sda_en;
logic sda_i;
logic scl_o;
logic scl_en;
logic scl_i;

always_ff @(posedge clk_i or negedge rst_ni) begin : write_drive_sda_scl_pins
	if(~rst_ni) begin
		 sda_o  <= '0;
		 sda_en <= '0;
		 scl_o  <= '0;
		 scl_en <= '0;
	end else begin
		if(reg2hw.sda_en.qe) begin
		 sda_o <= reg2hw.sda_write.q;
		 sda_en <= reg2hw.sda_en.q;
		end
		if(reg2hw.scl_en.qe) begin
		 scl_o <= reg2hw.scl_write.q;
		 scl_en <= reg2hw.scl_en.q;
		end
	end
end

logic sda_en_buf;
logic scl_en_buf;

assign sda_en_buf = sda_en;
assign scl_en_buf = scl_en;

always_ff@(posedge clk_i or negedge rst_ni) begin : read_sda_scl_pins
	if(~rst_ni) begin
		hw2reg.sda_read.d <= '0;
		hw2reg.scl_read.d <= '0;
		hw2reg.sda_read.de <= 1'b0;
		hw2reg.scl_read.de <= 1'b0;
	end else begin
		if (~sda_en_buf) begin
			hw2reg.sda_read.de <= 1'b1;
			hw2reg.sda_read.d <= sda_i;
		end else begin
			hw2reg.sda_read.de <= 1'b0;
		end 
		if (~scl_en_buf) begin
			hw2reg.scl_read.de <= 1'b1;
			hw2reg.scl_read.d <= scl_i;
		end else begin
			hw2reg.scl_read.de <= 1'b0;
		end
	end
end

iocell_bidir #(
	.Width(1)
	) sda_pad (
	.pad(sda),
  	.oe(sda_en_buf),
	.out(sda_o),
  	.in(sda_i)
);

iocell_bidir #(
	.Width(1)
	) scl_pad (
	.pad(scl),
  	.oe(scl_en_buf),
	.out(scl_o),
  	.in(scl_i)
);

endmodule