
module plugboard(
    input   logic   rstn,
    input   logic   clk ,
    
    input   logic           we_i            ,
    input   logic   [4:0]   index_switch1_i ,
    input   logic   [4:0]   index_switch2_i ,       
    
    output  logic           occupied_err    ,       //occupied err flag

    input   logic   [4:0]   current_index_i   ,   //this is index of current letter
    output  logic   [4:0]   transposed_index_o    //this is transposed letter output
    );
    
    // pulgboard switches letters in gropus of 2
    logic   [4:0]   memory [0:25];
    logic   [25:0]  occupied_slot;  //0 means free | 1 means occupied
    
    always_ff @(posedge clk or negedge rstn) begin
    
        if(~rstn) begin     //default => no interconnect between letters
            memory[00]  <=   5'd00;
            memory[01]  <=   5'd01;
            memory[02]  <=   5'd02;
            memory[03]  <=   5'd03;
            memory[04]  <=   5'd04;
            memory[05]  <=   5'd05;
            memory[06]  <=   5'd06;
            memory[07]  <=   5'd07;
            memory[08]  <=   5'd08;
            memory[09]  <=   5'd09;
            memory[10]  <=   5'd10;
            memory[11]  <=   5'd11;
            memory[12]  <=   5'd12;
            memory[13]  <=   5'd13;
            memory[14]  <=   5'd14;
            memory[15]  <=   5'd15;
            memory[16]  <=   5'd16;
            memory[17]  <=   5'd17;
            memory[18]  <=   5'd18;
            memory[19]  <=   5'd19;
            memory[20]  <=   5'd20;
            memory[21]  <=   5'd21;
            memory[22]  <=   5'd22;
            memory[23]  <=   5'd23;
            memory[24]  <=   5'd24;
            memory[25]  <=   5'd25;
            
            occupied_slot <= '0;
            occupied_err  <= '0;
        end else if(we_i) begin
            
            if(~occupied_slot[index_switch1_i] & ~occupied_slot[index_switch2_i]) begin    //if both locations are not occupied
        
                memory[index_switch1_i] <= index_switch2_i;
                memory[index_switch2_i] <= index_switch1_i;
                
                occupied_err <= '0;
            end else begin      //if one location is occupied
            
                occupied_err <= '1;
            
            end
        end else begin
        
            occupied_err <= '0;
        
        end
    
    end
    
    always_comb begin
    
        transposed_index_o = memory[current_index_i];
    
    end
    
endmodule
