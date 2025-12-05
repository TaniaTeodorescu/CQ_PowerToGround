
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
    
        memory1[00] = 5'd01;   // a -> b
        memory1[01] = 5'd03;   // b -> d
        memory1[02] = 5'd05;   // c -> f
        memory1[03] = 5'd07;   // d -> h
        memory1[04] = 5'd09;   // e -> j
        memory1[05] = 5'd11;   // f -> l
        memory1[06] = 5'd02;   // g -> c
        memory1[07] = 5'd15;   // h -> p
        memory1[08] = 5'd17;   // i -> r
        memory1[09] = 5'd19;   // j -> t
        memory1[10] = 5'd23;   // k -> x
        memory1[11] = 5'd21;   // l -> v
        memory1[12] = 5'd25;   // m -> z
        memory1[13] = 5'd13;   // n -> n
        memory1[14] = 5'd24;   // o -> y
        memory1[15] = 5'd04;   // p -> e
        memory1[16] = 5'd08;   // q -> i
        memory1[17] = 5'd14;   // r -> o
        memory1[18] = 5'd16;   // s -> q
        memory1[19] = 5'd20;   // t -> u
        memory1[20] = 5'd18;   // u -> s
        memory1[21] = 5'd00;   // v -> a
        memory1[22] = 5'd10;   // w -> k
        memory1[23] = 5'd06;   // x -> g  
        memory1[24] = 5'd12;   // y -> m
        memory1[25] = 5'd22;   // z -> w
    
    
        memory2[01]  =   5'd00;   //a <- b
        memory2[03]  =   5'd01;   //b <- d
        memory2[05]  =   5'd02;   //c <- f
        memory2[07]  =   5'd03;   //d <- h
        memory2[09]  =   5'd04;   //e <- j
        memory2[11]  =   5'd05;   //f <- l
        memory2[02]  =   5'd06;   //g <- c
        memory2[15]  =   5'd07;   //h <- p
        memory2[17]  =   5'd08;   //i <- r
        memory2[19]  =   5'd09;   //j <- t
        memory2[23]  =   5'd10;   //k <- x
        memory2[21]  =   5'd11;   //l <- v
        memory2[25]  =   5'd12;   //m <- z
        memory2[13]  =   5'd13;   //n <- n
        memory2[24]  =   5'd14;   //o <- y
        memory2[04]  =   5'd15;   //p <- e
        memory2[08]  =   5'd16;   //q <- i
        memory2[14]  =   5'd17;   //r <- o
        memory2[16]  =   5'd18;   //s <- q
        memory2[20]  =   5'd19;   //t <- u
        memory2[18]  =   5'd20;   //u <- s
        memory2[00]  =   5'd21;   //v <- a
        memory2[10]  =   5'd22;   //w <- k
        memory2[06]  =   5'd23;   //x <- g  
        memory2[12]  =   5'd24;   //y <- m
        memory2[22]  =   5'd25;   //z <- w
        
        
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
