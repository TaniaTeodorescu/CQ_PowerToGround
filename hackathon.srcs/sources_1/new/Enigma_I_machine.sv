
module Enigma_I_machine(
    input   logic   clk     ,
    input   logic   rstn    ,
    
    input   logic   [1:0]   rotor_cfg_i     ,
    input   logic           index_i_valid   ,
    input   logic   [7:0]   index_i         ,
    output  logic   [4:0]   index_o 
    );
    
    
    //localparams
    localparam [4:0] RT1_INCR = 5'd16;
    localparam [4:0] RT2_INCR = 5'd04;
    localparam [4:0] RT3_INCR = 5'd21;
    
    //counters
    logic   [4:0]   cnt1;
    logic   [4:0]   cnt2;
    logic   [4:0]   cnt3;
    
    logic   [4:0]   limit1;
    logic   [4:0]   limit2;
    logic   [4:0]   limit3;
    
    //multiplex to map for order
    logic   [4:0]   offset1;
    logic   [4:0]   offset2;
    logic   [4:0]   offset3;
    
    //reflector declarations
    logic   [4:0]   reflcetor_index_i   ;
    logic   [4:0]   reflector_index_o   ;
    
    //plugboard delcarations
    logic           we_wire                 ;  
    logic   [4:0]   index_switch1_wire      ;  
    logic   [4:0]   index_switch2_wire      ;  
                                      
    logic           occupied_err_wire       ;  
                                      
    logic   [4:0]   current_index_wire      ; 
    logic   [4:0]   transposed_index_wire   ;
    
    //rotor1 declarations
    logic   [4:0]   index1_r1_wire_i    ;
    logic   [4:0]   index2_r1_wire_i    ;
    logic   [4:0]   offset_r1_wire_i    ;
                                
    logic   [4:0]   index1_r1_wire_o    ;
    logic   [4:0]   index2_r1_wire_o    ;
    
    //rotor2 declarations
    logic   [4:0]   index1_r2_wire_i    ;
    logic   [4:0]   index2_r2_wire_i    ;
    logic   [4:0]   offset_r2_wire_i    ;
                              
    logic   [4:0]   index1_r2_wire_o    ;
    logic   [4:0]   index2_r2_wire_o    ;
    
    //rotor3 declarations
    logic   [4:0]   index1_r3_wire_i    ;
    logic   [4:0]   index2_r3_wire_i    ;
    logic   [4:0]   offset_r3_wire_i    ;
                              
    logic   [4:0]   index1_r3_wire_o    ;
    logic   [4:0]   index2_r3_wire_o    ;
    
    
    //mux for mapping cnounters to true rotor
    always_comb begin
    
        case(rotor_cfg_i)
        
            2'b00: begin
                offset1 = cnt1;
                offset2 = cnt2;
                offset3 = cnt3;
                
                limit1  =  RT1_INCR;
                limit2  =  RT2_INCR;
                limit3  =  RT3_INCR;
                
            end
            
            2'b01: begin
                offset1 = cnt3;
                offset2 = cnt1;
                offset3 = cnt2;
                
                limit1  =  RT3_INCR;
                limit2  =  RT1_INCR;
                limit3  =  RT2_INCR;
            end
            
            2'b10: begin
                offset1 = cnt1;
                offset2 = cnt3;
                offset3 = cnt2;
                
                limit1  =  RT1_INCR;
                limit2  =  RT3_INCR;
                limit3  =  RT2_INCR;
            end
            
            default: begin
                offset1 = cnt1;
                offset2 = cnt3;
                offset3 = cnt2;
                
                limit1  =  RT1_INCR;
                limit2  =  RT2_INCR;
                limit3  =  RT3_INCR;
            end
            
        endcase
    
    end
    
    
    /*
        REFLECTOR DESIGN
        -> a lookup table 
        -> reflector transpozes for UKW-B       
                           
        A B C D E F G H I J K L M N O P Q R S T U V W X Y Z     
        Y R U H Q S L D P X N G O K M I E B F Z C W V J A T         
    */
 
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
            5'd11: reflector_index_o = 5'd06;
            //m -> o
            5'd12: reflector_index_o = 5'd14;
            //n -> k
            5'd13: reflector_index_o = 5'd10;
            //o -> m
            5'd14: reflector_index_o = 5'd12;
            //p -> i
            5'd15: reflector_index_o = 5'd08;
            //q -> e
            5'd16: reflector_index_o = 5'd04;
            //r -> b
            5'd17: reflector_index_o = 5'd01;
            //s -> f
            5'd18: reflector_index_o = 5'd05;
            //t -> z
            5'd19: reflector_index_o = 5'd25;
            //u -> c
            5'd20: reflector_index_o = 5'd02;
            //v -> w
            5'd21: reflector_index_o = 5'd22;
            //w -> v
            5'd22: reflector_index_o = 5'd21;
            //x -> j
            5'd23: reflector_index_o = 5'd09;
            //y -> a
            5'd24: reflector_index_o = 5'd00;
            //z -> t
            5'd25: reflector_index_o = 5'd19;
            
        endcase
    
    end
    
    plugboard plugboard_0(
    .rstn(rstn),
    .clk(clk) ,
    
    .we_i              (we_wire              ),
    .index_switch1_i   (index_switch1_wire   ),
    .index_switch2_i   (index_switch2_wire   ),       
                       
    .occupied_err      (occupied_err_wire    ),   //occupied err flag
                                            
    .current_index_i   (current_index_wire   ),  //this is index of current letter
    .transposed_index_o(transposed_index_wire)   //this is transposed letter output
    );
    
    rotor1 rotor1_inst0(
    .index1_i   (index1_r1_wire_i),
    .index2_i   (index2_r1_wire_i),   
    .offset_i   (offset_r1_wire_i),   //rotor1 shift
                
    .index1_o   (index1_r1_wire_o),   
    .index2_o   (index2_r1_wire_o)
    );
    
    rotor2 rotor2_inst0(
    .index1_i   (index1_r2_wire_i),
    .index2_i   (index2_r2_wire_i),   
    .offset_i   (offset_r2_wire_i),   //rotor2 shift
                         
    .index1_o   (index1_r2_wire_o),   
    .index2_o   (index2_r2_wire_o)
    );
    
    rotor3 rotor3_inst0(
    .index1_i   (index1_r3_wire_i),
    .index2_i   (index2_r3_wire_i),   
    .offset_i   (offset_r3_wire_i),   //rotor2 shift
                         
    .index1_o   (index1_r3_wire_o),   
    .index2_o   (index2_r3_wire_o)
    );
    
    always_ff @(posedge clk or negedge rstn) begin
    
        if(~rstn) begin
            cnt3 <= '0;
        end else if(index_i_valid) begin
            if(cnt3 == 26)begin
                cnt3 <= '0;
                
            end else 
                cnt3 <= cnt3 + 1'b1;
        end
    end
    
    assign  offset_r3_wire_i = cnt3;
    
    always_ff @(posedge clk or negedge rstn) begin
    
        if(~rstn) begin
            cnt2 <= '0;
        end else if(index_i_valid & cnt3 == limit3) begin   
        
            if(cnt2 == 26)begin
                cnt2 <= '0;
                
            end else 
                cnt2 <= cnt2 + 1'b1;
        end
    end
    
    assign  offset_r2_wire_i = cnt2;
    
    always_ff @(posedge clk or negedge rstn) begin
    
        if(~rstn) begin
            cnt1 <= '0;
        end else if(index_i_valid & cnt2 == limit2) begin   
        
            if(cnt1 == 26)begin
                cnt1 <= '0;
                
            end else 
                cnt1 <= cnt1 + 1'b1;
        end
    end
    
    assign  offset_r1_wire_i = cnt1;
    
    
    
    
endmodule
