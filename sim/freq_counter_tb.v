module freq_counter_tb;

reg         clk;
reg         rst_n;
reg         pulse_in;
reg  [15:0] clk_freq;
wire [15:0] pulse_freq;
wire        freq_valid;

freq_counter dut (
    .clk(clk),
    .rst_n(rst_n),
    .pulse_in(pulse_in),
    .clk_freq(clk_freq),
    .pulse_freq(pulse_freq),
    .freq_valid(freq_valid)
);

// clock — 10ns period
always #5 clk = ~clk;

// task to send one pulse
task send_pulse;
    begin
        pulse_in = 1;
        #20;
        pulse_in = 0;
        #30;
    end
endtask

initial begin
    clk      = 0;
    rst_n    = 0;
    pulse_in = 0;
    clk_freq = 16'd20;

    #20 rst_n = 1;

    // send 5 pulses
    send_pulse;
    send_pulse;
    send_pulse;
    send_pulse;
    send_pulse;

    // wait for measurement window
    #300;

    $finish;
end

initial begin
    $monitor("T=%0t | pulse=%b | freq=%0d | valid=%b",
             $time, pulse_in, pulse_freq, freq_valid);
end

initial begin
    $dumpfile("freq_counter.vcd");
    $dumpvars(0, freq_counter_tb);
end

endmodule
