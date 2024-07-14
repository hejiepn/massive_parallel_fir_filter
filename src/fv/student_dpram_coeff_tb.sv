module student_dpram_coeff_tb;

  // Parameter für die DUT
  localparam int unsigned AddrWidth = 2;
  localparam int unsigned DataSize = 16;
  localparam int unsigned DEBUGMODE = 1;
  localparam int unsigned MaxAddr = 2**AddrWidth;
  localparam string INIT_F = "/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/fv/data/coe_lp_debug.mem";

  // Signale für die DUT
  logic clk;
  logic rst_ni;
  logic enb;
  logic [AddrWidth-1:0] addrb;
  logic [DataSize-1:0] dob;
  tlul_pkg::tl_h2d_t tl_h2d;
  tlul_pkg::tl_d2h_t tl_d2h;

  // DUT Instanziierung
  student_dpram_coeff #(
    .AddrWidth(AddrWidth),
    .CoeffDataSize(DataSize),
	.DebugMode(DEBUGMODE),
    .INIT_F(INIT_F)
  ) dut (
    .clk_i(clk),
	.rst_ni(rst_ni),
    .enb(enb),
    .addrb(addrb),
    .dob(dob),
	.tl_i(tl_h2d),
	.tl_o(tl_d2h)
  );

    tlul_test_host bus(
    .clk_i(clk),
    .rst_no(rst_ni),
    .tl_i(tl_d2h),
    .tl_o(tl_h2d)
  );

  // Testvariablen
  logic [DataSize-1:0] expected_data;
  logic error_flag;

   // Clock generation: 50 MHz clock -> period = 20ns
   always begin
    clk = '1;
    #10000;
    clk = '0;
    #10000;
  end

  logic [31:0] address_sram;
  logic [31:0] tlul_write_data;
  logic [31:0] tlul_read_data;

  // Initialisierung und Tests
  initial begin
    // Initialisieren
    $display("RAM control signal init");
    enb = 0;
    addrb = 0;
    expected_data = 0;
    error_flag = 0;
	
	bus.reset();
    // Wait for reset to propagate
    #40;
	bus.wait_cycles(20);

    // Lesen der geschriebenen Daten
    $display("Test 1: Mehrfache Lesezugriffe");
	enb = 1;
    for (int i = 0; i < 4; i++) begin
      addrb = i;
	  $display("for i: %d", i);
	  $display("addrb: %4x",addrb);
      @(posedge clk); // eine zweite Taktflanke warten, um sicherzustellen, dass die Daten stabil sind
      @(posedge clk); // eine zweite Taktflanke warten, um sicherzustellen, dass die Daten stabil sind
	  expected_data = i;
      if (dob !== expected_data) begin
        $display("Fehler: Erwartet %0d, aber dob ist %h", expected_data, dob);
        error_flag = 1;
      end
      $display("dob: %4x",dob);
    end
    enb = 0;

	//Schreibzugriffe über TLUL ## Address writing for SRAM is address[AddrWidth+1:2]
	$display("Test 2: TLUL lesen und schreiben");
	for (int i = 0; i < 4; i++) begin
		address_sram [31:AddrWidth+2] = '0;
		address_sram [AddrWidth+1:2] = i;
		address_sram [1:0] = '0;
		tlul_write_data = {'0,i,8'hff};
		bus.put_word(address_sram, tlul_write_data);
		@(posedge clk);
		bus.get_word(address_sram, tlul_read_data);
		if (tlul_read_data !== tlul_write_data) begin
			$display("Fehler: Erwartet %0d, aber tlul_read_data ist %h", tlul_write_data, tlul_read_data);
			error_flag = 1;
		end
	end

	bus.wait_cycles(20);

	// Lesen der geschriebenen Daten
    $display("Test 3: Mehrfache Lesezugriffe nach tlul schreiben");
	enb = 1;
    for (int i = 0; i < 4; i++) begin
      addrb = i;
	  $display("for i: %d", i);
	  $display("addrb: %4x",addrb);
      @(posedge clk); // eine zweite Taktflanke warten, um sicherzustellen, dass die Daten stabil sind
      @(posedge clk); // eine zweite Taktflanke warten, um sicherzustellen, dass die Daten stabil sind
	  expected_data = {i,8'hff};
      if (dob !== expected_data) begin
        $display("Fehler: Erwartet %0d, aber dob ist %h", expected_data, dob);
        error_flag = 1;
      end
      $display("dob: %4x",dob);
    end
    enb = 0;

    // Testresultat
    if (error_flag) begin
      $display("Test fehlgeschlagen.");
    end else begin
      $display("Test erfolgreich.");
    end

    $finish;
  end
endmodule
