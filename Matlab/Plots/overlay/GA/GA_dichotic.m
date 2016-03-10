% GA_dichotic.m 
% This file plots the grand average of the four conditions in one overlay
% plot.

clear
clc

%Load in the relevant matlab data
load('GA_dichotic_lpf.mat')

% Plot the 4 lowpassed averages at our strong electrode, FCz
figure(1)
plot(GA_500_S_lpf.Time, [GA_500_S_lpf.F(19,:);GA_1000_S_lpf.F(19,:);GA_2000_S_lpf.F(19,:);GA_4000_S_lpf.F(19,:)]);
legend('500 Hz', '1000 Hz', '2000 Hz', '4000 Hz');

title('Change Response of Dichotic Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');