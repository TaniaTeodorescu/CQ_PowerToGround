module decoder_2digits(
        input logic clk,
        input logic rst_n,
        input logic [4:0] in,
        output logic [6:0] out,
        output logic digit_sel
    );

logic [3:0] digit0, digit1;

logic [7:0] out_seg0, out_seg1;

assign digit0 = in % 10;
assign digit1 = in / 10;

 decoder_7seg decoder_7seg_0(
      .in(digit0),
      .out(out_seg0)
  );

 decoder_7seg decoder_7seg_1(
      .in(digit1),
      .out(out_seg1)
  );
  
logic flip_reg;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        flip_reg <= '0;
    end else flip_reg <= ~flip_reg;
end

assign digit_sel = flip_reg;
assign out = (flip_reg == 0) ? digit0 : digit1;

endmodule
