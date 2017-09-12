
Fs=20e6; %采样频率
Fs_o=50e3; %抽取后的采样率
L=2^13;  %数据长度8192,频率分辨率20e6/8192=2.44KHz
N=2^5; %输出数据分析长度，2^6=64,频率分辨率50e3/64=0.78Khz
%从文本文件中读取数据
%读取输入数据。即原始输入信号，相当于ADC采样得到的信号
fid=fopen('E:\F\FPGAcode\SDR-radio-receiver\DE0-nano\SDRrceeiver\simulation\modelsim\GenerateAM_Dec.txt','r');
[S_in,S_n]=fscanf(fid,'%lu',inf);
fclose(fid);

S_in_ac=double(S_in)-mean(S_in);

%读取I路输出数据
fid=fopen('E:\F\FPGAcode\SDR-radio-receiver\DE0-nano\SDRrceeiver\simulation\modelsim\i_out_FPGA.txt','r');
[i_out,i_count]=fscanf(fid,'%d',inf);
fclose(fid);

%读取q路输出数据
fid=fopen('E:\F\FPGAcode\SDR-radio-receiver\DE0-nano\SDRrceeiver\simulation\modelsim\q_out_FPGA.txt','r');
[q_out,q_count]=fscanf(fid,'%d',inf);
fclose(fid);

%取出一段数据进行计算
S_in_ac=S_in_ac(1:L)';
i_out=i_out(1:N)';
q_out=q_out(1:N)';
% i_out=i_out((length(i_out)-N+1):length(i_out))';
% q_out=q_out((length(q_out)-N+1):length(q_out))';

iq_out=i_out-1i*q_out;

F_S_in=abs(fft(S_in_ac,L));
F_i_out=abs(fft(i_out,N));
F_q_out=abs(fft(q_out,N));

F_iq_out=abs(fft(iq_out,N));

%归一化处理
F_S_in=F_S_in/max(abs(F_S_in));
F_i_out=F_i_out/max(abs(F_i_out));
F_q_out=F_q_out/max(abs(F_q_out));

F_iq_out=F_iq_out/max(abs(F_iq_out));

%转换为相对于原点对称的信号
F_S_in=[F_S_in(L/2+1:L),F_S_in(1:L/2)]; 
F_i_out=[F_i_out(N/2+1:N),F_i_out(1:N/2)]; 
F_q_out=[F_q_out(N/2+1:N),F_q_out(1:N/2)]; 

F_iq_out=[F_iq_out(N/2+1:N),F_iq_out(1:N/2)]; 

%生成频率坐标轴
m=[-L/2:1:(L/2-1)]*Fs/L*(10^(-6));%生成频率坐标轴,单位为MHz

m_o=[-N/2:1:(N/2-1)]*Fs_o/N*(10^(-3));%生成频率坐标轴,单位为KHz

%画图
subplot(221);plot(m,F_S_in);
xlabel('频率(MHz)');ylabel('幅度');title('输入信号频谱');

subplot(222);plot(m_o,F_i_out);
xlabel('频率(KHz)');ylabel('幅度');title('I路输出信号频谱');

subplot(224);plot(m_o,F_q_out);
xlabel('频率(KHz)');ylabel('幅度');title('Q路输出信号频谱');

subplot(223);plot(m_o,F_iq_out);
xlabel('频率(KHz)');ylabel('幅度');title('复输出信号频谱');

