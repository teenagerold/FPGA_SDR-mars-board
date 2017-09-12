
module multiply(
	input  clk,
	input  [9:0] adc_data,
	input  [9:0] fsin,	//input LO_sin
	input  [9:0] fcos,	//input LO_cos
	output reg signed [19:0] i_o_mixer,			
	output reg signed [19:0] q_o_mixer
);

reg signed [9:0]data;
reg signed [9:0]fsin10;
reg signed [9:0]fcos10;

always @(posedge clk)
begin
	data  <= adc_data-10'd512;
	fsin10<= fsin;
	fcos10<= fcos;
end

always @(posedge clk)
begin
	i_o_mixer <= data * fcos10;
	q_o_mixer <= data * fsin10;
end

endmodule
