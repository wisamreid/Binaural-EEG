% GA_diotic.m 
% This file plots the grand average of the four conditions in an overlay
% plot.

clear
clc

%Load in the relevant matlab data
load('GA_diotic_lpf.mat')

% Plot the 4 lowpassed averages at our strong electrode, FCz
figure(1)
plot(GA_500_L_lpf.Time(101:450), [GA_500_L_lpf.F(19,101:450);GA_1000_L_lpf.F(19,101:450);GA_2000_L_lpf.F(19,101:450);GA_4000_L_lpf.F(19,101:450)]);

legend('500 Hz', '1000 Hz', '2000 Hz', '4000 Hz');

title('Onset Response of Diotic Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');