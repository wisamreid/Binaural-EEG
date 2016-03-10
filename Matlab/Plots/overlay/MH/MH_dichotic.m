% MH_dichotic.m 
% This file plots the single subject average for the
% four conditions in an overlay plot.

clear
clc

%Load in the relevant matlab data
load('MH_dichotic_lpf.mat')

% Plot the 4 lowpassed averages at our strong electrode, FCz
figure(1)
plot(MH_500_S_lpf.Time, [MH_500_S_lpf.F(19,:);MH_1000_S_lpf.F(19,:);MH_2000_S_lpf.F(19,:);MH_4000_S_lpf.F(19,:)]);
legend('500 Hz', '1000 Hz', '2000 Hz', '4000 Hz');

title('Subject MH Change Response of Dichotic Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');