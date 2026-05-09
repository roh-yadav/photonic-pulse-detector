// ============================================
// UART Transmitter
// Sends pulse data to laptop at 9600 baud
// Author: Rohit Yadav
// ============================================

module uart_tx (
    input  wire        clk,        // system clock
    input  wire        rst_n,      // reset active low
    input  wire        send,       // trigger to send data
    input  wire [7:0]  data,       // 8-bit data to send
    output reg         tx,         // UART transmit pin
    output reg         busy        // high while transmitting
);

    // UART parameters
    // For 100MHz clock, 9600 baud:
    // clk_per_bit = 100MHz / 9600 = 10416
    // For simulation we use smaller value
    parameter CLK_PER_BIT = 16'd10;

    // state machine states
    parameter IDLE  = 2'd0;
    parameter START = 2'd1;
    parameter DATA  = 2'd2;
    parameter STOP  = 2'd3;

    reg [1:0]  state;
    reg [15:0] clk_count;
    reg [2:0]  bit_index;
    reg [7:0]  data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            tx        <= 1'b1;  // UART idle = HIGH
            busy      <= 1'b0;
            clk_count <= 16'd0;
            bit_index <= 3'd0;
            data_reg  <= 8'd0;
        end else begin
            case (state)

                IDLE: begin
                    tx   <= 1'b1;  // keep line HIGH
                    busy <= 1'b0;
                    if (send) begin
                        // start transmission
                        data_reg  <= data;
                        state     <= START;
                        busy      <= 1'b1;
                        clk_count <= 16'd0;
                    end
                end

                START: begin
                    tx <= 1'b0;  // start bit = LOW
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 16'd0;
                        bit_index <= 3'd0;
                        state     <= DATA;
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_index];  // send each bit
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 16'd0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1;  // stop bit = HIGH
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 16'd0;
                        state     <= IDLE;
                        busy      <= 1'b0;
                    end
                end

            endcase
        end
    end

endmodule
