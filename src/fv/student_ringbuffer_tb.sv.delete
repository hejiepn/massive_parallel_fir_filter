module student_ringbuffer_tb;
    logic clk;
    logic rst_n;

    logic valid_strobe_tb;
    logic [15:0] delay_tb;
    logic [15:0] left_in_tb;
    logic [15:0] right_in_tb;

    logic [15:0] left_out_tb;
    logic [15:0] right_out_tb;

    // 50 MHz
    always begin
        clk = '1;
        #10000;
        clk = '0;
        #10000;
    end

    student_ringbuffer DUT (
    .clk_i (clk),
    .rst_ni(rst_n),
    .valid_strobe(valid_strobe_tb),
    .delay(delay_tb),
    .left_in(left_in_tb),
    .right_in(right_in_tb),
    .left_out(left_out_tb),
    .right_out(right_out_tb)
    );

    initial begin
        logic [31:0] errcnt;
        errcnt = '0;

        // trigger reset
        rst_n <= '0;
        @(posedge clk);
        @(posedge clk);
        rst_n <= '1;

        // first cycle
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        valid_strobe_tb = 1'b0;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        valid_strobe_tb = 1'b1;

        // tests with delay = 1
        delay_tb = 16'h0001;

        for (int i = 0; i < 5; i = i + 1) begin
            left_in_tb = i*5;
            right_in_tb = i*10;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            valid_strobe_tb = 1'b0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            valid_strobe_tb = 1'b1;

            if (i == 0) begin
                if (left_out_tb !== 0) begin
                    $error("Left channel value of iteration %u in 1st loop is incorrect: should be %u, is %u", i, 0, left_out_tb);
                    errcnt = errcnt + 1;
                end
                if (right_out_tb !== 0) begin
                    $error("Right channel value of iteration %u in 1st loop is incorrect: should be %u, is %u", i, 0, right_out_tb);
                    errcnt = errcnt + 1;
                end
            end else begin
                if (left_out_tb !== (i*5)) begin
                    $error("Left channel value of iteration %u in 1st loop is incorrect: should be %u, is %u", i, (i*5), left_out_tb);
                    errcnt = errcnt + 1;
                end
                if (right_out_tb !== (i*10)) begin
                    $error("Right channel value of iteration %u in 1st loop is incorrect: should be %u, is %u", i, (i*10), right_out_tb);
                    errcnt = errcnt + 1;
                end
            end
        end

        // tests with delay = 4
        delay_tb = 16'h04;

        for (int i = 0; i < 10; i = i + 1) begin
            left_in_tb = i+10;
            right_in_tb = i+100;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            valid_strobe_tb = 1'b0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            valid_strobe_tb = 1'b1;

            if (i < 3) begin
                if (left_out_tb !== ((i+2)*5)) begin
                    $error("Left channel value of iteration %u in 2nd loop is incorrect: should be %u, is %u", i, ((i+2)*5), left_out_tb);
                    errcnt = errcnt + 1;
                end
                if (right_out_tb !== ((i+2)*10)) begin
                    $error("Right channel value of iteration %u in 2nd loop is incorrect: should be %u, is %u", i, ((i+2)*10), right_out_tb);
                    errcnt = errcnt + 1;
                end
            end else begin
                if (left_out_tb !== ((i-3)+10)) begin
                    $error("Left channel value of iteration %u in 2nd loop is incorrect: should be %u, is %u", i, ((i-3)+10), left_out_tb);
                    errcnt = errcnt + 1;
                end
                if (right_out_tb !== ((i-3)+100)) begin
                    $error("Right channel value of iteration %u in 2nd loop is incorrect: should be %u, is %u", i, ((i-3)+100), right_out_tb);
                    errcnt = errcnt + 1;
                end
            end
        end

        // tests with delay = 10 and no change of data
        delay_tb = 16'h0a;

        for (int i = 0; i < 15; i = i + 1) begin
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            valid_strobe_tb = 1'b0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            valid_strobe_tb = 1'b1;

            if (i < 9) begin
                if (left_out_tb !== ((i+1)+10)) begin
                    $error("Left channel value of iteration %u in 3rd loop is incorrect: should be %u, is %u", i, ((i+1)+10), left_out_tb);
                    errcnt = errcnt + 1;
                end
                if (right_out_tb !== ((i+1)+100)) begin
                    $error("Right channel value of iteration %u in 3rd loop is incorrect: should be %u, is %u", i, ((i+1)+100), right_out_tb);
                    errcnt = errcnt + 1;
                end
            end else begin
                if (left_out_tb !== 19) begin
                    $error("Left channel value of iteration %u in 3rd loop is incorrect: should be %u, is %u", i, 19, left_out_tb);
                    errcnt = errcnt + 1;
                end
                if (right_out_tb !== 109) begin
                    $error("Right channel value of iteration %u in 3rd loop is incorrect: should be %u, is %u", i, 109, right_out_tb);
                    errcnt = errcnt + 1;
                end
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
