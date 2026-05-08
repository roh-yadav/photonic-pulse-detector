// ============================================
// Pulse Width Counter
// Measures width of optical pulse in clock cycles
// Author: Rohit Yadav — TU Chemnitz
// Date: May 8 2026
// ============================================

module pulse_width_counter (
    input  wire        clk,          // system clock
    input  wire        rst_n,        // reset active low
    input  wire        pulse_in,     // optical pulse input
    output reg  [15:0] pulse_width,  // measured width in cycles
    output reg         width_valid   // high when measurement ready
);

    reg [15:0] counter;      // counts clock cycles
    reg        pulse_prev;   // previous pulse state

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter     <= 16'd0;
            pulse_width <= 16'd0;
            width_valid <= 1'b0;
            pulse_prev  <= 1'b0;
        end else begin
            pulse_prev <= pulse_in;

            if (pulse_in) begin
                // pulse is active — count cycles
                counter     <= counter + 1;
                width_valid <= 1'b0;
            end else if (pulse_prev && !pulse_in) begin
                // falling edge — pulse just ended
                // save the width and signal valid
                pulse_width <= counter;
                width_valid <= 1'b1;
                counter     <= 16'd0;
            end else begin
                // no pulse — clear valid after 1 cycle
                width_valid <= 1'b0;
            end
        end
    end

endmodule
