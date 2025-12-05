
module blinky(
    input   logic   rst,
    input   logic   clk,
    input   logic   on,
    
    output  logic   out
    );
    
    always_ff @(posedge clk) begin
    
        if(rst)
            out <= '0;
        else if(on)
            out <= '1;  
           
    end
    
endmodule
