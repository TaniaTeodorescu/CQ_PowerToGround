
module rotor2(
    input   logic   [4:0]   index1_i    ,
    input   logic   [4:0]   index2_i    ,   
    input   logic   [4:0]   offset_i    ,   //rotor shift
    
    output  logic   [4:0]   index1_o    ,   
    output  logic   [4:0]   index2_o    
    );
    
    /*
        A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
        AJDKSI	R	U	X	B	L	H	W	T	M	C	Q	G	Z	N	P	Y	F	V	O	E
    
        turnover on Q
        notch on Y
    
    */
    
    logic   [4:0]   memory1 [0:25];
    logic   [4:0]   memory2 [0:25];
    logic   [4:0]   index1_calc_wire; 
    logic   [4:0]   index2_calc_wire; 
    
    always_comb begin
    
        memory1[00]  =  5'd00;   // a -> a
        memory1[01]  =  5'd09;   // b -> j
        memory1[02]  =  5'd03;   // c -> d
        memory1[03]  =  5'd10;   // d -> k
        memory1[04]  =  5'd18;   // e -> s
        memory1[05]  =  5'd08;   // f -> i
        memory1[06]  =  5'd17;   // g -> r
        memory1[07]  =  5'd20;   // h -> u
        memory1[08]  =  5'd23;   // i -> x
        memory1[09]  =  5'd01;   // j -> b
        memory1[10]  =  5'd11;   // k -> l
        memory1[11]  =  5'd07;   // l -> h
        memory1[12]  =  5'd22;   // m -> w
        memory1[13]  =  5'd19;   // n -> t
        memory1[14]  =  5'd12;   // o -> m
        memory1[15]  =  5'd02;   // p -> c
        memory1[16]  =  5'd16;   // q -> q
        memory1[17]  =  5'd06;   // r -> g
        memory1[18]  =  5'd25;   // s -> z
        memory1[19]  =  5'd13;   // t -> n
        memory1[20]  =  5'd15;   // u -> p
        memory1[21]  =  5'd24;   // v -> y
        memory1[22]  =  5'd05;   // w -> f
        memory1[23]  =  5'd21;   // x -> v  
        memory1[24]  =  5'd14;   // y -> o
        memory1[25]  =  5'd04;   // z -> e
    
    
        memory2[00]  =   5'd00;   //a <- a
        memory2[09]  =   5'd01;   //b <- j
        memory2[03]  =   5'd02;   //c <- d
        memory2[10]  =   5'd03;   //d <- k
        memory2[18]  =   5'd04;   //e <- s
        memory2[08]  =   5'd05;   //f <- i
        memory2[17]  =   5'd06;   //g <- r
        memory2[20]  =   5'd07;   //h <- u
        memory2[23]  =   5'd08;   //i <- x
        memory2[01]  =   5'd09;   //j <- b
        memory2[11]  =   5'd10;   //k <- l
        memory2[07]  =   5'd11;   //l <- h
        memory2[22]  =   5'd12;   //m <- w
        memory2[19]  =   5'd13;   //n <- t
        memory2[12]  =   5'd14;   //o <- m
        memory2[02]  =   5'd15;   //p <- c
        memory2[16]  =   5'd16;   //q <- q
        memory2[06]  =   5'd17;   //r <- g
        memory2[25]  =   5'd18;   //s <- z
        memory2[13]  =   5'd19;   //t <- n
        memory2[15]  =   5'd20;   //u <- p
        memory2[24]  =   5'd21;   //v <- y
        memory2[05]  =   5'd22;   //w <- f
        memory2[21]  =   5'd23;   //x <- v  
        memory2[14]  =   5'd24;   //y <- o
        memory2[04]  =   5'd25;   //z <- e
        
        
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
