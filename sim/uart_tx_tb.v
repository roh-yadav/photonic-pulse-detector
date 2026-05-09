module uart_tx_tb;

reg        clk;
reg        rst_n;
reg        send;
reg  [7:0] data;
wire       tx;
wire       busy;

uart_tx dut (
    .clk(clk),
    .rst_n(rst_n),
    .send(send),
    .data(data),
    .tx(tx),
    .busy(busy)
);

always #5 clk = ~clk;

initial begin
    clk   = 0;
    rst_n = 0;
    send  = 0;
    data  = 8'd0;

    #20 rst_n = 1;

    // send byte 0x41 = 'A'
    #10 data = 8'h41;
        send = 1;
    #10 send = 0;

    // wait for transmission
    #500;

    // send byte 0x42 = 'B'
    #10 data = 8'h42;
        send = 1;
    #10 send = 0;

    #500 $finish;
end

initial begin
    $monitor("T=%0t | send=%b | data=%h | tx=%b | busy=%b",
             $time, send, data, tx, busy);
end

initial begin
    $dumpfile("uart_tx.vcd");
    $dumpvars(0, uart_tx_tb);
end

endmodule
