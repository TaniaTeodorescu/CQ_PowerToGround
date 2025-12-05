`timescale 1ns / 1ps

module tb_rotor();
   
logic   clk;   
    
logic   [4:0]   index1_i    ;
logic   [4:0]   index2_i    ;   
logic   [4:0]   offset_i    ;   //rotor shift

logic   [4:0]   index1_o        ;
logic   [4:0]   index2_o        ;


rotor1 DUT(
.index1_i    (index1_i    ),
.index2_i    (index2_i    ),   
.offset_i    (offset_i    ),   //rotor shift

.index1_o       (index1_o   ) ,   
.index2_o       (index2_o   )
);
   
initial begin

    clk = 0;
    forever #5 clk = ~clk;

end  

initial begin

    index1_i  <= '0;
    index2_i  <= '0;
    offset_i  <= '0;
    
    repeat(5) @(posedge clk);
    offset_i  <= 5'd1;
    
    repeat(5) @(posedge clk);
    offset_i  <= 5'd2;
    
    repeat(5) @(posedge clk);
    index1_i  <= 5'd15;
    index2_i  <= 5'd15;
    offset_i  <= 5'd15;
    
    
    repeat(5) @(posedge clk);
    $stop();
    
end 
    
endmodule
