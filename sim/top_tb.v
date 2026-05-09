module top_tb;

reg  clk;
reg  rst_n;
reg  pulse_in;
wire tx;
wire busy;

top dut (
    .clk(clk),
    .rst_n(rst_n),
    .pulse_in(pulse_in),
    .tx(tx),
    .busy(busy)
);

always #5 clk = ~clk;

task send_pulse;
    input [15:0] width;
    begin
        pulse_in = 1;
        repeat(width) @(posedge clk);
        pulse_in = 0;
        repeat(10) @(posedge clk);
    end
endtask

initial begin
    clk      = 0;
    rst_n    = 0;
    pulse_in = 0;

    #20 rst_n = 1;

    // send 3 pulses of different widths
    send_pulse(10);
    send_pulse(20);
    send_pulse(5);

    // wait for UART to finish
    #2000;

    $finish;
end

initial begin
    $monitor("T=%0t | pulse=%b | tx=%b | busy=%b",
             $time, pulse_in, tx, busy);
end

initial begin
    $dumpfile("top.vcd");
    $dumpvars(0, top_tb);
end

endmodule
