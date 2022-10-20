`timescale 1 ns / 100 ps

module test();

localparam                 TOTAL_TESTS     = 2;
localparam                 CLK_HALF_PERIOD = 5;

reg                        clk;
reg                        rst;
reg                        in;
wire                       out;

integer                    passed_tests_count;
integer                    failed_tests_count;
integer                    skipped_tests_count;
realtime                   start_capture;
realtime                   end_capture;
realtime                   all_tests_end;

reg                        data_out;

initial
begin
    clk                 <= 1'b1;
    data_out            <= 1'b0;
    passed_tests_count  <= 0;
    failed_tests_count  <= 0;
    skipped_tests_count <= 0;
end

always
begin
    #CLK_HALF_PERIOD clk = ~clk;
end

task check_state_one;
begin
    @(posedge clk);
    start_capture = $realtime;

    $display("\nTest check_state_one started. (Testing properly working state_1).");

    rst = 1'b1;
    in = 1'b0;

    repeat(5)@(posedge clk);
    rst = 1'b0;
    in = 1'b1;
    #2;

    @(posedge clk);
    #2;

    @(posedge clk);
    #2;
    if(out)
    begin
        $display("Test 'check_state_one' PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end else begin
        $display("Test 'check_state_one' FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end

    $display("Test check_state_one ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_state_one

task check_state_two;
begin
    @(posedge clk);
    start_capture = $realtime;

    $display("\nTest check_state_two started. (Testing properly working state_2).");

    rst = 1'b1;
    in = 1'b0;

    repeat(5)@(posedge clk);
    rst = 1'b0;
    in = 1'b0;
    #2;

    @(posedge clk);
    #2;

    @(posedge clk);
    #2;
    if(out)
    begin
        $display("Test 'check_state_two' PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end else begin
        $display("Test 'check_state_two' FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end

    $display("Test check_state_two ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_state_two

initial
begin
    $dumpvars;
    $timeformat(-9, 3, " ns", 10);
    $display("\nStarting tests...");

    check_state_one;
    check_state_two;

    if(passed_tests_count + failed_tests_count != TOTAL_TESTS)
    begin
        skipped_tests_count = TOTAL_TESTS - (passed_tests_count + failed_tests_count);
    end

    all_tests_end = $realtime;

    $display("\nTOTAL TESTS: %0d, PASSED: %0d, FAILED: %0d, SKIPPED: %0d.",
                TOTAL_TESTS, passed_tests_count, failed_tests_count, skipped_tests_count);
    $display("Time elapsed for all tests: %0t\n", all_tests_end);

    #15 $finish;
end //end of initial block

//instantiation of module 'mofsm'
mefsm mefsm (.clk(clk),
             .rst(rst),
             .a(in),
             .b(out));

endmodule //test
