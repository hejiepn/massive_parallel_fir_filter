module student_dpram_samples_tlul_tb;

  // Parameter für die DUT
  localparam int unsigned AddrWidth = 2;
  localparam int unsigned DataSize = 16;
  localparam int unsigned DEBUGMODE = 1;
  localparam string INIT_F = "/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/fv/data/dpram_zeros_init.mem";

  // Signale für die DUT
  logic clk_i;
  logic rst_ni;
  logic ena;
  logic enb;
  logic wea;
  logic [AddrWidth-1:0] addra;
  logic [AddrWidth-1:0] addrb;
  logic [DataSize-1:0] dia;
  logic [DataSize-1:0] dob;
  tlul_pkg::tl_h2d_t tl_h2d;
  tlul_pkg::tl_d2h_t tl_d2h;

  // DUT Instanziierung
  student_dpram_samples_tlul #(
    .AddrWidth(AddrWidth),
    .DataSize(DataSize),
	.DebugMode(DEBUGMODE),
    .INIT_F(INIT_F)
  ) dut (
    .clk_i(clk_i),
	.rst_ni(rst_ni),
    .ena(ena),
    .enb(enb),
    .wea(wea),
    .addra(addra),
    .addrb(addrb),
    .dia(dia),
    .dob(dob),
	.tl_i(tl_h2d),
	.tl_o(tl_d2h)
  );

    tlul_test_host bus(
    .clk_i(clk_i),
    .rst_no(rst_ni),
    .tl_i(tl_d2h),
    .tl_o(tl_h2d)
  );

  // Testvariablen
  logic [AddrWidth-1:0] write_ptr;
  logic [AddrWidth-1:0] read_ptr;
  logic [DataSize-1:0] expected_data;
  logic error_flag = 0;
  logic [31:0] address_sram;
  logic [31:0] tlul_write_data;
  logic [31:0] tlul_read_data;

    // Clock generation: 50 MHz clock -> period = 20ns
   always begin
    clk_i = '1;
    #10000;
    clk_i = '0;
    #10000;
  end


  // Initialisierung und Tests
  initial begin
    // Initialisieren
    $display("RAM control signal init");
    ena = 0;
    enb = 0;
    wea = 0;
    addra = 0;
    addrb = 0;
    dia = 0;
    write_ptr = 0;
    read_ptr = 0;
    expected_data = 0;
    error_flag = 0;

	bus.reset();
    // Wait for reset to propagate
    #40;
	bus.wait_cycles(20);

    // Test 2: Mehrfache Schreib- und Lesezugriffe
    $display("Test 1: Mehrfache Schreibzugriffe");
    for (int i = 0; i < 4; i++) begin
      wea = 1;
      ena = 1;
      addra = i;
	  $display("addra: %4x for i: %d",addra, i);
      dia = i;
      @(posedge clk_i);
	  ena = 0;
	  wea = 0;
	  enb = 1;
      addrb = i;
	  $display("addrb: %4x for i: %d",addrb, i);
      @(posedge clk_i); // eine zweite Taktflanke warten, um sicherzustellen, dass die Daten stabil sind
      @(posedge clk_i); // eine zweite Taktflanke warten, um sicherzustellen, dass die Daten stabil sind
      expected_data = i;
	  $display("dob: %4x and expected_data: %4x",dob, expected_data);
      if (dob !== expected_data) begin
        $display("Fehler: Erwartet %0d, aber dob ist %h", expected_data, dob);
        error_flag = 1;
      end
	  enb = 0;
    end

	//Schreibzugriffe über TLUL ## Address writing for SRAM is address[AddrWidth+1:2]
	$display("Test 3: TLUL schreiben");
	for (int i = 0; i < 4; i++) begin
		address_sram [31:AddrWidth+2] = '0;
		address_sram [AddrWidth+1:2] = i;
		address_sram [1:0] = '0;
		tlul_write_data = {4'hb,i,4'ha,8'hff};
		bus.put_word(address_sram, tlul_write_data);
		bus.get_word(address_sram, tlul_read_data);
	  	$display("tlul_read_data: %4x and expected_data: %4x",tlul_read_data, tlul_write_data);
      	if (tlul_read_data !== tlul_write_data) begin
        	$display("Fehler: Erwartet %0d, aber tlul_read_data ist %h", tlul_write_data, tlul_read_data);
        	error_flag = 1;
      	end
	end

	bus.wait_cycles(20);

    // Testresultat
    if (error_flag) begin
      $display("Test fehlgeschlagen.");
    end else begin
      $display("Test erfolgreich.");
    end

    $finish;
  end
endmodule
