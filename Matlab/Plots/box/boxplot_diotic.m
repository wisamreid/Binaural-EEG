% boxplot_diotic.m
% This file draws box plots for the N1 and P2 amplitudes across all four
% conditions.

clear
clc

% Load in the relevant matlab data
load('ALL_diotic_lpf.mat')

% Fill a vector with the peak N1 amplitudes for each condition
N1peaks_500 = [AL_500_L_lpf.F(19,302) CM_500_L_lpf.F(19,302) MH_500_L_lpf.F(19,302) NG_500_L_lpf.F(19,302) TD_500_L_lpf.F(19,302) WR_500_L_lpf.F(19,302)];

N1peaks_1000 = [AL_1000_L_lpf.F(19,299) CM_1000_L_lpf.F(19,299) MH_1000_L_lpf.F(19,299) NG_1000_L_lpf.F(19,299) TD_1000_L_lpf.F(19,299) WR_1000_L_lpf.F(19,299)];

N1peaks_2000 = [AL_2000_L_lpf.F(19,300) CM_2000_L_lpf.F(19,300) MH_2000_L_lpf.F(19,300) NG_2000_L_lpf.F(19,300) TD_2000_L_lpf.F(19,300) WR_2000_L_lpf.F(19,300)];

N1peaks_4000 = [AL_4000_L_lpf.F(19,298) CM_4000_L_lpf.F(19,298) MH_4000_L_lpf.F(19,298) NG_4000_L_lpf.F(19,298) TD_4000_L_lpf.F(19,298) WR_4000_L_lpf.F(19,298)];

% Put these in a matrix (absolute amplitude)
N1_All = horzcat(abs(N1peaks_500)', abs(N1peaks_1000)', abs(N1peaks_2000)', abs(N1peaks_4000)');

% Fill a vector with the peak P2 amplitudes for each condition
P2peaks_500 = [AL_500_L_lpf.F(19,346) CM_500_L_lpf.F(19,346) MH_500_L_lpf.F(19,346) NG_500_L_lpf.F(19,346) TD_500_L_lpf.F(19,346) WR_500_L_lpf.F(19,346)];

P2peaks_1000 = [AL_1000_L_lpf.F(19,348) CM_1000_L_lpf.F(19,348) MH_1000_L_lpf.F(19,348) NG_1000_L_lpf.F(19,348) TD_1000_L_lpf.F(19,348) WR_1000_L_lpf.F(19,348)];

P2peaks_2000 = [AL_2000_L_lpf.F(19,352) CM_2000_L_lpf.F(19,352) MH_2000_L_lpf.F(19,352) NG_2000_L_lpf.F(19,352) TD_2000_L_lpf.F(19,352) WR_2000_L_lpf.F(19,352)];

P2peaks_4000 = [AL_4000_L_lpf.F(19,347) CM_4000_L_lpf.F(19,347) MH_4000_L_lpf.F(19,347) NG_4000_L_lpf.F(19,347) TD_4000_L_lpf.F(19,347) WR_4000_L_lpf.F(19,347)];

% Put these in a matrix 
P2_All = horzcat(P2peaks_500', P2peaks_1000', P2peaks_2000', P2peaks_4000');

% Condition vector for plotting
Condition = [500 1000 2000 4000];

% Make a box plot with all four conditions for both N1 and P2
figure(1)
boxplot(N1_All,Condition);
title('N1 Absolute Amplitude of Diotic Change Response by Condition');
xlabel('Carrier Frequency (Hz)');
ylabel('Voltage (V)');

figure(2);
boxplot(P2_All,Condition);
title('P2 Amplitude of Diotic Change Response by Condition');
xlabel('Carrier Frequency (Hz)');
ylabel('Voltage(V)');
