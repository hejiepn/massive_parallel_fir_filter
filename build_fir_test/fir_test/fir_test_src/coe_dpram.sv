module coefficient_bram (
    input logic [2:0] raddr,
    output logic [15:0] rdata
);

  // Define coefficients for a 5-tap FIR filter
  localparam logic [15:0] COEFFICIENTS [0:4] = {
    16'h19, 16'h3f, 16'h53, 16'h3f, 16'h19
  };
  
  // Read operation
  assign rdata = COEFFICIENTS[raddr];

endmodule
