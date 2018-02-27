`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2018 11:37:31 AM
// Design Name: 
// Module Name: camera_top
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


module camera_top(
    input wire clk25,
    input wire start,
    input wire p_clock,
    input wire vsync,
    input wire href,
    input wire [7:0] p_data,
    output wire xclk,
    output wire [15:0] pixel_data,
    output wire sioc,
    output wire siod,
    output wire [7:0] gray_pixel,
    output wire frame_done_out,
    output wire pixel_valid_out,
    output wire gray_clk_out,
    output wire sccb_done
//    output wire done
    );
    
    wire clk_out;
    wire pixel_valid;
    wire frame_done;
    
    assign xclk = start ? clk25 : 1'b0;
    
    camera_configure config1
        (.clk(clk25),
         .start(start),
         .sioc(sioc),
        .siod(siod),
        .done(sccb_done)
         );
    
    camera_read cam_read1
        (.p_clock(p_clock),
         .vsync(vsync),
         .href(href),
         .p_data(p_data),
         .pixel_data(pixel_data),
         .pixel_valid(pixel_valid),
         .frame_done(frame_done),
         .clk_out(clk_out)    // half pclk
        );
    
    rgb2gray gray1
        (.clk_in(clk_out),
         .pixel_data_in(pixel_data),
         .pixel_valid(pixel_valid),
         .frame_done(frame_done),
        
         .gray(gray_pixel),
         .frame_done_out(frame_done_out),
         .pixel_valid_out(pixel_valid_out),
    //    output reg new_gray_pixel,
        .clk_out(gray_clk_out)
        );
endmodule
