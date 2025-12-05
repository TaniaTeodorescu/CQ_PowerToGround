`timescale 1ns / 1ps

module tb_enigma();

logic   clk     ;                
logic   rstn    ;                
                                 
logic   [1:0]   rotor_cfg_i     ;
logic           index_i_valid   ;
logic   [4:0]   index_i         ;
logic   [4:0]   index_o         ;



Enigma_I_machine    DUT(
.clk     (clk ),
.rstn    (rstn ),

.rotor_cfg_i    (rotor_cfg_i      ),
.index_i_valid  (index_i_valid    ),
.index_i        (index_i          ),
.index_o        (index_o          )
);


initial begin

    clk = 0;
    forever #5 clk = ~clk;

end


initial begin

    rstn            <= '0;
    rotor_cfg_i     <= '0;
    index_i_valid   <= '0;
    index_i         <= '0;
    
    #13;
    rstn <= 1;

end


initial begin

    @(posedge rstn);
    @(posedge clk);
    
    repeat(5) @(posedge clk);
    index_i_valid <= '1;
    @(posedge clk);
    index_i_valid <= '0;
    
    repeat(5) @(posedge clk);
    index_i_valid <= '1;
    @(posedge clk);
    index_i_valid <= '0;
    
    repeat(5) @(posedge clk);
    index_i_valid <= '1;
    @(posedge clk);
    index_i_valid <= '0;
    
    repeat(5) @(posedge clk);
    $stop();
    
    
end

endmodule
