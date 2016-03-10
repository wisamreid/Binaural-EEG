%% M451A Final Project Stimulus 
%
% Authors: Wisam Reid and Nick Gang

clear;
clc;

%% Options (FLAGS FOR PLOTTING AND PLAYBACK)

format long

% to plot or not to plot that is the question
do_plot = 1;

% which plots do you want to see
plot_tails = 0;
plot_delay = 0;
plot_envelopes = 0;
plot_elc_curves = 0;
plot_delays_subplot = 0;

% to write files or not 
write = 0;

% to play files or not
play = 1;

% Use ELC Curves
use_elc = 1;

%% Variables to Change 

% sample rate
fs=48000;

% carrier freqs
carrier_f1=500;
carrier_f2=1000;
carrier_f3=2000;
carrier_f4=4000;

% fm 
fm = 40; % Hz

% time values (sec)
t_total=4.0;
t_half=2.0; % time until change response
t_tail=0.00625; % 6.25 ms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Here is where we set the time delay %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_delay=0.0016; % 1.6 ms

%% Computed Amplitudes 

% We choose 80 phon giving us 80 dB @ 1000 kHz 
% as this is a common listening level standard 
phon = 80;
amp = 0.5;

if use_elc
    
    [spl_phon, elc_freqs] = iso226(phon);


    spl_carrier_f1_index = find( elc_freqs == carrier_f1);
    spl_carrier_f2_index = find( elc_freqs == carrier_f2);
    spl_carrier_f3_index = find( elc_freqs == carrier_f3);
    spl_carrier_f4_index = find( elc_freqs == carrier_f4);

    spl_carrier_f1 = spl_phon(spl_carrier_f1_index);
    spl_carrier_f2 = spl_phon(spl_carrier_f2_index);
    spl_carrier_f3 = spl_phon(spl_carrier_f3_index);
    spl_carrier_f4 = spl_phon(spl_carrier_f4_index);

    % Carrier cmplitudes are computed by relative spl values 
    % relative to 1000 Hz
    amp_carrier_f2 = amp*(spl_carrier_f2/spl_carrier_f2); % 1

    amp_carrier_f1 = amp*(spl_carrier_f1/spl_carrier_f2); 
    amp_carrier_f3 = amp*(spl_carrier_f3/spl_carrier_f2);
    amp_carrier_f4 = amp*(spl_carrier_f4/spl_carrier_f2);
    
else 
    
    amp_carrier_f1 = amp;
    amp_carrier_f2 = amp;
    amp_carrier_f3 = amp;
    amp_carrier_f4 = amp;    

end

%% Plot ELC Curves 

if do_plot == 1

    if plot_elc_curves

        % Plotting ELC Curves for 10 - 90 Phon (10 Phon incriments)
        figure(11);
        [spl,freq_base] = iso226(10);
        semilogx(freq_base,spl)
        hold on;

        for phon = 0:10:90
            [spl,freq] = iso226(phon);%equal loudness data
            plot(1000,phon,'.r');
            text(1000,phon+3,num2str(phon));
            plot(freq_base,spl);%equal loudness curve
        end
        axis([0 13000 0 140]);
        grid on % draw grid
        xlabel('Frequency (Hz)');
        ylabel('Sound Pressure in Decibels');
        hold off;

    end
    
end 
%% Computed Time Variables

% AM period
T_fm=1/fm;
t_quarter_wl=T_fm/4; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Here is where create an interpolation time %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
t_interpolate=t_quarter_wl+t_delay;

% % % % % % % time vectors % % % % % % % % %  

time_total = 0:1/fs:t_total;
time_half = 0:1/fs:t_half;
time_delay = 0:1/fs:t_delay;
time_tail = 0:1/fs:t_tail;
time_quarter_wl=0:1/fs:t_quarter_wl;
time_wl=0:1/fs:T_fm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Here is where create a time vector for the segment of interpolating AM Sinusoid %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_interpolate = 0:1/fs:t_interpolate;

%% Create AM Signals

