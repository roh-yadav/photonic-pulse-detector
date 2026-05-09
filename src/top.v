// ============================================
// Photonic Pulse Detector — Top Module
// Connects all 4 modules
// Author: Rohit Yadav 
// ============================================

module top (
    input  wire clk,        // system clock
    input  wire rst_n,      // reset active low
    input  wire pulse_in,   // optical pulse input
    output wire tx,         // UART output to laptop
    output wire busy        // UART busy flag
);

    // internal wires connecting modules
    wire        rising_edge;
    wire        falling_edge;
    wire        pulse_active;
    wire [15:0] pulse_width;
    wire        width_valid;
    wire [15:0] pulse_freq;
    wire        freq_valid;
    wire        send;
    wire [7:0]  tx_data;

    // clock frequency — 100MHz for real chip
    wire [15:0] clk_freq = 16'd100;

    // Module 1 — Pulse Detector
    pulse_detector m1 (
        .clk(clk),
        .rst_n(rst_n),
        .pulse_in(pulse_in),
        .rising_edge(rising_edge),
        .falling_edge(falling_edge),
        .pulse_active(pulse_active)
    );

    // Module 2 — Pulse Width Counter
    pulse_width_counter m2 (
        .clk(clk),
        .rst_n(rst_n),
        .pulse_in(pulse_in),
        .pulse_width(pulse_width),
        .width_valid(width_valid)
    );

    // Module 3 — Frequency Counter
    freq_counter m3 (
        .clk(clk),
        .rst_n(rst_n),
        .pulse_in(pulse_in),
        .clk_freq(clk_freq),
        .pulse_freq(pulse_freq),
        .freq_valid(freq_valid)
    );

    // data selector — send width first then frequency
    assign send    = width_valid | freq_valid;
    assign tx_data = width_valid ? pulse_width[7:0] : pulse_freq[7:0];

    // Module 4 — UART Transmitter
    uart_tx m4 (
        .clk(clk),
        .rst_n(rst_n),
        .send(send),
        .data(tx_data),
        .tx(tx),
        .busy(busy)
    );

endmodule
