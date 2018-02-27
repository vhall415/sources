`timescale 1ns / 1ps
//`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2017 02:28:27 PM
// Design Name: 
// Module Name: 565_To_Grayscale
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module takes 565 RGB and converts it to Grayscale. It does this using the following scheme
//              Assume the following 5 bits for R: (10101) this becomes (10101101) when it is taken from 5 bits to 8 bits.
//              This is not a linear transformation but it works.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module rgb2gray (
    input wire clk_in,
    input wire [15:0] pixel_data_in,
    input wire pixel_valid,
    input wire frame_done,
    
    output reg [7:0] gray,
    output wire frame_done_out,
    output wire pixel_valid_out,
//    output reg new_gray_pixel,
    output wire clk_out
    );
    
    localparam INIT = 0;
    localparam RUN = 1;
    
    reg state = INIT;
    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;
//    reg new_pixelr;
//    reg new_pixelf;
//    reg read_enr = 0;
//    reg read_enf = 0;
    
    reg [1:0] count = 0;
    
    assign clk_out = clk_in;
    assign frame_done_out = frame_done;
    assign pixel_valid_out = pixel_valid;
//    assign new_pixel = new_pixelr ^ new_pixelf;
//    assign read_en = read_enr & read_enf;
    
    // Apply MSB to top bits
    assign red = {pixel_data_in[15:11], pixel_data_in[15:13]};
    // Append MSB of R pixel Data to LSB of Red
//    assign red[2:0] = 0;
    
    // Now do the green
    assign green = {pixel_data_in[10:5], pixel_data_in[10:9]};
//    assign green[1:0] = 0;
    
    // Now the blue
    assign blue = {pixel_data_in[5:0], pixel_data_in[5:3]};
//    assign blue[2:0] = 0;

//    assign red = pixel_data_in[15:11];
//    assign green = pixel_data_in[10:5];
//    assign blue = pixel_data_in[4:0];
        
    always @(negedge clk_in) begin // read posedge
        case(state)
            INIT: begin
                gray <= 0;
                state <= RUN;
//                new_pixelr <= 0;
            end
            
            RUN: begin
                if(pixel_valid && ~frame_done) begin
                    gray <= (pixel_data_in[7:0]);//((red + green + blue) / 3);//red;//
                end
            end
            
            default: begin
                gray <= 0;
                state <= RUN;
            end
        endcase
    end
    
//    always @(negedge clk_in) begin
//            if(count == 0) begin
//                read_enf <= 1;
//            end
//            else begin
//                gray <= ((red + blue + green) / 3);
//                read_enf <= 0;
//             end
////        if(read_enr == 1) begin
//            read_enf <= 0;
////            gray <= ((red + blue + green) / 3);
//            new_pixelf <= 0;
//        end
//        else begin
//            new_pixelf <= 1;
//        end
//    end
endmodule 