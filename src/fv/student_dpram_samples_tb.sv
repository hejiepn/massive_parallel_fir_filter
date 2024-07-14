module student_dpram_samples_tb;

  // Parameter für die DUT
  localparam int unsigned AddrWidth = 2;
  localparam int unsigned DataSize = 16;
  localparam int unsigned DEBUGMODE = 1;
  localparam string INIT_F = "/home/rvlab/groups/rvlab01/Desktop/dev_hejie/risc-v-lab-group-01/src/fv/data/dpram_zeros_init.mem";

  // Signale für die DUT
  logic clk_i;
  logic ena;
  logic enb;
  logic wea;
  logic [AddrWidth-1:0] addra;
  logic [AddrWidth-1:0] addrb;
  logic [DataSize-1:0] dia;
  logic [DataSize-1:0] dob;

  // DUT Instanziierung
  student_dpram_samples #(
    .AddrWidth(AddrWidth),
    .DataSize(DataSize),
	.DebugMode(DEBUGMODE),
    .INIT_F(INIT_F)
  ) dut (
    .clk_i(clk_i),
    .ena(ena),
    .enb(enb),
    .wea(wea),
    .addra(addra),
    .addrb(addrb),
    .dia(dia),
    .dob(dob)
  );

  // Testvariablen
  logic [AddrWidth-1:0] write_ptr;
  logic [AddrWidth-1:0] read_ptr;
  logic [DataSize-1:0] expected_data;
  logic error_flag = 0;

  // Clock Generation
  initial begin
    clk_i = 0;
    forever #10 clk_i = ~clk_i; // 20ns clock period
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

    // Sicherstellen, dass RAM initialisiert wurde
    #100;

    // Test 2: Mehrfache Schreib- und Lesezugriffe
    $display("Test 2: Mehrfache Schreibzugriffe");
    for (int i = 0; i < 4; i++) begin
      wea = 1;
      ena = 1;
      addra = i;
	  $display("addra: %4x for i: %d",addra, i);
      dia = i;
      @(posedge clk_i);
	  ena = 0;
	  wea = 0;
    end

    // Lesen der geschriebenen Daten
    $display("Test 2: Mehrfache Lesezugriffe");
	enb = 1;
    for (int i = 0; i < 4; i++) begin
      addrb = i;
	  $display("addrb: %4x for i: %d",addrb, i);
      @(posedge clk_i); // eine zweite Taktflanke warten, um sicherzustellen, dass die Daten stabil sind
      @(posedge clk_i); // eine zweite Taktflanke warten, um sicherzustellen, dass die Daten stabil sind
      expected_data = i;
      if (dob !== expected_data) begin
        $display("Fehler: Erwartet %0d, aber dob ist %h", expected_data, dob);
        error_flag = 1;
      end
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
