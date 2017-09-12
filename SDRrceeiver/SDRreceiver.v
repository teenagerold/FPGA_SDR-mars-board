/*-------top module---------------
//top-down design method 
//This system can be devided to three main module:
//----1,communicate module 
//----2,signal process module
//----3,test module

//date:2017/8
//author:lmj
//version:v1.0

*/

module SDRreceiver
(
	input  clk,			//the system clk
	input  rst_n,
	input  [9:0]  adc_data,
	input  serial_rx,
	
	output serial_tx,		//
	output clk_adc,
	output [3:0] debug_led
);


//--------------------assign the system clock
wire clk_sample;
wire clk_fir;
wire clk_serial;

mpll u_mpll(
	.inclk0(clk),
	.c0(clk_sample),
	.c1(clk_fir),
	.c2(clk_serial)
	);

assign clk_adc=clk_sample; //the ADC sample clk


//----------------serial receive module
wire signed [31:0] phi_inc_i;	//nco phase increase word
//wire [3:0] debug_led;
serial_recv u_serial_recv(
	.sclk(clk_serial), //96MHz
	.sdata(serial_rx),
	.tuner_freq(phi_inc_i),
	.bits4(debug_led) 
);



//------------------------------------DSP module
//assign phi_inc_i=32'h40000000; 
//if fo=5Mhz,M=32,fclk=20Mhz,we can calculate 
//that phi_inc_i=2^30;---phi_inc_i=f0*(2^M)/fclk;
wire signed [31:0] i_out;
wire signed [31:0] q_out;
mDSP u_mDSP
(
	.clk(clk),			//sample rate of ADC,NCO,Mixer,CIC
	.clk_fir(clk_fir),	//the sample rate of fir is 20Mhz/200=100Khz
	.rst_n(rst_n),
	.adc_data(adc_data),
	.phi_inc_i(phi_inc_i),
	
	.i_out(i_out),		//baseband i-q data
	.q_out(q_out)

);



serial_send u_serial_send(
	.sclk(clk_serial), //12*8=96Mhz
	.sample_clk(clk_fir), //100kHz
	.chan0(q_out),
	.chan1(i_out),
	.odata(serial_tx) //serial port output, 12Mbit, 8bit, 1stop, noparity
);


endmodule
