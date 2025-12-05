module test_digits(
        input logic clk,
        input logic rst_n,
        input logic [4:0] in,
        output logic [6:0] out,
        output logic on_digit0,
        output logic on_digit1,
        output logic on_digit2,
        output logic on_digit3,
        output logic on_digit4,
        output logic on_digit5,
        output logic on_digit6,
        output logic on_digit7
    );
 
// clock divider    
logic strobe; // 1 kHz refresh clock


parameter CLK_LIMIT = 100000; // 100 MHz / 100,000 = 1 kHz

logic [$clog2(CLK_LIMIT):0] counter = 0; // Counter for division

always_ff @(posedge clk) begin
    if (counter == CLK_LIMIT - 1) begin
        counter <= 0;
        strobe <= ~strobe; // Toggle strobe every CLK_LIMIT cycles (1 kHz)
    end else begin
        counter <= counter + 1;
    end
end

  

    
    
logic digit_sel_out;   
    
decoder_2digits decoder_2digits_0(
        .clk(strobe),
        .rst_n(rst_n),
        .in(in),
        .out(out),
        .digit_sel(digit_sel_out)
    );    
    
 assign on_digit0 = digit_sel_out;
 assign on_digit1 = ~digit_sel_out;
 assign on_digit2 = 1;
 assign on_digit3 = 1;
 assign on_digit4 = 1;
 assign on_digit5 = 1;
 assign on_digit6 = 1;  
 assign on_digit7 = 1;   

endmodule
