module student_iic_ctrl (
    input logic clk_i,
    input logic rst_ni,
    input logic stb_i,
    input logic [7:0] addr_i,
    input logic [7:0] data_i,
    output logic done_o,
    output logic err_o,

    input  logic sda_i,
    input  logic scl_i,
    output logic sda_oe,
    output logic scl_oe
);

  localparam TSCL_CYCLES = 125; // f_sys/f_iic = 50MHz/400KHz = 125

  logic delayedSda, delayed2Sda, delayedScl;
  logic startCondition, stopCondition;

  enum logic [1:0] {
    busUnknown,
    busFree,
    busBusy
  } busState;

  typedef enum logic [2:0] {
    stateIdle,
    stateStart,
    stateWrite,
    stateError,
    stateStop,
    stateSAck
  } state_e;

  logic [31:0] sclCnt;
  logic [31:0] busFreeCnt;

  state_e state, nextState;
  logic rSda, rScl; //registered versions of SDA and SCL, reflect current state

  logic [7:0] loadByte;
  logic dataBitOut, shiftBit;
  logic [7:0] dataByte;
  logic [2:0] bitCount;

  logic [1:0] subState;
  logic iSda, iScl, iDone, iErr; //intermediate signals, reflect next state
  logic latchAddr, latchData;
  logic addrNData;
  logic [7:0] currAddr;

  // Bus state detection
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      delayedSda  <= 1'b0;
      delayed2Sda <= 1'b0;
      delayedScl  <= 1'b0;
    end else begin
      delayedSda  <= sda_i;
      delayed2Sda <= delayedSda;
      delayedScl  <= scl_i;
    end
  end

  assign startCondition = delayedScl & ~delayedSda & delayed2Sda;  // SCL high, SDA high to low: START
  assign stopCondition  = delayedScl & delayedSda & ~delayed2Sda;  // SCL high, SDA low to high: STOP

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      busState <= busUnknown;
    end else if (startCondition == 1) begin
      busState <= busBusy;
    end else if (busFreeCnt == 0) begin
      busState <= busFree;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      busFreeCnt <= TSCL_CYCLES;
    end else if (delayedScl == 0 || delayedSda == 0) begin
      busFreeCnt <= TSCL_CYCLES;
    end else if (delayedScl == 1 && delayedSda == 1) begin
      busFreeCnt <= busFreeCnt - 1;  //Counting down 1 SCL period on free bus
    end
  end

  //SCL counter for 1/4 SCL period
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      sclCnt <= TSCL_CYCLES / 4;
    end else if (sclCnt == 0 || state == stateIdle) sclCnt <= TSCL_CYCLES / 4;
    else sclCnt <= sclCnt - 1;
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      state  <= stateIdle;
      rSda   <= 1'b1;
      rScl   <= 1'b1;
      done_o <= 1'b0;
      err_o  <= 1'b0;
    end else begin
      state  <= nextState;
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
      dataByte <= {dataByte[6:0], delayedSda};
      bitCount <= bitCount - 1;
    end
  end

  // Stores the I2C slave address
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      currAddr <= '0;
    end else if (latchAddr == 1) currAddr <= addr_i;
  end

  assign loadByte   = latchAddr == 1 ? addr_i : data_i;
  assign dataBitOut = dataByte[7];

  //Substate counter: Divides each state in 4 to respect setup and hold times of the I2C bus
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      subState <= 0;
    end else if (state == stateIdle) subState <= 0;
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

    if (state == stateStart) begin
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

    if (state == stateStop) begin
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

    if (state == stateSAck) begin
      case (subState)
        2'b00:   iSda = 1'b1;
        2'b01:   iScl = 1'b1;
        2'b10:   iScl = 1'b1;
        2'b11:   iScl = 1'b0;
        default: ;
      endcase
    end

    if (state == stateWrite) begin
      case (subState)
        2'b00:   iSda = dataBitOut;
        2'b01:   iScl = 1'b1;
        2'b10:   iScl = 1'b1;
        2'b11:   iScl = 1'b0;
        default: ;
      endcase
    end

    if (state == stateSAck && sclCnt == 0 && subState == 2'b01) begin
      if (delayedSda == 1) begin
        iDone = 1;
        iErr  = 1;  // Not acknowledged
      end else if (addrNData == 1'b0) iDone = 1;
    end

    if ((state == stateWrite && sclCnt == 0 && subState == 2'b11)
    || (state == stateSAck && subState == 2'b01)) // Read in the middle of scl bit
      shiftBit = 1;

    if (state == stateStart) latchAddr = 1;  //Get the address byte for the next write

    if (state == stateSAck && subState == 2'b11) latchData = 1;  //Get the data byte for the next write
  end

  //Decode next state
  always_comb begin
    nextState = state;
    case (state)
      stateIdle:  if (stb_i == 1 && busState == busFree) nextState = stateStart;
      stateStart: if (subState == 2'b11 && sclCnt == 0) nextState = stateWrite;
      stateWrite: if (subState == 2'b11 && sclCnt == 0 && bitCount == 0) nextState = stateSAck;
      stateSAck:
      if (subState == 2'b11 && sclCnt == 0) begin
        if (dataByte[0] == 1'b1) nextState = stateStop;  // Slave returns NACK
        else if (addrNData == 1'b1) nextState = stateWrite;  // Write data after just sending address
        else if (stb_i == 1) begin
          if (currAddr == addr_i) nextState = stateWrite;
          else nextState = stateStart;
        end else nextState = stateStop;
      end
      stateStop:  if (subState == 2'b10 && sclCnt == 0) nextState = stateIdle;
      default: nextState = stateIdle;
    endcase
  end

  assign sda_oe = ~rSda;
  assign scl_oe = ~rScl;
endmodule
