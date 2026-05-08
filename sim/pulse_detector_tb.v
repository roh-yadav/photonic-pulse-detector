module pulse_detector_tb;

reg clk;
reg rst_n;
reg pulse_in;
wire rising_edge;
wire falling_edge;
wire pulse_active;

// connect to module
pulse_detector dut (
    .clk(clk),
    .rst_n(rst_n),
    .pulse_in(pulse_in),
    .rising_edge(rising_edge),
    .falling_edge(falling_edge),
    .pulse_active(pulse_active)
);

// clock generation — 10ns period = 100MHz
always #5 clk = ~clk;

initial begin
    // initialize
    clk      = 0;
    rst_n    = 0;
    pulse_in = 0;

    // release reset
    #20 rst_n = 1;

    // pulse 1 — short pulse
    #10 pulse_in = 1;
    #30 pulse_in = 0;

    // gap between pulses
    #20;

    // pulse 2 — longer pulse
    #10 pulse_in = 1;
    #60 pulse_in = 0;

    // gap
    #20;

    // pulse 3 — very short pulse
    #10 pulse_in = 1;
    #10 pulse_in = 0;

    #50 $finish;
end

initial begin
    $monitor("T=%0t | in=%b | rise=%b | fall=%b | active=%b",
             $time, pulse_in, rising_edge, falling_edge, pulse_active);
end

initial begin
    $dumpfile("pulse_detector.vcd");
    $dumpvars(0, pulse_detector_tb);
end

endmodule
