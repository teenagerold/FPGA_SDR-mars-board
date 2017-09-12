# FPGA_SDR-mars-board
仿制俄罗斯哥们的火星车数字接收机
“火星车开发板”SDR Receiver分析说明

虽然对一些细节还是一知半解，但是对整个SDR接收机的结构和实现总算是有个大体的宏观上的了解了，在这里总结一下。
整个接收机可以分为算法实现和接口实现两大部分。总体结构如下：
 
还是那个经典的结构，中间虚线框的部分是算法部分，主要包括数字下变频和抽取滤波两部分。上个虚线框是接口部分，主要是串口发送和接收部分。第三部分的工作量其实集中在了Testbench部分。
一、	算法部分
主要是由mDSP模块进行连接的。
连接结构为经典结构，即ADC->MIXER(<-NCO)->CIC->FIR->out。
来看接口部分：


module mDSP
(
	input  clk,			//sample rate of ADC,NCO,Mixer,CIC
	input  clk_fir,	//the sample rate of fir is 20Mhz/200=100Khz
	input  rst_n,
	input  [9:0]  adc_data,
	input  [31:0] phi_inc_i,
	
	output signed [31:0] i_out,		//baseband i-q data
	output signed [31:0] q_out
);
主时钟clk为ADC、NCO、Mixer、CIC提供时钟，FIR滤波器的时钟单独由clk_fir提供，注意FIR滤波器时钟为100Khz，这是由于CIC滤波器进行了200倍的抽取。adc_data为adc采样得到的数据，phi_inc_i为NCO的相位累加字。i_out和q_out为最终要发送的基带数据。

整个系统速率匹配情况如下：


经过混频器后速率仍为20Msps，位宽变为20Bit，经过CIC的200倍抽
后采样速率降为100Ksps，这里位宽直接截断处理，具体截断多少还需要查阅资料。再经过FIR滤波器的两倍抽取后，采样速率变为50Khz，将数据截断为32bit，已经是基带数据了。串口发送数据速率下一节再讨论。
NCO采用IP核进行设计，主要参数就是频率控制字，基本公式为
f0 = φinc*fclk/2M Hz，由此可以反推出phi_inc_i的值。
CIC滤波器的设计也是利用IP核，基本参数如下图：
 
N=5，D=2，R=200。这里的参数对CIC滤波器影响可以单独写一篇文章了，日后再研究。
至于后级的FIR补偿滤波器，其系数可以由CIC滤波器的IP核生成的matlab文件来生成。具体原理同样也可以写成一篇文章。经过FIR滤波器后数据速率变为50Khz，32Bit。

二、	接口部分
接口部分主要是串口发送和接收两部分。
先来看接收部分，先看接口定义。
module serial_recv(
	input wire sclk, //采样时钟96MHz
	input wire sdata, //输入信号
	output reg [31:0]tuner_freq //接收到的设置频率信息
);
主要功能就是将信号线上的数据位转换为字节，再将字节翻译为频率控制信息。
再来看发送部分，先来看接口定义。
module serial_send(
	input wire sclk, //12*8=96Mhz
	input wire sample_clk, //100kHz
	input wire [31:0]chan0,
	input wire [31:0]chan1,
	output wire odata //serial port output, 12Mbit, 8bit, 3stop, noparity
);
来看一下编码过程。这里原作者将一个32Bit的数据编码为1 packet,每个packet包含5Byte的数据。具体编码方法如下图：
 
将原32Bit的数据的data[31]、data[23]、data[15]、data[7]全部单独用1Byte来编码，该Byte的字节头为1，其余3Byte的字节头为0，这样就可以轻易地在接收端同步恢复出原始4Byte的数据。发送和接收的编码方式是一致的。

三、	Testbench部分
验证思路：输入一调制信号，观察输出信号载波频率是否降低，同时采样率是否降低。
输入载波频率为5Mhz，1Khz调制的AM信号，观察输出信号的频谱是否以0Hz为中心，即数字下变频是否成功，采样率是否降低。
	这里，需要注意的是AD9200输出格式为straight binary，这里要人为加入偏置。得到的数值非补码，均为原码。因此，生成的数据要当做原码处理。
经过FIR滤波器的两倍抽取后，数据速率为50Khz，因此采样写入文本的速率也要为50Khz，刚开始没注意到这个问题，出现了许多奇怪的错误。
