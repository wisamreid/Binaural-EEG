% boxplot_dichotic.m
% This file draws box plots for the N1 and P2 amplitudes across all four
% conditions.

clear
clc

% Load in the relevant matlab data
load('ALL_dichotic_lpf.mat')

% Fill a vector with the peak N1 amplitudes for each condition
N1peaks_500 = [AL_500_S_lpf.F(19,174) CM_500_S_lpf.F(19,174) MH_500_S_lpf.F(19,174) NG_500_S_lpf.F(19,174) TD_500_S_lpf.F(19,174) WR_500_S_lpf.F(19,174)];

N1peaks_1000 = [AL_1000_S_lpf.F(19,174) CM_1000_S_lpf.F(19,174) MH_1000_S_lpf.F(19,174) NG_1000_S_lpf.F(19,174) TD_1000_S_lpf.F(19,174) WR_1000_S_lpf.F(19,174)];

N1peaks_2000 = [AL_2000_S_lpf.F(19,174) CM_2000_S_lpf.F(19,174) MH_2000_S_lpf.F(19,174) NG_2000_S_lpf.F(19,174) TD_2000_S_lpf.F(19,174) WR_2000_S_lpf.F(19,174)];

N1peaks_4000 = [AL_4000_S_lpf.F(19,174) CM_4000_S_lpf.F(19,174) MH_4000_S_lpf.F(19,174) NG_4000_S_lpf.F(19,174) TD_4000_S_lpf.F(19,174) WR_4000_S_lpf.F(19,174)];

% Put these in a matrix (absolute amplitude)
N1_All = horzcat(abs(N1peaks_500)', abs(N1peaks_1000)', abs(N1peaks_2000)', abs(N1peaks_4000)');

% Fill a vector with the peak P2 amplitudes for each condition
P2peaks_500 = [AL_500_S_lpf.F(19,223) CM_500_S_lpf.F(19,223) MH_500_S_lpf.F(19,223) NG_500_S_lpf.F(19,223) TD_500_S_lpf.F(19,223) WR_500_S_lpf.F(19,223)];

P2peaks_1000 = [AL_1000_S_lpf.F(19,223) CM_1000_S_lpf.F(19,223) MH_1000_S_lpf.F(19,223) NG_1000_S_lpf.F(19,223) TD_1000_S_lpf.F(19,223) WR_1000_S_lpf.F(19,223)];

P2peaks_2000 = [AL_2000_S_lpf.F(19,223) CM_2000_S_lpf.F(19,223) MH_2000_S_lpf.F(19,223) NG_2000_S_lpf.F(19,223) TD_2000_S_lpf.F(19,223) WR_2000_S_lpf.F(19,223)];

P2peaks_4000 = [AL_4000_S_lpf.F(19,223) CM_4000_S_lpf.F(19,223) MH_4000_S_lpf.F(19,223) NG_4000_S_lpf.F(19,223) TD_4000_S_lpf.F(19,223) WR_4000_S_lpf.F(19,223)];

% Put these in a matrix 
P2_All = horzcat(P2peaks_500', P2peaks_1000', P2peaks_2000', P2peaks_4000');

% Condition vector for plotting
Condition = [500 1000 2000 4000];

% Make a box plot with all four conditions for both N1 and P2
figure(1)
boxplot(N1_All,Condition);
title('N1 Absolute Amplitude of Dichotic Change Response by Condition');
xlabel('Carrier Frequency (Hz)');
ylabel('Voltage (V)');

figure(2);
boxplot(P2_All,Condition);
title('P2 Amplitude of Dichotic Change Response by Condition');
xlabel('Carrier Frequency (Hz)');
ylabel('Voltage(V)');

