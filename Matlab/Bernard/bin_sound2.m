
fs=48000;

f1=500;
amp=0.9;
mi=0.5;

fm=3.0;
tAM=4.0;
timeAM=([1:round(tAM)*fs]-0.5)/fs;
y1AM=1-mi*cos(2*pi*fm*timeAM-pi/2);
y2AM=1+mi*cos(2*pi*fm*timeAM-pi/2);

t=9.2;
t0=0.3;
n0=round(t0*fs);
t1=4.9
n1=round(t1*fs);
ton=0.01;
non=round(ton*fs);

time=[1:round(t*fs)]/fs;
y1=0.5*amp*sin(2*pi*f1*time);
y1(1:non)=y1(1:non)*0.5.*(1-cos(pi*([1:non]-0.5)/non));
y1(end-[0:non-1])=y1(end-[0:non-1])*0.5.*(1-cos(pi*([1:non]-0.5)/non));
y2=y1;

y1(n0+[1:length(timeAM)])=y1(n0+[1:length(timeAM)]).*y1AM;
y2(n0+[1:length(timeAM)])=y2(n0+[1:length(timeAM)]).*y2AM;

y1(n1+[1:length(timeAM)])=y1(n1+[1:length(timeAM)]).*y1AM;
y2(n1+[1:length(timeAM)])=y2(n1+[1:length(timeAM)]).*y1AM;

wavwrite([y1',y2'],fs,'bin0500.wav');




