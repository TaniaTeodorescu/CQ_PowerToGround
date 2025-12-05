module tb_uart();


logic			clk				;
logic			rst_n			;

logic			dtr				;
logic			rx				;
logic			tx_2			;

logic			data_vld_dcd	;
logic	[7:0]	data_rd			;



logic			dtr_o_2			;
logic			data_vld_uart_2	;
logic	[7:0]	data_uart_wr_2	;

logic 			bclk			;



uart_2 i_uart_new(

	.clk			(clk			 ),
	.rst_n			(rst_n  		 ),
	
	.dtr			(dtr			 ),
	.rx				(rx 			 ),
	.tx				(tx_2 			 ),
	
	.data_vld_dcd	(data_vld_dcd	 ),
	.data_rd		(data_rd		 ), 
	.dtr_o			(dtr_o_2  		 ),
	.data_vld_uart	(data_vld_uart_2 ),
	.data_uart_wr	(data_uart_wr_2	 )

	);

//100MHz sysclk gen
initial begin

	clk <= '0;
	
	forever #5 clk <= ~clk;

end

//115.2KHz master bclk gen *************************  8680.6ns aprox = 115.19941 -> error of 0.00051%
initial begin
	
	bclk <= '0;
	
	forever #4340.3 bclk <= ~bclk;

end

//init signals and do reset
initial begin

	rst_n <= '0;
	dtr <= '0;
	rx <= '1;
	data_vld_dcd <= '0;
	data_rd <= '0;
	
	#11;
	rst_n <= '1;

end



initial  begin

	@(posedge rst_n);
	@(posedge bclk);
	#1;
	//#1000;
	dtr <= '1;
	
	@(posedge bclk);
	#1;
	//#1000;
	
	//transmit MASTER -> DSP : 0xB8
	transmit_char(8'hb8);
	
	//wait 10 clks
	repeat(10) @(posedge bclk);
	#1;
	//#1000;
	
	//transmit MASTER -> DSP : 0x09; 0xC0
	transmit_char(8'h09);
	transmit_char(8'hc0);
	
	//wait 10 clks
	repeat(10) @(posedge bclk);
	#1;
	//#1000;
	
	#1000;
	//transmit DSP -> MASTER : 0x99
	data_vld_dcd <= '1;
	data_rd <= 8'h99;
	
	@(posedge bclk);
	#2000;
	
	data_vld_dcd <= '0;
	data_rd <= 8'h00;
	
	repeat(9) @(posedge bclk);
	#1;
	//#1000;
	
	//wait 10 clks
	repeat(10) @(posedge bclk);
	#1;
	//#1000;
	
	//transmit DSP -> MASTER : 0x66; MASTER -> DSP : 0x33
	
	//transmit 0x45 manually
	rx <= '0;
	@(posedge bclk);
	#1;
	//#1000;
	
	rx <= '0;
	@(posedge bclk);
	#1000;
	
	
	//dtr <= '0;
	rx <= '1;
	@(posedge bclk);
	#1;
	//#1000;
	
	rx <= '0;
	@(posedge bclk);
	#1;
	//#1000;
	
	rx <= '0;
	@(posedge bclk);
	#1;
	//#1000;
	
	//dtr <= '1;
	rx <= '0;
	@(posedge bclk);
	#1;
	//#1000;
	
	rx <= '1;
	@(posedge bclk);
	#1;
	//#1000;
	
	
	rx <= '0;
	@(posedge bclk);
	#1;
	//#1000;
	
	rx <= '1;
	@(posedge bclk);
	@(posedge bclk);
	
	#1;
	dtr <= '0;
	
	
	@(posedge clk);
	#101;
	dtr <= '1;
	#1;
	
	#100;
	
	
	//data_vld_dcd <= '1;
	//data_rd <= 8'h66;
	
	#959;
	
	
	
	rx <= '1;
	@(posedge bclk);
	#1;
	
	
	transmit_char(8'h33, 8'h66, '1);

	dtr <= '1;
	
	
	repeat(10) @(posedge bclk);
	#1000;
	$finish;

end



task transmit_char(bit [7:0] DATA, bit [7:0] dcd_data = '0, bit dcd_transmit = '0);

	logic [9:0] buffer;
	buffer = {1'b0, DATA, 1'b1};
	
	data_vld_dcd <= dcd_transmit;
	data_rd <= dcd_data;
	
	repeat(10) begin
		
		rx <= buffer[9];
		
		buffer <= buffer << 1;
	
		@(posedge bclk);
		#1;
		//#1000;
		
		data_vld_dcd <= '0;
		data_rd <= 8'h00;
	
	end
	

endtask


endmodule : tb_uart
