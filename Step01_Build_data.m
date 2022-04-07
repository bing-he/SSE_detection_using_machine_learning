%%---------------Produce data with SSE ramp -----------------------------%%
%%------------1 day low pass filter synthetic data-----------------------%%
clear; close all
set(0,'defaultAxesFontSize',17,'defaultAxesFontName','Helvetica')
addpath '***/useful_matlab_function'
% signal parameters
fs = 360*24;         % half-hour sampling frequency expressed per year
% use a 360 day 'year' -- the numbers factor into small primes 360*24
T = 1/6;  % signal duration (years), yrs  % try T = 2.0; or 1.0;  or 0.5;
N = round(fs*T);    % number of samples
t = (0:N-1)/fs;     % time vector
Nw = -1.8; % Pinkish red noise Number (-2: Red noise, -1 White noise)

% 1 day low pass Filter parameter
order = 4;
filtT = 1;
sampT = mean(diff(t*360));
ftype = 'low';

%% Build data with SSE in the middle
ML_n = 80000; % number 
for SNR = 2:5  % try 0 to 6
    X_1 = zeros(N,ML_n);
    R = zeros(N,ML_n);
    Drift = X_1;
    W = 1:1:ML_n;
    Z = zeros(1,ML_n);
    Ps = 20*log10(0.445);      % signal power, dBV^2 for SSE in the middel
    Pn = Ps - SNR;                  % noise power, dBV^2
    Pn = 10^(Pn/10);                % noise power, V^2
    sigma = sqrt(Pn);              % noise RMS, V
    %%
    for ML_i = 1:ML_n
        
        step = 1;
        
        dur = rand*11.5+3.5;       % duration 
        i1 = round(N/2-dur*24);    % SSE in the middle
        i2 = round(N/2+dur*24);
        
        internal_time = t;
        raw_data = zeros(size(t));  % Add down ramp SSE (addstep.m)/ up ramp SSE (addupstep.m)
        [s,step_line]=addstep(t(i1),t(i2),step,raw_data,internal_time);
        s1=smoothdata(s,'gaussian',8); % smooth the ramp
        s1=s1-mean(s1);
        n1 = (sigma)*pinkishrednoise(N,Nw);   % pinkishred noise generation
        
        %  assume after correcting for drift a residual 1 cm = 1 hPa error
        %   residual error as end-to-end linear slope
        %slope = 1/N; % slope  per sample;  N is number of samples
        %dr = ones(size(t));
        amp1 = 1.5*rand;     % try +ve slope -ve slope is easier for cusum red curve to detect SSE
        dr1 = amp1*t;  dr1 = dr1-mean(dr1);  %figure; plot(dr); hold on; plot(n1)
        
        r = s1;
        x1 = r + n1 + dr1; % ramp+noise+drift
        x1 = butterfilt2(x1,order,filtT,sampT,ftype); x1 = std_mean(x1);
        
        
        %% output
        X_1(:,ML_i) = x1;
        R(:,ML_i) = r;
        Drift(:,ML_i) = dr1;
        Z(:,ML_i) = 1;
        
    end
    
    data_X = X_1;
    data_Y = Z;
    data_Z = Drift;
    data_R = R;
    
    
    %%  save data
     location = 'pinkishrednoise_data_dn/';
     h5create([location 'data_SNR' num2str(SNR) '_1dlpf_80kdc_d1.h5'],'/X',[N ML_n])
     h5create([location 'data_SNR' num2str(SNR) '_1dlpf_80kdc_d1.h5'],'/Y',[1 ML_n])
     h5write([location 'data_SNR' num2str(SNR) '_1dlpf_80kdc_d1.h5'],'/X',data_X)
     h5write([location 'data_SNR' num2str(SNR) '_1dlpf_80kdc_d1.h5'],'/Y',data_Y)
%     
    
end

%% Build data with SSE not in the middle
ML_n2 = 80000;
for SNR = 2:5
    X_1 = zeros(N,ML_n2);
    R = zeros(N,ML_n2);
    Drift = X_1;
    W = 1:1:ML_n2;
    Z = zeros(1,ML_n2);
    
    Ps = 20*log10(0.4);      % signal power, dBV^2 for SSE in early/later
    Pn = Ps - SNR;                  % noise power, dBV^2
    Pn = 10^(Pn/10);                % noise power, V^2
    sigma = sqrt(Pn);              % noise RMS, V
    
    for ML_i = 1:ML_n2
        
        step = 1;
        
        ii = round(rand*N);
        dur = rand*11.5+3.5;
        i1 = round(ii-(dur*24));
        i2 = round(ii+(dur*24));
        while ((ii>672 && ii< 768) || i1< 24 || i2>(N-24)) %% SSE not in the middle
            ii = round(rand*N);
            dur = rand*11.5+3.5;
            i1 = round(ii-(dur*24));
            i2 = round(ii+(dur*24));
        end
        
        internal_time = t;
        raw_data = zeros(size(t));
        [s,step_line]=addstep(t(i1),t(i2),step,raw_data,internal_time);
        s1=smoothdata(s,'gaussian',8);
        s1=s1-mean(s1);
               
        n1 = (sigma)*pinkishrednoise(N,Nw);         % red noise generation        
        amp1 = 1.5*rand;     % try +ve slope -ve slope is easier for cusum red curve to detect SSE
        dr1 = amp1*t;  dr1 = dr1-mean(dr1);  %figure; plot(dr); hold on; plot(n1)
        
        r = s1;
        x1 = r + n1 + dr1; % ramp+noise+drift
        x1 = butterfilt2(x1,order,filtT,sampT,ftype); x1 = std_mean(x1);
               
        %% output
        X_1(:,ML_i) = x1;
        R(:,ML_i) = r;
        Drift(:,ML_i) = dr1;
        Z(:,ML_i) = 0;
        
    end
    data_X = X_1;
    data_Y = Z;
    data_Z = Drift;
    data_R = R;
    
%% save data    
    h5create([location 'data_SNR' num2str(SNR) '_1dlpf_80kdc_updn1.h5'],'/X',[N ML_n2])
    h5create([location 'data_SNR' num2str(SNR) '_1dlpf_80kdc_updn1.h5'],'/Y',[1 ML_n2])
    h5write([location 'data_SNR' num2str(SNR) '_1dlpf_80kdc_updn1.h5'],'/X',data_X)
    h5write([location 'data_SNR' num2str(SNR) '_1dlpf_80kdc_updn1.h5'],'/Y',data_Y)     
    
end


%% Build data only include noise

noise = zeros(3,N,ML_n);
label = zeros(1,ML_n);
rdn =randi([-1 1],ML_n,1);
for ML_i = 1:ML_n
    n1 = pinkishrednoise(N,Nw); %noise
    % drift
    amp1 = 1.5*rand;     % try +ve slope -ve slope is easier for cusum red curve to detect SSE
    dr1 = amp1*t;  dr1 = dr1-mean(dr1);  %figure; plot(dr); hold on; plot(n1)
    % noise + drift
    noise1 = n1+rdn(ML_i)*dr1; noise1 = butterfilt2(noise1,order,filtT,sampT,ftype);
    noise(1,:,ML_i) = std_mean(noise1);
end

%%
data_X = noise;
data_Y = label;

h5create([location 'data_noise_1dlpf_80kdc_d1.h5'],'/X',[N ML_n])
h5create([location 'data_noise_1dlpf_80kdc_d1.h5'],'/Y',[1 ML_n])
h5write([location 'data_noise_1dlpf_80kdc_d1.h5'],'/X',data_X)
h5write([location 'data_noise_1dlpf_80kdc_d1.h5'],'/Y',data_Y)

