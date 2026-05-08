module pulse_width_counter_tb;

reg         clk;
reg         rst_n;
reg         pulse_in;
wire [15:0] pulse_width;
wire        width_valid;

pulse_width_counter dut (
    .clk(clk),
    .rst_n(rst_n),
    .pulse_in(pulse_in),
    .pulse_width(pulse_width),
    .width_valid(width_valid)
);

always #5 clk = ~clk;

initial begin
    clk      = 0;
    rst_n    = 0;
    pulse_in = 0;

    #20 rst_n = 1;

    // pulse 1 — 10 cycles wide
    #10 pulse_in = 1;
    #100 pulse_in = 0;

    #30;

    // pulse 2 — 5 cycles wide
    #10 pulse_in = 1;
    #50 pulse_in = 0;

    #30;

    // pulse 3 — 20 cycles wide
    #10 pulse_in = 1;
    #200 pulse_in = 0;

    #50 $finish;
end

initial begin
    $monitor("T=%0t | pulse=%b | width=%0d | valid=%b",
             $time, pulse_in, pulse_width, width_valid);
end

initial begin
    $dumpfile("pulse_width.vcd");
    $dumpvars(0, pulse_width_counter_tb);
end

endmodule
