% WR_dichotic.m 
% This file plots the single subject average for the
% four conditions in an overlay plot.

clear
clc

%Load in the relevant matlab data
load('WR_dichotic_lpf.mat')

% Plot the 4 lowpassed averages at our strong electrode, FCz
figure(1)
plot(WR_500_S_lpf.Time, [WR_500_S_lpf.F(19,:);WR_1000_S_lpf.F(19,:);WR_2000_S_lpf.F(19,:);WR_4000_S_lpf.F(19,:)]);
legend('500 Hz', '1000 Hz', '2000 Hz', '4000 Hz');

title('Subject WR Change Response of Dichotic Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');