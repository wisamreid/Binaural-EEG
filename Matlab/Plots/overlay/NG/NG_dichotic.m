% NG_dichotic.m 
% This file plots the single subject average for the
% four conditions in an overlay plot.

clear
clc

%Load in the relevant matlab data
load('NG_dichotic_lpf.mat')

% Plot the 4 lowpassed averages at our strong electrode, FCz
figure(1)
plot(NG_500_S_lpf.Time, [NG_500_S_lpf.F(19,:);NG_1000_S_lpf.F(19,:);NG_2000_S_lpf.F(19,:);NG_4000_S_lpf.F(19,:)]);
legend('500 Hz', '1000 Hz', '2000 Hz', '4000 Hz');

title('Subject NG Change Response of Dichotic Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');