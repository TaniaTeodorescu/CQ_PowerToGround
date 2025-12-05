
module VGA_Driver1(
    input   logic       clk_100MHz  ,
    input   logic       rst_n       ,
    
    output  logic       Hsync       ,
    output  logic       Vsync       ,
    output  logic [3:0] Red_o       ,
    output  logic [3:0] Green_o     ,
    output  logic [3:0] Blue_o          
    );
    
    logic               clk_pixel   ;   
    logic               reset_n     ;   
                               
    logic               hSync_wire  ;   
    logic               vSync_wire  ;   
                                
    logic   [9:0]       x_coord_wire;
    logic   [9:0]       y_coord_wire;   
    
    
    logic   [11:0]      read_color_wire  ;
    
          
    clk_gen_wrapper clk_gen_pix_inst1(
    .clk_100MHz (clk_100MHz),
    .clk_pixel  (clk_pixel),
    .reset_rtl_0(rst_n)
    );
  
  
    VGA_display_sigs VGA_display_sigs_inst1(
    .clk_pixel  ( clk_pixel    )  ,   //25.2 MHz clk
    .reset_n    ( rst_n      )  ,
                
    .hSync      ( hSync_wire   )  ,
    .vSync      ( vSync_wire   )  ,
                
    .x_coord    ( x_coord_wire )  ,
    .y_coord    ( y_coord_wire )
    );
    
    PixelMap_Mem PixelMap_Mem_inst1(
    .addr_x     ( x_coord_wire  ),
    .addr_y     ( y_coord_wire  ),
    .read_color ( read_color_wire  )
    );
    
    
    assign Hsync    = hSync_wire;
    assign Vsync    = vSync_wire;
    
    assign Red_o    = read_color_wire[11:08];
    assign Green_o  = read_color_wire[07:04];
    assign Blue_o   = read_color_wire[03:00];
    
endmodule
