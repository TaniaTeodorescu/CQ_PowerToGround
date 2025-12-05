`timescale 1ns/100ps

module uart_2(

	input	logic			clk		,
	input	logic			rst_n	,
	
	input	logic			dtr		,
	input	logic			rx		,
	output	logic			tx		,
	
	input	logic			data_vld_dcd	,
	input	logic	[7:0]	data_rd			,	
	output	logic			dtr_o			,
	output	logic			data_vld_uart	,
	output	logic	[7:0]	data_uart_wr	

	);

	logic bclk_posedge;
	logic bclk_negedge;
	
	logic	rx_ff1	;
	logic	dtr_ff1	;
	
	logic	rx_ff2	;
	logic	dtr_ff2	;
		
	logic	rx_sync	;
	logic	dtr_sync;

	logic	rx_sync_delay;
	logic	rx_falledge;
	
	logic 	bclk_enable;
	logic 	reset_transmission;
	
	
	//baudrate generator	115,200 kHz		actual frequency is 115,207 kHz => absolute relative error is 0.00607%
	baudrate_gen i_baudrate_gen(		
	.clk_i		(clk),
	.rst_n_i	(rst_n),
	
	
	.period_limit_value	(10'd866), //this needs to be 1 less than the value you want to reach because counter starts at 0
	
	.enable			(bclk_enable)	,
	.half_bclk_o	(bclk_negedge)	,
	.period_bclk_o	(bclk_posedge)	,
	.reset_transmission (reset_transmission)
	);
	/*
	uart_pwm baudrate_gen(		
	.clk_i   			(clk 		   ),
	.rst_n_i 			(rst_n		   ),
	
	
	.period_limit_value (	10'd433		), //this needs to be 1 less than the value you want to reach because counter starts at 0

	.pwm_o   			(bclk  		   )
	);
	*/
	
	
		
//rx sync (2ff)
	always_ff @(posedge clk or negedge rst_n) begin
	
		if(~rst_n)
			rx_ff1 <= '0;
		else 
			rx_ff1 <= rx;
	end
	
	always_ff @(posedge clk or negedge rst_n) begin
	
		if(~rst_n)
			rx_ff2 <= '0;
		else 
			rx_ff2 <= rx_ff1;
	end
	
	
//dtr sync (2ff)
	always_ff @(posedge clk or negedge rst_n) begin
	
		if(~rst_n)
			dtr_ff1 <= '0;
		else 
			dtr_ff1 <= dtr;
	end
	
	always_ff @(posedge clk or negedge rst_n) begin
	
		if(~rst_n)
			dtr_ff2 <= '0;
		else 
			dtr_ff2 <= dtr_ff1;
	end
	
	
//renaming wire connections in order to be more intuitive	
	assign rx_sync = rx_ff2;
	assign dtr_sync = dtr_ff2;
	
//construcing a fall edge detector for rx that will be used to start 
	always_ff @(posedge clk or negedge rst_n) begin
		
		if(~rst_n) 
			rx_sync_delay <= '0;
		else 	
			rx_sync_delay <= rx_sync;
	
	end
	
	
	assign rx_falledge = (~rx_sync && rx_sync_delay);
	
	
//bclk_enable should become 1 when dtr is 1 and rx has a fall edge, after which it will become 0 when dtr becomes 0
//this will ensure that the local bclk will be semi synced to the Master UART's bclk
	
	always_ff @(posedge clk or negedge rst_n) begin
		
		if(~rst_n)
			bclk_enable <= '0;
		else if(~dtr_sync && ~data_vld_uart)
			bclk_enable <= '0;
		else if(dtr_sync && rx_falledge)
			bclk_enable <= '1;
	
	end

	
//counter used to track progress of transmision
	logic [3:0] bit_step;
	
//should not to use dtr signal to start uart receiving because data can start comming later on rx
//will use dtr as an enable/chip select signal	

	always_ff @(posedge bclk_negedge or negedge rst_n) begin
	
		if(~rst_n) 
			bit_step <= '0;
		else if(reset_transmission)	
			bit_step <= 3'b1;
		else if(dtr_sync) begin
			if(bit_step >= 4'd9 & rx_sync) //byte transmission stops when counter is bigger than 9(10 bits or more were sent) and end padding bit is 1
				bit_step <= '0;
			else if(~rx_sync & bit_step == '0)
				bit_step <= 3'b1;
 			else if(bit_step != '0)
				bit_step <= bit_step + 1'b1;
			
		end
			
	end
	
	
	logic [7:0] store_reg;
	logic [7:0] store_buffer;
	logic [7:0] output_reg;
	logic 		data_vld_flag;
	
	//reading data from rx_sync when counter is incrementing(incomming transmission)
	always_ff @(posedge bclk_negedge or negedge rst_n) begin
	
		if(~rst_n)
			store_reg <= '0;
		else if(dtr_sync) begin
			if (bit_step != '0)
				store_reg <= {store_reg[6:0], rx_sync};
			else 
				store_reg <= '0;
		end
	
	end
	
	//data_uart_wr and data_vld_uart
	//output should be ready on the same clk cycle the last bit of data is received
	always_ff @(posedge bclk_posedge or negedge rst_n) begin
	
		if(~rst_n) begin
			store_buffer <= '0;
			data_vld_flag <= '0;
		end else if(dtr_sync) begin
			if(bit_step == 9) begin
				store_buffer <= store_reg[7:0];
				data_vld_flag <= '1;
			end else 
				data_vld_flag <= '0;
		end else
			data_vld_flag <= '0;
	
	end
	
	assign data_vld_uart = /*(~bclk_enable) ? '0 : */data_vld_flag;
	
	//read data from Instruction block
	always_ff @(posedge bclk_posedge or negedge rst_n) begin
	
		if(~rst_n) 
			output_reg <= '1;
		else if(dtr_sync) begin
			
			//on counter 0 load data into output_reg
			if(data_vld_dcd)
				output_reg <= data_rd;
			else //otherwise shift the register
				output_reg <= {output_reg[6:0] , 1'b1}; //fill with 1 in order for tx to output 1 when no transmission is taking place
		
		end
		
	
	end
	
	//can I add a read access from instr DCD to UART?
	always_ff @(posedge bclk_posedge or negedge rst_n) begin
	
		if(~rst_n)
			tx <= '1;
		else if(dtr_sync) begin
		
			if(data_vld_dcd)
				tx <= '0;
			else
				tx <= output_reg[7];
		
		end else 
			tx <= '1;
	
	end
	
	
	assign dtr_o = dtr_sync;
	
	
	
	assign data_uart_wr = store_buffer;

endmodule : uart_2
