`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 23:05:57
// Design Name: 
// Module Name: uart
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


module uart_full_duplex (
    input wire clk,            // System clock
    input wire reset,          // Reset signal
    input wire tx_start,       // Start signal for TX
    input wire [7:0] tx_data,  // Data to transmit
    input wire rx,             // UART receiving line
    output wire tx,            // UART transmission line
    output wire [7:0] rx_data, // Received data
    output wire tx_done,       // Transmission done flag
    output wire rx_done        // Reception done flag
);

    // Instantiate UART transmitter
    uart_tx transmitter (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .data_in(tx_data),
        .tx(tx),
        .tx_done(tx_done)
    );

    // Instantiate UART receiver
    uart_rx receiver (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(rx_data),
        .rx_done(rx_done)
    );
endmodule

