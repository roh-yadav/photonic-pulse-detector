module basics_tb;

// declare signals
reg clk;
reg rst_n;
reg signal_in;
wire detected;

// connect to your module
basics dut (
    .clk(clk),
    .rst_n(rst_n),
    .signal_in(signal_in),
    .detected(detected)
);

// generate clock — toggles every 5ns
always #5 clk = ~clk;

// test sequence
initial begin
    // initialize
    clk = 0;
    rst_n = 0;
    signal_in = 0;

    // apply reset for 20ns
    #20 rst_n = 1;

    // send some pulses
    #10 signal_in = 1;  // pulse HIGH
    #20 signal_in = 0;  // pulse LOW
    #10 signal_in = 1;  // pulse HIGH again
    #15 signal_in = 0;  // pulse LOW

    // wait and finish
    #50 $finish;
end

// print 
initial begin
    $monitor("Time=%0t | rst_n=%b | signal_in=%b | detected=%b",
             $time, rst_n, signal_in, detected);
end

// save waveform file
initial begin
    $dumpfile("basics.vcd");
    $dumpvars(0, basics_tb);
end

endmodule
