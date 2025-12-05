
module alphabet_mem(
    input   logic   [4:0]   index_i ,
    output  logic   [7:0]   letter_o 
    );
    
    
    logic   [7:0]   memory [0:25];
    
    always_comb begin
    
        memory[00]  =   8'd097;   //a
        memory[01]  =   8'd098;   //b
        memory[02]  =   8'd099;   //c
        memory[03]  =   8'd100;   //d
        memory[04]  =   8'd101;   //e
        memory[05]  =   8'd102;   //f
        memory[06]  =   8'd103;   //g
        memory[07]  =   8'd104;   //h
        memory[08]  =   8'd105;   //i
        memory[09]  =   8'd106;   //j
        memory[10]  =   8'd107;   //k
        memory[11]  =   8'd108;   //l
        memory[12]  =   8'd109;   //m
        memory[13]  =   8'd110;   //n
        memory[14]  =   8'd111;   //o
        memory[15]  =   8'd112;   //p
        memory[16]  =   8'd113;   //q
        memory[17]  =   8'd114;   //r
        memory[18]  =   8'd115;   //s
        memory[19]  =   8'd116;   //t
        memory[20]  =   8'd117;   //u
        memory[21]  =   8'd118;   //v
        memory[22]  =   8'd119;   //w
        memory[23]  =   8'd120;   //x
        memory[24]  =   8'd121;   //y
        memory[25]  =   8'd122;   //z
        
    end
    
    assign letter_o = memory[index];
    
endmodule
