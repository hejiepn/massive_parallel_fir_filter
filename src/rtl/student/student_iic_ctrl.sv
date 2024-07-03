module student_iic_ctrl (
    input logic clk_i,
    input logic rst_ni,

    inout  logic sda_p,
    inout  logic scl_p,

    input  tlul_pkg::tl_h2d_t tl_i,  //master input (incoming request)
    output tlul_pkg::tl_d2h_t tl_o,  //slave output (this module's response)
  
 
);

import student_iic_ctrl_reg_pkg::*;

student_iic_ctrl_reg2hw_t reg2hw; //read SCL and SDA pins

student_iic_ctrl_hw2reg_t hw2reg; //write on SCL and SDA pins/ enable them

student_iic_ctrl_reg_top student_iic_ctrl_reg_top (
  .clk_i,
  .rst_ni,

  .tl_i,
  .tl_o,

  .reg2hw, // Write
  .hw2reg, // Read

  .devmode_i(1'b1) // If 1, explicit error return for unmapped register access
);

logic sda_en;
logic sda;
logic scl_en;
logic scl;

always_ff @(posedge clk_i or negedge rst_ni) begin : write_to_sda_scl_pins
	if(~rst_ni) begin
		 <= 0;
	end else begin
		if(reg2hw.sda_write.qe) begin
		 sda <= reg2hw.sda_write.q;
		end
		if(reg2hw.sda_en.qe) begin
		 sda_en <= reg2hw.sda_en.q;
		end
		if(reg2hw.scl_write.qe) begin
		 scl <= reg2hw.scl_write.q;
		end
		if(reg2hw.sda_en.qe) begin
		 scl_en <= reg2hw.scl_en.q;
		end
	end
end

iocell_opendrain sda_pad (
	.pad(sda_p),
  	.oe(sda_en),
  	.in(sda)
);

iocell_opendrain scl_pad (
	.pad(scl_p),
  	.oe(scl_en),
  	.in(scl)
);
