/*

    design for resolution 640x480 @ 60Hz refresh rate

*/
module VGA_display_sigs(
    input   logic       clk_pixel   ,   //25.2 MHz clk
    input   logic       reset_n     ,
    
    output  logic       hSync       ,
    output  logic       vSync       ,
    
    output  logic   [9:0]        x_coord  ,
    output  logic   [9:0]        y_coord  
    );
    
    //horizontal params are counted in pixels
    /*
    
    H_TOTAL     = 799      is ending position => -1     
    H_ACTIVE    = 639      is ending position => -1     
    H_FRONTP    = 16       is interval => remains the same
    H_SYNC      = 96       is interval => ramains the same
    H_BACKP     = 48       is interval => remains the same
    
    eliminate intervals and use only start and end positions in order to use only constants
    
    H_SYNC_START = H_ACTIVE + H_FRONTP = 639 + 16 = 655
    H_BACKP_START = H_SYNC_START + H_SYNC = 655 + 96 = 751
    */
    localparam  H_TOTAL         = 799;  
    //localparam  H_ACTIVE        = 639;  not used 
    localparam  H_SYNC_START    = 655;   
    localparam  H_BACKP_START   = 751;   
    
    //vertical params are counted in lines (completed horizontal periods)
    /*
    
    V_TOTAL     = 524;  //is ending position => -1     
    V_ACTIVE    = 479;  //is ending position => -1     
    V_FRONTP    = 10;   //is interval => remains the same
    V_SYNC      = 2;    //is interval => ramains the same
    V_BACKP     = 33;   //is interval => remains the same
    
    eliminate intervals and use only start and end positions in order to use only constants
    
    V_SYNC_START = V_ACTIVE + V_FRONTP = 479 + 10 = 489
    V_BACKP_START = V_SYNC_START + V_SYNC = 489 + 2 = 491
    */
    localparam  V_TOTAL         = 524;  
    //localparam  V_ACTIVE        = 479;  not used
    localparam  V_SYNC_START    = 489;    
    localparam  V_BACKP_START   = 491;   
              
              
    //counters instantiation
    logic   [9:0]   h_counter;
    logic   [9:0]   v_counter;          
              
    //horizontal counter
    always_ff @(posedge clk_pixel or negedge reset_n) begin
    
        if(!reset_n) begin
            h_counter <= '0;
        end else if (h_counter == H_TOTAL) begin    // resets when it reaches final pixel on line
            h_counter <= '0;
        end else begin                              // increments on every clk_pixel
            h_counter <= h_counter + 1'b1;
        end
    
    end      
    
    //vertical counter
    always_ff @(posedge clk_pixel or negedge reset_n) begin
    
        if(!reset_n) begin
            v_counter <= '0;
        end else if (h_counter == H_TOTAL) begin
            if (v_counter == V_TOTAL) begin             // resets when it reaches final line
                v_counter <= '0;
            end else begin    // increments every hSync period
                v_counter <= v_counter + 1'b1;
            end
        end
    end
    
    // hSync and vSync signal generation, pulse is active low for VGA PMOD
    assign hSync = ~(h_counter > H_SYNC_START & h_counter <= H_BACKP_START);
    assign vSync = ~(v_counter > V_SYNC_START & v_counter <= V_BACKP_START);
    
    // output the coords of current pixel from counter
    assign x_coord = h_counter;
    assign y_coord = v_counter;           
    
    
endmodule
