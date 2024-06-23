module student_iic_master (
    input logic clk_i,
    input logic rst_ni,
    input logic stb_i,
    input logic [7:0] a_i,
    input logic [7:0] d_i,
    output logic done_o,
    output logic err_o,

    input  logic sda_i,
    input  logic scl_i,
    output logic sda_oe,
    output logic scl_oe
);

  localparam TSCL_CYCLES = 125;

  logic dSda, ddSda, dScl;
  logic fStart, fStop;

  enum logic [1:0] {
    busUnknown,
    busFree,
    busBusy
  } busState;

  typedef enum logic [2:0] {
    stIdle,
    stStart,
    stWrite,
    stError,
    stStop,
    stSAck
  } state_e;

  logic [31:0] sclCnt;
  logic [31:0] busFreeCnt;

  state_e state, nstate;
  logic rSda, rScl;

  logic [7:0] loadByte;
  logic dataBitOut, shiftBit;
  logic [7:0] dataByte;
  logic [2:0] bitCount;

  logic [1:0] subState;
  logic iSda, iScl, iDone, iErr;
  logic latchAddr, latchData;
  logic addrNData;
  logic [7:0] currAddr;

  // Bus state detection
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      dSda  <= 1'b0;
      ddSda <= 1'b0;
      dScl  <= 1'b0;
    end else begin
      dSda  <= sda_i;
      ddSda <= dSda;
      dScl  <= scl_i;
    end
  end

  assign fStart = dScl & ~dSda & ddSda;  // SCL high, SDA high to low: START
  assign fStop  = dScl & dSda & ~ddSda;  // SCL high, SDA low to high: STOP

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      busState <= busUnknown;
    end else if (fStart == 1) begin
      busState <= busBusy;
    end else if (busFreeCnt == 0) begin
      busState <= busFree;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      busFreeCnt <= TSCL_CYCLES;
    end else if (dScl == 0 || dSda == 0) begin
      busFreeCnt <= TSCL_CYCLES;
    end else if (dScl == 1 && dSda == 1) begin
      busFreeCnt <= busFreeCnt - 1;  //Counting down 1 SCL period on free bus
    end
  end

  //SCL counter for 1/4 SCL period
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      sclCnt <= TSCL_CYCLES / 4;
    end else if (sclCnt == 0 || state == stIdle) sclCnt <= TSCL_CYCLES / 4;
    else sclCnt <= sclCnt - 1;
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      state  <= stIdle;
      rSda   <= 1'b1;
      rScl   <= 1'b1;
      done_o <= 1'b0;
      err_o  <= 1'b0;
    end else begin
      state  <= nstate;
      rSda   <= iSda;
      rScl   <= iScl;
      done_o <= iDone;
      err_o  <= iErr;
    end
  end

  // Stores the byte to be written
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      dataByte  <= '0;
      bitCount  <= 0;
      addrNData <= 1'b0;
    end else if ((latchData == 1 || latchAddr == 1) && sclCnt == 0) begin
      dataByte <= loadByte;
      bitCount <= 7;
      if (latchData == 1) addrNData <= 1'b0;
      else addrNData <= 1'b1;
    end else if (shiftBit == 1 && sclCnt == 0) begin
      dataByte <= {dataByte[6:0], dSda};
      bitCount <= bitCount - 1;
    end
  end

  // Stores the I2C slave address
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      currAddr <= '0;
    end else if (latchAddr == 1) currAddr <= a_i;
  end

  assign loadByte   = latchAddr == 1 ? a_i : d_i;
  assign dataBitOut = dataByte[7];

  //Substate counter: Divides each state in 4 to respect setup and hold times of the I2C bus
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      subState <= 0;
    end else if (state == stIdle) subState <= 0;
    else if (sclCnt == 0) subState <= subState + 1;
  end

  // Decode output depending on the current state
  always_comb begin
    iSda = rSda;
    iScl = rScl;
    iDone = 0;
    iErr = 0;
    shiftBit = 0;
    latchAddr = 0;
    latchData = 0;

    if (state == stStart) begin
      case (subState)
        2'b00:   iSda = 1'b1;
        2'b01: begin
          iSda = 1'b1;
          iScl = 1'b1;
        end
        2'b10: begin
          iSda = 1'b0;
          iScl = 1'b1;
        end
        2'b11: begin
          iSda = 1'b0;
          iScl = 1'b0;
        end
        default: ;
      endcase
    end

    if (state == stStop) begin
      case (subState)
        2'b00:   iSda = 1'b0;
        2'b01: begin
          iSda = 1'b0;
          iScl = 1'b1;
        end
        2'b10: begin
          iSda = 1'b1;
          iScl = 1'b1;
        end
        default: ;
      endcase
    end

    if (state == stSAck) begin
      case (subState)
        2'b00:   iSda = 1'b1;
        2'b01:   iScl = 1'b1;
        2'b10:   iScl = 1'b1;
        2'b11:   iScl = 1'b0;
        default: ;
      endcase
    end

    if (state == stWrite) begin
      case (subState)
        2'b00:   iSda = dataBitOut;
        2'b01:   iScl = 1'b1;
        2'b10:   iScl = 1'b1;
        2'b11:   iScl = 1'b0;
        default: ;
      endcase
    end

    if (state == stSAck && sclCnt == 0 && subState == 2'b01) begin
      if (dSda == 1) begin
        iDone = 1;
        iErr  = 1;  // Not acknowledged
      end else if (addrNData == 1'b0) iDone = 1;
    end

    if ((state == stWrite && sclCnt == 0 && subState == 2'b11)
    || (state == stSAck && subState == 2'b01)) // Read in the middle of scl bit
      shiftBit = 1;

    if (state == stStart) latchAddr = 1;  //Get the address byte for the next write

    if (state == stSAck && subState == 2'b11) latchData = 1;  //Get the data byte for the next write
  end

  //Decode next state
  always_comb begin
    nstate = state;
    case (state)
      stIdle:  if (stb_i == 1 && busState == busFree) nstate = stStart;
      stStart: if (subState == 2'b11 && sclCnt == 0) nstate = stWrite;
      stWrite: if (subState == 2'b11 && sclCnt == 0 && bitCount == 0) nstate = stSAck;
      stSAck:
      if (subState == 2'b11 && sclCnt == 0) begin
        if (dataByte[0] == 1'b1) nstate = stStop;  // Slave returns NACK
        else if (addrNData == 1'b1) nstate = stWrite;  // Write data after just sending address
        else if (stb_i == 1) begin
          if (currAddr == a_i) nstate = stWrite;
          else nstate = stStart;
        end else nstate = stStop;
      end
      stStop:  if (subState == 2'b10 && sclCnt == 0) nstate = stIdle;
      default: nstate = stIdle;
    endcase
  end

  assign sda_oe = ~rSda;
  assign scl_oe = ~rScl;
endmodule
