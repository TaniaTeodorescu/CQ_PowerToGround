`timescale 1ns/100ps

module baudrate_gen(		
	input	logic			clk_i	,
	input	logic			rst_n_i	,
	
	input	logic	[9:0]	period_limit_value	, //this needs to be 1 less than the value you want to reach because counter starts at 0
	
	input 	logic			enable	,
	output	logic			half_bclk_o		,
	output	logic			period_bclk_o	,
	output	logic			reset_transmission
	);
	
	logic			half_pulse_o;
	logic			period_pulse_o;

	cell_clk_gate full_bclk_cell_clk_gate(
	.clk	 (clk_i),
	.clk_en  (period_pulse_o),
	.rst_n   (rst_n_i),
	
	.gated_clk	(period_bclk_o)
	);
	
	cell_clk_gate half_bclk_cell_clk_gate(
	.clk	 (clk_i),
	.clk_en  (half_pulse_o),
	.rst_n   (rst_n_i),
	
	.gated_clk	(half_bclk_o)
	);
		
	logic	[9:0]	counter;
	
	
	always_ff @(posedge clk_i or negedge rst_n_i) begin
	
		if(~rst_n_i)
			counter <= '0;
		else if (~enable)
			counter <= '0;
		else if (counter > period_limit_value)
			counter <= '0;
		else 
			counter <= counter + 1'b1;
	
	end
	
	/*
	always_ff @(posedge clk_i or negedge rst_n_i) begin
	
		if(~rst_n_i)
			counter <= '0;
		else if (enable) begin
		
			if (counter > period_limit_value)
				counter <= '0;
			
			else
				counter <= counter + 1'b1;
			
		end else begin
			
			
		
		end
		
	
	end
	*/
	//negedge pulse
	always_ff @(posedge clk_i or negedge rst_n_i) begin
	
		if(~rst_n_i)
			half_pulse_o <= '0;
		else if(enable) begin 
			if (counter == ((period_limit_value >> 1) ))
				half_pulse_o <= '1;
			else 
				half_pulse_o <= '0;
		end
	end

	//posedge pulse
	always_ff @(posedge clk_i or negedge rst_n_i) begin
	
		if(~rst_n_i)
			period_pulse_o <= '0;
		else if(enable) begin
			if (counter == '0/*period_limit_value*/)
				period_pulse_o <= '1;
			else 
				period_pulse_o <= '0;
		end
	end
	
	always_ff @(posedge clk_i or negedge rst_n_i) begin
	
		if(~rst_n_i)
			reset_transmission <= '1;
		else if(~enable)
			reset_transmission <= '1;
		else if(half_pulse_o)
			reset_transmission <= '0;
	
	end

endmodule : baudrate_gen
