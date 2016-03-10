% NG_diotic.m 
% This file plots the single subject average for the
% four conditions in an overlay plot.

clear
clc

%Load in the relevant matlab data
load('NG_diotic_lpf.mat')

% Plot the 4 lowpassed averages at our strong electrode, FCz
figure(1)
plot(NG_500_L_lpf.Time(101:450), [NG_500_L_lpf.F(19,101:450);NG_1000_L_lpf.F(19,101:450);NG_2000_L_lpf.F(19,101:450);NG_4000_L_lpf.F(19,101:450)]);
legend('500 Hz', '1000 Hz', '2000 Hz', '4000 Hz');

title('Subject NG Onset Response of Diotic Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');