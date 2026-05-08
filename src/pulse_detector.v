// ===========================================
// Photonic Pulse Detector
// Detects rising and falling edges of optical pulses
// ============================================

module pulse_detector (
    input  wire clk,          // system clock
    input  wire rst_n,        // reset active low
    input  wire pulse_in,     // optical pulse input
    output reg  rising_edge,  // high for 1 cycle on rising edge
    output reg  falling_edge, // high for 1 cycle on falling edge
    output reg  pulse_active  // high while pulse is high
);

    // store previous state of pulse
    reg pulse_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset all outputs
            pulse_prev    <= 1'b0;
            rising_edge   <= 1'b0;
            falling_edge  <= 1'b0;
            pulse_active  <= 1'b0;
        end else begin
            // store current state for next cycle
            pulse_prev <= pulse_in;

            // detect rising edge — was 0 now 1
            rising_edge <= (~pulse_prev) & pulse_in;

            // detect falling edge — was 1 now 0
            falling_edge <= pulse_prev & (~pulse_in);

            // pulse is active when input is high
            pulse_active <= pulse_in;
        end
    end

endmodule
