`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 23:06:35
// Design Name: 
// Module Name: uart_tx
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


module uart_tx (
    input wire clk,          // System clock
    input wire reset,        // Reset signal
    input wire tx_start,     // Start transmission signal
    input wire [7:0] data_in,// Data to transmit
    output reg tx,           // UART transmission line
    output reg tx_done       // Transmission done flag
);

    parameter CLK_FREQ = 50000000;    // System clock frequency (50 MHz)
    parameter BAUD_RATE = 9600;       // Baud rate (9600)
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE; // Bit period calculation

    reg [15:0] bit_cnt;       // Bit counter
    reg [3:0] bit_idx;        // Index to track the transmitted bits
    reg [7:0] tx_shift_reg;   // Shift register to hold data
    reg tx_busy;              // Busy flag to indicate transmission in progress

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1;        // Idle state (line high)
            tx_done <= 1'b0;
            tx_busy <= 1'b0;
            bit_cnt <= 16'd0;
            bit_idx <= 4'd0;
        end else if (tx_start && !tx_busy) begin
            // Start transmission
            tx_shift_reg <= data_in;
            tx_busy <= 1'b1;
            tx_done <= 1'b0;
            bit_cnt <= 16'd0;
            bit_idx <= 4'd0;
            tx <= 1'b0;        // Start bit (low)
        end else if (tx_busy) begin
            if (bit_cnt < BIT_PERIOD - 1) begin
                bit_cnt <= bit_cnt + 16'd1;
            end else begin
                bit_cnt <= 16'd0;
                if (bit_idx < 4'd8) begin
                    // Transmit data bits
                    tx <= tx_shift_reg[0];
                    tx_shift_reg <= tx_shift_reg >> 1;
                    bit_idx <= bit_idx + 4'd1;
                end else if (bit_idx == 4'd8) begin
                    // Stop bit (high)
                    tx <= 1'b1;
                    bit_idx <= bit_idx + 4'd1;
                end else begin
                    // Transmission complete
                    tx_busy <= 1'b0;
                    tx_done <= 1'b1;
                end
            end
        end
    end
endmodule

