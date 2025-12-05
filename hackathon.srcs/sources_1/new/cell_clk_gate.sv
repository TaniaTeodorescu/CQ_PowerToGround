`timescale 1ns/100ps

module cell_clk_gate(
	input logic 		clk		,
	input logic			clk_en	,
	input logic			rst_n	,
	
	output logic		gated_clk
	);
	
	//~clk is used as an enable signal for the latch to store data at input D
	//the latch output will be pulled to 0 only after a clk negedge, allowing the output to be clear of small pulses that can disrupt behavior 
	
	logic q_delay;
	logic q;
	logic d;
	
	always_latch begin
	
		if(~rst_n) 
			q = '0;
		else if(~clk)
			q = d;
	
	end
	
	assign d = clk_en;
	assign #1ns q_delay = q;
	
	assign gated_clk = (q_delay & clk);
	
	
	//assertion
	`ifdef ASSERT
	property p_clk_gating_check_g_clk;
		@(posedge clk) disable iff (!rst_n)
		($fell(clk_en) ##1 ~gated_clk) |-> (~gated_clk ##[*] clk_en);
	endproperty
	
	a_clk_gating_check_g_clk:	assert property (p_clk_gating_check_g_clk)
								else begin	$error("@%0t * 0.1ns	ERROR: clk signal on clk_enable off ",$time); $stop; end
	`endif
	
endmodule : cell_clk_gate
