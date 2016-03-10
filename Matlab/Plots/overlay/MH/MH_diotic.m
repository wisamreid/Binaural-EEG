% MH_diotic.m 
% This file plots the single subject average for the
% four conditions in an overlay plot.

clear
clc

%Load in the relevant matlab data
load('MH_diotic_lpf.mat')

% Plot the 4 lowpassed averages at our strong electrode, FCz
figure(1)
plot(MH_500_L_lpf.Time(101:450), [MH_500_L_lpf.F(19,101:450);MH_1000_L_lpf.F(19,101:450);MH_2000_L_lpf.F(19,101:450);MH_4000_L_lpf.F(19,101:450)]);
legend('500 Hz', '1000 Hz', '2000 Hz', '4000 Hz');

title('Subject MH Onset Response of Diotic Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');