/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE rev.B2 compliant synthesizable I2C Slave model    ////
////                                                             ////
////                                                             ////
////  Authors: Richard Herveille (richard@asics.ws) www.asics.ws ////
////           John Sheahan (jrsheahan@optushome.com.au)         ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/projects/i2c/    ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2001,2002 Richard Herveille                   ////
////                         richard@asics.ws                    ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

module iic_dummy_slave (
    scl,
    sda,
    data,
    done
);

  //
  // parameters
  //
  parameter I2C_ADR = 7'b011_1011;

  //
  // input && outpus
  //
  input scl;
  inout sda;
  output [23:0] data;
  output done;
  reg [23:0] data_o;
  reg done_o;

  //
  // Variable declaration
  //
  wire debug = 1'b0;
  genvar i;

  reg [15:0] mem_adr;  // memory address
  reg [ 7:0] inc_data;  // incoming data

  reg sta, d_sta;
  reg sto, d_sto;

  reg     [7:0] sr;  // 8bit shift register
  reg           rw;  // read/write direction

  wire          my_adr;  // my address called ??
  wire          i2c_reset;  // i2c-statemachine reset
  reg     [2:0] bit_cnt;  // 3bit downcounter
  wire          acc_done;  // 8bits transfered
  reg           ld;  // load downcounter

  reg           sda_o;  // sda-drive level
  wire          sda_dly;  // delayed version of sda

  integer       fd;

  // statemachine declaration
  parameter stIdle = 3'b000;
  parameter stSlave_ack = 3'b001;
  parameter stGet_mem_adr1 = 3'b010;
  parameter stReg1_ack = 3'b011;
  parameter stGet_mem_adr2 = 3'b100;
  parameter stReg2_ack = 3'b101;
  parameter stData = 3'b110;
  parameter stData_ack = 3'b111;

  reg [2:0] state;  // synopsys enum_state

  //
  // module body
  //

  initial begin
    sda_o  = 1'b1;
    state  = stIdle;
    done_o = 1'b0;
    data_o = '0;
  end

  // generate shift register
  always @(posedge scl) sr <= #1{sr[6:0], sda};

  //detect my_address
  assign my_adr = (sr[7:1] == I2C_ADR);
  // FIXME: This should not be a generic assign, but rather
  // qualified on address transfer phase and probably reset by stop

  //generate bit-counter
  always @(posedge scl)
    if (ld) bit_cnt <= #1 3'b111;
    else bit_cnt <= #1 bit_cnt - 3'h1;

  //generate access done signal
  assign acc_done = !(|bit_cnt);

  // generate delayed version of sda
  // this model assumes a hold time for sda after the falling edge of scl.
  // According to the Phillips i2c spec, there s/b a 0 ns hold time for sda
  // with regards to scl. If the data changes coincident with the clock, the
  // acknowledge is missed
  // Fix by Michael Sosnoski
  assign #1 sda_dly = sda;


  //detect start condition
  always @(negedge sda)
    if (scl) begin
      sta   <= #1 1'b1;
      d_sta <= #1 1'b0;
      sto   <= #1 1'b0;

      if (debug) $display("DEBUG i2c_slave; start condition detected at %t", $time);
    end else sta <= #1 1'b0;

  always @(posedge scl) d_sta <= #1 sta;

  // detect stop condition
  always @(posedge sda)
    if (scl) begin
      sta <= #1 1'b0;
      sto <= #1 1'b1;

      if (debug) $display("DEBUG i2c_slave; stop condition detected at %t", $time);
    end else sto <= #1 1'b0;

  //generate i2c_reset signal
  assign i2c_reset = sta || sto;

  // generate statemachine
  always @(negedge scl or posedge sto)
    if (sto || (sta && !d_sta)) begin
      state <= #1 stIdle; // reset statemachine

      sda_o <= #1 1'b1;
      ld    <= #1 1'b1;
      done_o <= #1 1'b0;
      data_o <= #1 '0;
    end else begin
      // initial settings
      sda_o <= #1 1'b1;
      ld    <= #1 1'b0;
      done_o <= #1 1'b0;

      case (state)  // synopsys full_case parallel_case
        stIdle:  // idle state
        if (acc_done && my_adr) begin
          state <= #1 stSlave_ack;
          rw <= #1 sr[0];
          sda_o <= #1 1'b0;  // generate i2c_ack

          #2;
          if (debug && rw) $display("DEBUG i2c_slave; command byte received (read) at %t", $time);
          if (debug && !rw) $display("DEBUG i2c_slave; command byte received (write) at %t", $time);
        end

        stSlave_ack: begin
          state <= #1 stGet_mem_adr1;
          ld <= #1 1'b1;
        end

        stGet_mem_adr1:  // wait for memory address byte 1
        if (acc_done) begin
          state   <= #1 stReg1_ack;
          mem_adr <= #1 sr;  // store memory address
          sda_o   <= #1 !(sr <= 255);  // generate i2c_ack, for valid address

          if (debug)
            #1 $display("DEBUG i2c_slave; 1st byte address received. adr=%x, ack=%b", sr, sda_o);
        end

        stReg1_ack: begin
          state <= #1 stGet_mem_adr2;
          ld <= #1 1'b1;
        end

        stGet_mem_adr2:  // wait for memory address byte 2
        if (acc_done) begin
          state   <= #1 stReg2_ack;
          mem_adr <= #1{mem_adr, sr};  // store memory address
          sda_o   <= #1 !(sr <= 255);  // generate i2c_ack, for valid address

          if (debug)
            #1 $display("DEBUG i2c_slave; 2nd byte address received. adr=%x, ack=%b", sr, sda_o);
        end

        stReg2_ack: begin
          state <= #1 stData;
          ld    <= #1 1'b1;
        end

        stData: // receive or drive data
                  begin
          if (acc_done) begin
            state <= #1 stData_ack;
            sda_o <= #1 !(sr <= 255);  // send ack on write, receive ack on read

            inc_data <= #1 sr;  // store data in memory

            if (debug)
              #2 $display("DEBUG i2c_slave; data block write %x to address %x", sr, mem_adr);
          end
        end

        stData_ack: begin
          ld <= #1 1'b1;
          sda_o <= #1 1'b1;
          done_o <= #1 1'b1;
          data_o <= #1{mem_adr, inc_data};
        end

      endcase
    end

  // generate tri-states
  assign sda  = sda_o ? 1'bz : 1'b0;

  assign done = done_o;
  assign data = data_o;

  //
  // Timing checks
  //

  wire tst_sto = sto;
  wire tst_sta = sta;

  specify
    specparam normal_scl_low  = 4700,
                normal_scl_high = 4000,
                normal_tsu_sta  = 4700,
                normal_thd_sta  = 4000,
                normal_tsu_sto  = 4000,
                normal_tbuf     = 4700,

                fast_scl_low  = 1300,
                fast_scl_high =  600,
                fast_tsu_sta  = 1300,
                fast_thd_sta  =  600,
                fast_tsu_sto  =  600,
                fast_tbuf     = 1300;

    $width(negedge scl, normal_scl_low);  // scl low time
    $width(posedge scl, normal_scl_high);  // scl high time

    $setup(posedge scl, negedge sda &&& scl, normal_tsu_sta);  // setup start
    $setup(negedge sda &&& scl, negedge scl, normal_thd_sta);  // hold start
    $setup(posedge scl, posedge sda &&& scl, normal_tsu_sto);  // setup stop

    $setup(posedge tst_sta, posedge tst_sto, normal_tbuf);  // stop to start time
  endspecify

endmodule
