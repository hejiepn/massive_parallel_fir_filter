module student_bram_tb;
    logic clk;

    logic pos_edge_tb;
    logic [15:0] left_in_ff_tb;
    logic [15:0] wr_addr_tb;
    logic [15:0] left_rdata_tb;
    logic [15:0] rd_addr_tb;

    // 50 MHz
    always begin
        clk = '1;
        #10000;
        clk = '0;
        #10000;
    end

    localparam period = 10000000;

    student_bram #(16, 16) DUT (
    .clk_i (clk),
    .wvalid(pos_edge_tb),
    .wdata (left_in_ff_tb),
    .waddr (wr_addr_tb),
    .rdata (left_rdata_tb),
    .raddr (rd_addr_tb)
    );

    initial begin
        logic [31:0] errcnt;
        errcnt = '0;

        @(posedge clk);

        for (int i = 0; i < 5; i = i + 2) begin
            pos_edge_tb = 1'b1;
            left_in_ff_tb = i*5;
            wr_addr_tb = i + 1;
            rd_addr_tb = wr_addr_tb - 1;
            @(posedge clk);
            @(posedge clk);

            if (i !== 0) begin
                if (left_rdata_tb !== ((i-2)*3)) begin
                    $error("Value 1 of iteration %u is incorrect: should be %u, is %u", i, ((i-2)*3), left_rdata_tb);
                    errcnt = errcnt + 1;
                end
            end

            pos_edge_tb = 1'b0;
            left_in_ff_tb = i*2;
            wr_addr_tb = i + 2;
            rd_addr_tb = wr_addr_tb - 1;
            @(posedge clk);
            @(posedge clk);

            if (left_rdata_tb !== (i*5)) begin
                $error("Value 2 of iteration %u is incorrect: should be %u, is %u", i, (i*5), left_rdata_tb);
                errcnt = errcnt + 1;
            end

            pos_edge_tb = 1'b1;
            left_in_ff_tb = i*3;
            wr_addr_tb = i + 2;
            rd_addr_tb = wr_addr_tb - 1;
            @(posedge clk);
            @(posedge clk);

            if (left_rdata_tb !== (i*5)) begin
                $error("Value 3 of iteration %u is incorrect: should be %u, is %u", i, (i*5), left_rdata_tb);
                errcnt = errcnt + 1;
            end
        end

        if (errcnt > 0) begin
            $display("### TESTS FAILED WITH %d ERRORS###", errcnt);
        end else begin
            $display("### TESTS PASSED ###");
        end

        $finish;
    end


endmodule
