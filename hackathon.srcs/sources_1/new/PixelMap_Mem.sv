

/*

This module is a simplified memory that will be used to draw recursive patterns.
The memory itself is async read only.
The adress are the x-y coordinates of the current pixel. 

*/
module PixelMap_Mem(
    input   logic   [9:0]   addr_x,
    input   logic   [9:0]   addr_y,
    output  logic   [11:0]  read_color
    );
    
    //wires and regs declarations
    logic   [639:0]     mem [0:2];    //effective memory
    logic   [39:0]      pattern0;
    logic   [79:0]      pattern1;
    logic   [159:0]     pattern2;
    logic               draw_en;    //if the current interval is within active drawing borders this signal will be 1
    
    //colors in 12 bit format
    localparam BLACK    = 12'h000;
    localparam RED      = 12'hf00;
    localparam GREEN    = 12'h0f0;
    localparam BLUE     = 12'h00f;
    localparam ORANGE   = 12'hf90;
    localparam YELLOW   = 12'hff0;
    localparam PINK     = 12'hfcc;
    
    //active drawing border limits
    localparam  H_ACTIVE    = 10'd639;
    localparam  V_ACTIVE    = 10'd479;
    
    //pattern generation for a test picture
    assign  pattern0 = { {20{1'b1}}, {20{1'b0}}};
    assign  pattern1 = { {40{1'b1}}, {40{1'b0}}};
    assign  pattern2 = { {80{1'b1}}, {80{1'b0}}};
    
    assign mem[0] = {16{pattern0}};     //not used now
    assign mem[1] = { 8{pattern1}};     //not used now
    assign mem[2] = { 4{pattern2}};
    
    
    //decideing if current pixel is in drawing area
    assign draw_en = (addr_x <= H_ACTIVE & addr_y <= V_ACTIVE);
    
    
    //drawing logic
    //3 rows of 2 alternating colored boxes of different sizes
    //rows are 160 pixels tall
    always_comb begin
    
        if(~draw_en)                    //if outside drawing border send BLACK
            read_color = BLACK;
            
        else begin
        
            if(addr_y < 10'd160)        //first row
                read_color = (mem[0][addr_x] == 1'b1) ? PINK : YELLOW;
            else if(addr_y < 10'd320)   //second row
                read_color = (mem[1][addr_x] == 1'b1) ? BLUE : ORANGE;
            else begin                  //third row
                read_color = (mem[2][addr_x] == 1'b1) ? GREEN : RED;
            end
        end
    
    end
    
    
endmodule
