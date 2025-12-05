
module rotor1(
    input   logic   [4:0]   index1_i    ,
    input   logic   [4:0]   index2_i    ,   
    input   logic   [4:0]   offset_i    ,   //rotor shift
    
    output  logic   [4:0]   index1_o    ,   
    output  logic   [4:0]   index2_o    
    );
    
    /*
        A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
        E K M F L G D Q V Z N T O W Y H X U S P A I B R C J
    
        turnover on Q
        notch on Y
    
    */
    
    logic   [4:0]   memory1 [0:25];
    logic   [4:0]   memory2 [0:25];
    logic   [4:0]   index1_calc_wire; 
    logic   [4:0]   index2_calc_wire; 
    
    always_comb begin
    
       
        memory1[00]  =   5'd04;   //a -> e
        memory1[01]  =   5'd10;   //b -> k
        memory1[02]  =   5'd12;   //c -> m
        memory1[03]  =   5'd05;   //d -> f
        memory1[04]  =   5'd11;   //e -> l
        memory1[05]  =   5'd06;   //f -> g
        memory1[06]  =   5'd03;   //g -> d
        memory1[07]  =   5'd16;   //h -> q
        memory1[08]  =   5'd21;   //i -> v
        memory1[09]  =   5'd25;   //j -> z
        memory1[10]  =   5'd13;   //k -> n
        memory1[11]  =   5'd19;   //l -> t
        memory1[12]  =   5'd14;   //m -> o
        memory1[13]  =   5'd22;   //n -> w
        memory1[14]  =   5'd24;   //o -> y
        memory1[15]  =   5'd07;   //p -> h
        memory1[16]  =   5'd23;   //q -> x
        memory1[17]  =   5'd20;   //r -> u
        memory1[18]  =   5'd18;   //s -> s
        memory1[19]  =   5'd15;   //t -> p
        memory1[20]  =   5'd00;   //u -> a
        memory1[21]  =   5'd08;   //v -> i
        memory1[22]  =   5'd01;   //w -> b
        memory1[23]  =   5'd20;   //x -> r  
        memory1[24]  =   5'd02;   //y -> c
        memory1[25]  =   5'd09;   //z -> j
    
    
        memory2[04]  =   5'd00;   //a <- e
        memory2[10]  =   5'd01;   //b <- k
        memory2[12]  =   5'd02;   //c <- m
        memory2[05]  =   5'd03;   //d <- f
        memory2[11]  =   5'd04;   //e <- l
        memory2[06]  =   5'd05;   //f <- g
        memory2[03]  =   5'd06;   //g <- d
        memory2[16]  =   5'd07;   //h <- q
        memory2[21]  =   5'd08;   //i <- v
        memory2[25]  =   5'd09;   //j <- z
        memory2[13]  =   5'd10;   //k <- n
        memory2[19]  =   5'd11;   //l <- t
        memory2[14]  =   5'd12;   //m <- o
        memory2[22]  =   5'd13;   //n <- w
        memory2[24]  =   5'd14;   //o <- y
        memory2[07]  =   5'd15;   //p <- h
        memory2[23]  =   5'd16;   //q <- x
        memory2[20]  =   5'd17;   //r <- u
        memory2[18]  =   5'd18;   //s <- s
        memory2[15]  =   5'd19;   //t <- p
        memory2[00]  =   5'd20;   //u <- a
        memory2[08]  =   5'd21;   //v <- i
        memory2[01]  =   5'd22;   //w <- b
        memory2[20]  =   5'd23;   //x <- r  
        memory2[02]  =   5'd24;   //y <- c
        memory2[09]  =   5'd25;   //z <- j
        
        
    end
    
    logic [4:0] index1_mapped;
    logic [4:0] index2_mapped;
    
    assign index1_calc_wire = (index1_i + offset_i) % 26;
    assign index1_mapped = memory1[index1_calc_wire];
    assign index1_o = (index1_mapped < offset_i) ? (26 + (index1_mapped - offset_i)) : (index1_mapped - offset_i);
    
    assign index2_calc_wire = (index2_i + offset_i) % 26;
    assign index2_mapped = memory2[index2_calc_wire];
    assign index2_o = (index2_mapped < offset_i) ? (26 + (index2_mapped - offset_i)) : (index2_mapped - offset_i);
    
endmodule
