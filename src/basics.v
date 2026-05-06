module basics (
    input  wire clk,      // clock signal
    input  wire rst_n,    // reset - active low
    input  wire signal_in, // incoming optical pulse
    output reg  detected   // pulse detected output
);

// This runs on every rising clock edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset state
        detected <= 1'b0;
    end else begin
        // normal operation
        detected <= signal_in;
    end
end

endmodule
