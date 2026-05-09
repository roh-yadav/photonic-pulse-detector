// ============================================
// Frequency Counter
// Counts how many pulses arrive per second
// Author: Rohit Yadav — TU Chemnitz
// Date: May 2026
// ============================================

module freq_counter (
    input  wire        clk,           // system clock
    input  wire        rst_n,         // reset active low
    input  wire        pulse_in,      // optical pulse input
    input  wire [15:0] clk_freq,      // clock frequency in Hz
    output reg  [15:0] pulse_freq,    // measured pulse frequency
    output reg         freq_valid     // high when measurement ready
);

    reg [15:0] pulse_count;   // counts pulses in current window
    reg [15:0] clk_count;     // counts clock cycles in window
    reg        pulse_prev;    // previous pulse state

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pulse_count <= 16'd0;
            clk_count   <= 16'd0;
            pulse_freq  <= 16'd0;
            freq_valid  <= 1'b0;
            pulse_prev  <= 1'b0;
        end else begin
            pulse_prev <= pulse_in;

            // count clock cycles
            clk_count <= clk_count + 1;

            // detect rising edge — count pulses
            if (!pulse_prev && pulse_in) begin
                pulse_count <= pulse_count + 1;
            end

            // when one second has passed
            if (clk_count >= clk_freq - 1) begin
                // save frequency measurement
                pulse_freq  <= pulse_count;
                freq_valid  <= 1'b1;
                // reset for next second
                clk_count   <= 16'd0;
                pulse_count <= 16'd0;
            end else begin
                freq_valid <= 1'b0;
            end
        end
    end

endmodule