% create gradual tail applied to end of stimulus
am_tail = cos(2*pi*fm*time_tail);
am_tail = [ones(1,length(time_total) - length(time_tail)) am_tail];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Here is where create the segment of interpolating AM Sinusoid %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % % % % % create interpolation sinusoid for delay transition % % % % 
interpolation_freq = 1 / (T_fm + (t_delay*4));
interpolation=sin(2*pi*interpolation_freq*time_interpolate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LEFT EAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% % create 4 second AM signal without delay % % 

am = sin(2*pi*fm*time_total);
% apply tail
am = am_tail.*am;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RIGHT EAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % create 4 second AM signal with 1.5 ms delay @ 2 seconds % %

% create 2 second AM signal   
am_half = sin(2*pi*fm*time_half);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Here is where we create the final interpoled AM Sinusoid %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% chop off a quarter wavelength at the beginning
am_chopped = am_half(length(time_quarter_wl):length(am_half));
% prepend interpolation sinusoid (quarter wavelength) to beginning 
am_interpolated = [interpolation am_chopped];
% prepend 2 second am signal to am_interpolated
am_delay = [am_half am_interpolated];
am_delay = am_delay(1:length(time_total));

% apply tail
am_delay = am_tail.*am_delay;

%% Plotting Envelopes

% % % PLOT % % % PLOT % % % PLOT % % %  
if plot_envelopes

    diotic_envelop_plot = am(length(time_half)-(2*length(time_wl)):length(time_half)+(2*length(time_wl)));    
    dichotic_envelop_plot = am_delay(length(time_half)-(2*length(time_wl)):length(time_half)+(2*length(time_wl)));

    % Envelope Plots
    
    % am
    figure(9)
    subplot(2,1,1);
    plot(diotic_envelop_plot,'red') 
    hold on;
    plot(-diotic_envelop_plot,'red')
    title('AM Envelope')
    axis([0 length(diotic_envelop_plot) -1 1]) 
    hold off;
    
    % delayed am
    subplot(2,1,2);
    plot(dichotic_envelop_plot)
    hold on;
    plot(-dichotic_envelop_plot)
    title('Delayed AM Envelope')
    axis([0 length(diotic_envelop_plot) -1 1])
    hold off;
    
    overlap_diotic_envelop_plot = am((length(am)/2)-(4*length(time_tail)):(length(am)/2)+(4*length(time_tail)));    
    overlap_dichotic_envelop_plot = am_delay((length(am_delay)/2)-(4*length(time_tail)):(length(am_delay)/2)+(4*length(time_tail)));
    
    % Overlaped Envelope Plots
    figure(10)
    plot(overlap_diotic_envelop_plot,'red') 
    hold on;
    plot(-overlap_diotic_envelop_plot,'red')
    hold on;
    plot(overlap_dichotic_envelop_plot, 'blue')
    hold on;
    % delayed am
    plot(-overlap_dichotic_envelop_plot,'blue')
    title('AM Envelopes Red: Left Ear, Blue: Right Ear')
    axis([0 length(overlap_diotic_envelop_plot) -1 1])
    hold off;
    
end

%% Create AM Modulated Carrier Frequency 500 Hz

% Diotic
carrier_500 = amp_carrier_f1*sin(2*pi*carrier_f1*time_total);
diotic_500=am.*carrier_500;

% Dichotic
dichotic_500= am_delay.*carrier_500;

out500 = [diotic_500; dichotic_500];

if do_plot
    
    if plot_delay
        
        delay_plot = dichotic_500(length(time_half)-2*length(time_tail):length(time_half)+2*length(time_tail)+length(time_delay));
        
        % delay 500 Hz
        figure(1)
        plot(delay_plot)
        title('Delay 500 Hz')
        axis([0 length(delay_plot) -1 1])
        
    end
    
    if plot_tails
        
        plot_left_tail = diotic_500(length(dichotic_500)-(4*length(time_tail)):length(dichotic_500));
        plot_right_tail = dichotic_500(length(dichotic_500)-(4*length(time_tail)):length(dichotic_500));
        
        % Tails 500 Hz
        figure(2)
        subplot(2,1,1);
        plot(plot_left_tail)
        title('Left Tail 500 Hz')
        axis([0 length(plot_right_tail) -1 1])
        
        subplot(2,1,2);
        plot(plot_right_tail)
        title('Right Tail 500 Hz')
        axis([0 length(plot_right_tail) -1 1])

    end
    
end 

% write new files
if write 
    wavwrite([out500'],fs,'bin0500.wav');
end

% Play the sound
if play
    soundsc(out500,fs);
    pause(length(out500)/fs);
end
%% Create AM Modulated Carrier Frequency 1000 Hz

% Diotic
carrier_1k = amp_carrier_f2*sin(2*pi*carrier_f2*time_total);
diotic_1k=am.*carrier_1k;

% Dichotic
dichotic_1k= am_delay.*carrier_1k;

out1k = [diotic_1k; dichotic_1k];

if do_plot 
    
    if plot_delay
        
        delay_plot = dichotic_1k(length(time_half)-2*length(time_tail):length(time_half)+2*length(time_tail)+length(time_delay));

        % delay 1000 Hz
        figure(3)
        plot(delay_plot)
        title('Delay 1000 Hz')
        axis([0 length(delay_plot) -1 1])
        
    end
    
    if plot_tails
        
        plot_left_tail = diotic_1k(length(dichotic_1k)-(4*length(time_tail)):length(dichotic_1k));
        plot_right_tail = dichotic_1k(length(dichotic_1k)-(4*length(time_tail)):length(dichotic_1k));
        
        % tails 1000 Hz
        figure(4)
        subplot(2,1,1);
        plot(plot_left_tail)
        title('Left Tail 1000 Hz')
        axis([0 length(plot_left_tail) -1 1])
        
        subplot(2,1,2);
        plot(plot_right_tail)
        title('Right Tail 1000 Hz')
        axis([0 length(plot_right_tail) -1 1])
    
    end

end

% write new files
if write 
    wavwrite([out1k'],fs,'bin1000.wav');
end

% Play the sound 
if play
    soundsc(out1k,fs);
    pause(length(out1k)/fs);
end

%% Create AM Modulated Carrier Frequency 2000 Hz

% Diotic
carrier_2k = amp_carrier_f3*sin(2*pi*carrier_f3*time_total);
diotic_2k=am.*carrier_2k;

% Dichotic
dichotic_2k= am_delay.*carrier_2k;

out2k = [diotic_2k; dichotic_2k];

if do_plot 
    
    
    if plot_delay
        
        delay_plot = dichotic_2k(length(time_half)-2*length(time_tail):length(time_half)+2*length(time_tail)+length(time_delay));
        
        % delay 2000 Hz
        figure(5)
        plot(delay_plot)
        title('Delay 2000 Hz')
        axis([0 length(delay_plot) -1 1])
        
    end
    
    if plot_tails
    
        plot_left_tail = diotic_2k(length(dichotic_2k)-(4*length(time_tail)):length(dichotic_2k));
        plot_right_tail = dichotic_2k(length(dichotic_2k)-(4*length(time_tail)):length(dichotic_2k));
        
        % tails 2000 Hz
        figure(6)
        subplot(2,1,1);
        plot(plot_left_tail)
        title('Left Tail 2000 Hz')
        axis([0 length(plot_left_tail) -1 1])

        subplot(2,1,2);
        plot(plot_right_tail)
        title('Right Tail 2000 Hz')
        axis([0 length(plot_right_tail) -1 1])
    
    end
end

% write new files
if write
    wavwrite([out2k'],fs,'bin2000.wav');
end

% Play the sound 
if play
    soundsc(out2k,fs);
    pause(length(out2k)/fs);
end

%% Create AM Modulated Carrier Frequency 4000 Hz

% Diotic
carrier_4k = amp_carrier_f4*sin(2*pi*carrier_f4*time_total);
diotic_4k=am.*carrier_4k;

% Dichotic
dichotic_4k= am_delay.*carrier_4k;

out4k = [diotic_4k; dichotic_4k];

if do_plot 

    if plot_delay
        
        delay_plot = dichotic_4k(length(time_half)-2*length(time_tail):length(time_half)+2*length(time_tail)+length(time_delay));

        % delay 4000 Hz
        figure(7)
        plot(delay_plot)
        title('Delay 4000 Hz')
        axis([0 length(delay_plot) -1 1])

    end
    
    if plot_tails
    
        plot_left_tail = diotic_4k(length(dichotic_4k)-(4*length(time_tail)):length(dichotic_4k));
        plot_right_tail = dichotic_4k(length(dichotic_4k)-(4*length(time_tail)):length(dichotic_4k));

        % Tails 4000 Hz
        figure(8)
        subplot(2,1,1);
        plot(plot_left_tail)
        title('Left Tail 2000 Hz')
        axis([0 length(plot_left_tail) -1 1])

        subplot(2,1,2);
        plot(plot_right_tail)
        title('Right Tail 2000 Hz')
        axis([0 length(plot_right_tail) -1 1])
    
    end
    
end

% write new files
if write
    wavwrite([out4k'],fs,'bin4000.wav');
end

% Play the sound 
if play
    soundsc(out4k,fs);
    pause(length(out4k)/fs);
end

%%  Stim Delays in Subplot

if plot_delays_subplot
    
    delay_plot500 = dichotic_500(length(time_half)-2*length(time_tail):length(time_half)+2*length(time_tail)+length(time_delay));
    delay_plot1k = dichotic_1k(length(time_half)-2*length(time_tail):length(time_half)+2*length(time_tail)+length(time_delay));
    delay_plot2k = dichotic_2k(length(time_half)-2*length(time_tail):length(time_half)+2*length(time_tail)+length(time_delay));
    delay_plot4k = dichotic_4k(length(time_half)-2*length(time_tail):length(time_half)+2*length(time_tail)+length(time_delay));

    % delay 500 Hz
    figure(100)
    subplot(4,1,1);
    plot(delay_plot500)
    title('500 Hz')
    axis([0 length(delay_plot500) -1 1])

    % delay 1000 Hz
    subplot(4,1,2);
    plot(delay_plot1k)
    title('1000 Hz')
    axis([0 length(delay_plot1k) -1 1])

    % delay 2000 Hz
    subplot(4,1,3);
    plot(delay_plot2k)
    title('2000 Hz')
    axis([0 length(delay_plot2k) -1 1])

    % delay 4000 Hz
    subplot(4,1,4);
    plot(delay_plot4k)
    title('4000 Hz')
    axis([0 length(delay_plot4k) -1 1])

end 