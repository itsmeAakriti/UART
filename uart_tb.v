`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 23:08:31
// Design Name: 
// Module Name: uart_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb_uart_full_duplex;

    // Clock and reset
    reg clk;
    reg reset;

    // UART signals
    reg tx_start;
    reg [7:0] tx_data;
    wire tx;
    wire [7:0] rx_data;
    wire tx_done;
    wire rx_done;

    // Instantiate the full duplex UART module
    uart_full_duplex uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .rx(tx),
        .tx(tx),
        .rx_data(rx_data),
        .tx_done(tx_done),
        .rx_done(rx_done)
    );

    // Clock generation (50 MHz)
    always #10 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        clk = 1'b0;
        reset = 1'b1;
        tx_start = 1'b0;
        tx_data = 8'b0;
        
        // Release reset after 50 ns
        #50;
        reset = 1'b0;

        // Test case 1: Send 8'hA5
        #100;
        tx_data = 8'hA5;    // Data to send (0xA5)
        tx_start = 1'b1;    // Trigger transmission
        #20;
        tx_start = 1'b0;    // Clear the start signal

        // Wait for transmission and reception to complete
        wait(tx_done);
        wait(rx_done);

        // Check if the received data matches the transmitted data
        if (rx_data == 8'hA5) begin
            $display("Test 1 Passed: Sent = %h, Received = %h", tx_data, rx_data);
        end else begin
            $display("Test 1 Failed: Sent = %h, Received = %h", tx_data, rx_data);
        end

        // Test case 2: Send 8'h3C
        #100;
        tx_data = 8'h3C;    // Data to send (0x3C)
        tx_start = 1'b1;    // Trigger transmission
        #20;
        tx_start = 1'b0;    // Clear the start signal

        // Wait for transmission and reception to complete
        wait(tx_done);
        wait(rx_done);

        // Check if the received data matches the transmitted data
        if (rx_data == 8'h3C) begin
            $display("Test 2 Passed: Sent = %h, Received = %h", tx_data, rx_data);
        end else begin
            $display("Test 2 Failed: Sent = %h, Received = %h", tx_data, rx_data);
        end

        // Test case 3: Send 8'hFF
        #100;
        tx_data = 8'hFF;    // Data to send (0xFF)
        tx_start = 1'b1;    // Trigger transmission
        #20;
        tx_start = 1'b0;    // Clear the start signal

        // Wait for transmission and reception to complete
        wait(tx_done);
        wait(rx_done);

        // Check if the received data matches the transmitted data
        if (rx_data == 8'hFF) begin
            $display("Test 3 Passed: Sent = %h, Received = %h", tx_data, rx_data);
        end else begin
            $display("Test 3 Failed: Sent = %h, Received = %h", tx_data, rx_data);
        end

        // Finish simulation
        #100;
        $finish;
    end
endmodule
