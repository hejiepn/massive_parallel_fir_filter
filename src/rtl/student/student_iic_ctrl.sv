module student_iic_ctrl (
    input logic clk_i,
    input logic rst_ni,

	input logic sda_i,
	input logic scl_i,
	output logic sda_oe,
	output logic scl_oe,
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

always_ff @(posedge clk_i, negedge rst_ni) begin : write_drive_sda_scl_pins
	if(~rst_ni) begin
		sda_oe <= 1'b0;
		scl_oe <= 1'b0;
	end else begin
		if(reg2hw.sda_en.qe) begin
				sda_oe <= reg2hw.sda_en.q;
				//$display("sda pin q");
		end
		if(reg2hw.scl_en.qe) begin
				scl_oe <= reg2hw.scl_en.q; //drive scl pin low
				//$display("drive scl pin q");
		end
	end
end

logic sda_i_d; // 1st FF delay
logic sda_i_dd; // 2nd FF delay
logic scl_i_d;
logic scl_i_dd;

always_ff@(posedge clk_i or negedge rst_ni) begin : ff_delay
	if(~rst_ni) begin
		scl_i_d <= 0;
		scl_i_dd <= 0;
		sda_i_d <= 0;
		sda_i_dd <= 0;
	end else begin
		scl_i_d <= scl_i;
		scl_i_dd <= scl_i_d;
		sda_i_d <= sda_i;
		sda_i_dd <= sda_i_d;
	end
end

//read_sda_scl_pins
assign hw2reg.sda_read.d = sda_i_dd;
assign hw2reg.scl_read.d = scl_i_dd;

logic testing;

always_ff @(posedge clk_i, negedge rst_ni) begin : testing_proc
	if(~rst_ni) begin
		testing <= 1'b0;
	end else begin
		if(reg2hw.sda_scl_testing.qe) begin
			testing <= reg2hw.sda_scl_testing.q;
		end
	end
end


endmodule