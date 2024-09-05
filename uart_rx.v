`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 23:07:18
// Design Name: 
// Module Name: uart_rx
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
module uart_rx (
    input wire clk,           // System clock
    input wire reset,         // Reset signal
    input wire rx,            // UART receiving line
    output reg [7:0] data_out,// Received data
    output reg rx_done        // Reception done flag
);

    parameter CLK_FREQ = 50000000;    // System clock frequency (50 MHz)
    parameter BAUD_RATE = 9600;       // Baud rate (9600)
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE; // Bit period calculation

    reg [15:0] bit_cnt;       // Bit counter
    reg [3:0] bit_idx;        // Index to track the received bits
    reg [7:0] rx_shift_reg;   // Shift register to hold received data
    reg rx_busy;              // Busy flag to indicate reception in progress
    reg rx_start;             // Start bit detection flag

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'd0;
            rx_done <= 1'b0;
            rx_busy <= 1'b0;
            rx_start <= 1'b0;
            bit_cnt <= 16'd0;
            bit_idx <= 4'd0;
        end else if (!rx_busy && !rx && !rx_start) begin
            // Detect start bit (low)
            rx_start <= 1'b1;
            bit_cnt <= 16'd0;
        end else if (rx_start) begin
            if (bit_cnt < BIT_PERIOD / 2) begin
                // Wait until halfway through the start bit
                bit_cnt <= bit_cnt + 16'd1;
            end else begin
                rx_start <= 1'b0;
                rx_busy <= 1'b1;
                bit_cnt <= 16'd0;
                bit_idx <= 4'd0;
            end
        end else if (rx_busy) begin
            if (bit_cnt < BIT_PERIOD - 1) begin
                bit_cnt <= bit_cnt + 16'd1;
            end else begin
                bit_cnt <= 16'd0;
                if (bit_idx < 4'd8) begin
                    // Receive data bits
                    rx_shift_reg <= {rx, rx_shift_reg[7:1]};
                    bit_idx <= bit_idx + 4'd1;
                end else if (bit_idx == 4'd8) begin
                    // Stop bit check
                    if (rx) begin
                        data_out <= rx_shift_reg;
                        rx_done <= 1'b1;
                    end
                    rx_busy <= 1'b0;
                end
            end
        end
    end
endmodule
