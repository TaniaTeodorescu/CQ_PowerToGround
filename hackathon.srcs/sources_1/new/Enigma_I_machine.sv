
module Enigma_I_machine(

    );
    
    /*
    
        REFLECTOR DESIGN
        -> a lookup table
        
    */
    
    logic   [4:0]   reflcetor_index_i   ;
    logic   [4:0]   reflector_index_o   ;
    
    // reflector transpozes for UKW-B
    // A B C D E F G H I J K L MNOPQRSTUVWXYZ
    // Y R U H Q S L D P X N G OKMIEBFZCWVJAT
    
    always_comb begin
    
        case(reflcetor_index_i)
            //a -> y
            5'd00: reflector_index_o = 5'd24;
            
            //b -> r
            5'd01: reflector_index_o = 5'd17;
            
            //c -> u
            5'd02: reflector_index_o = 5'd20;
            
            //d -> h
            5'd03: reflector_index_o = 5'd07;
            
            //e -> q
            5'd04: reflector_index_o = 5'd16;
            
            //f -> s
            5'd05: reflector_index_o = 5'd18;
            
            //g -> l
            5'd06: reflector_index_o = 5'd11;
            
            //h -> d
            5'd07: reflector_index_o = 5'd03;
            
            //i -> p
            5'd08: reflector_index_o = 5'd15; 
            
            //j -> x
            5'd09: reflector_index_o = 5'd23;
            
            //k -> n
            5'd10: reflector_index_o = 5'd13;
            
            //l -> g
            5'd11: reflector_index_o = 5'd13;
            
        endcase
    
    end
    
    
endmodule
