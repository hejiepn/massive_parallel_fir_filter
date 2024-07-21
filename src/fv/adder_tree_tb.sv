
//------------------------------------------------------------------------------
// adder_tree_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for adder_tree.sv module


// `timescale 1ns / 1ps

module adder_tree_tb;

// Clock and reset signals
  logic clk_i;
  logic rst_ni;
  logic [16+7-1:0] odata;

// Module under test ==========================================================

adder_tree #(
  .INPUTS_NUM(7),
  .IDATA_WIDTH(16)
) at (
  .clk( clk_i ),
  .nrst( rst_ni ),
  .idata( { 16'h0002,
			16'h0002,
			16'h0001,
			16'h0001,
			16'h0001,
			16'h0001,
			16'h0001} ),
  .odata(odata)
);

// Clock generation: 50 MHz clock -> period = 20ns
   always begin
    clk_i = '1;
    #10000;
    clk_i = '0;
    #10000;
  end

  initial begin
	rst_ni = '0;
	#100;
	rst_ni = '1;
	#100;

	$display("wait for adder tree to finish");

	#1000000;

	$display("odata", odata);

  end

endmodule
