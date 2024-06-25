module coefficient_bram (
    input logic [3:0] raddr,
    output logic [15:0] rdata
);

  // Define coefficients for a 10-tap FIR filter (example coefficients)
  localparam logic [15:0] COEFFICIENTS [0:10] = {
    16'hFB, 16'hFC, 16'h09, 16'h22, 16'h3C, 16'h48, 16'h3C, 16'h22, 16'h09, 16'hFC, 16'hFB
  };

  // Read operation
  assign rdata = COEFFICIENTS[raddr];

endmodule
