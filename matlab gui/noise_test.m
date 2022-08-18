clc, clearvars, close all

% Create a struct for dtmf keys and frequencies
dtmf.keys = ['1','2','3','A';
             '4','5','6','B';
             '7','8','9','C';
             '*','0','#','D'];
dtmf.colTones = ones(4,1)*[1209,1336,1477,1633];
dtmf.rowTones = [697;770;852;941]*ones(1,4);

% Set parameters
Fs = 8000;
t = (0:1:204*5)/Fs;
x = zeros(1, length(t));
x(1) = 1;

% Test keys
test_keys = 'A2*70#';

%% Generate touch-tone
tones = [];
for i = 1:numel(test_keys)
    % Create tone for each dialed key
    [r, c] = find(dtmf.keys == test_keys(i));
    tone = filter([0 sin(2*pi*dtmf.rowTones(r,c)/Fs)], [1 -2*cos(2*pi*dtmf.rowTones(r,c)/Fs) 1],x) + ...
           filter([0 sin(2*pi*dtmf.colTones(r,c)/Fs)], [1 -2*cos(2*pi*dtmf.colTones(r,c)/Fs) 1],x);
    
    % Combine all tones
    tones = [tones, zeros(1,400),tone];
end

% Scale the signal by a factor of 2
tones = (tones)*2;

%% Add white noise
tones = awgn(tones, 1);

% Display noisy signal
figure;
plot((0:length(tones)-1)/Fs, tones)
grid on
title({'Noisy dial-tone', ['Keys: ',test_keys]})
ylabel('Amplitude')
xlabel('Time (s)')

%% Filter Bank Approach as per Goertzel Algorithm
% To minimize the error between the original and the estimated frequencies, 
% truncate the tones keeping only 205 samples or 25.6 ms.
N = 205;

% Goertzel coefficients
q697 = [1 -2*cos(2*pi*18/N) 1];
q770 = [1 -2*cos(2*pi*20/N) 1];
q852 = [1 -2*cos(2*pi*22/N) 1];
q941 = [1 -2*cos(2*pi*24/N) 1];
q1209 = [1 -2*cos(2*pi*31/N) 1];
q1336 = [1 -2*cos(2*pi*34/N) 1];
q1477 = [1 -2*cos(2*pi*38/N) 1];
q1633 = [1 -2*cos(2*pi*42/N) 1];

% Frequency response of the filters
[w1, ~] = freqz([1 -exp(-2*pi*18/N)], q697, 512, Fs);
[w2, ~] = freqz([1 -exp(-2*pi*20/N)], q770, 512, Fs);
[w3, ~] = freqz([1 -exp(-2*pi*22/N)], q852, 512, Fs);
[w4, ~] = freqz([1 -exp(-2*pi*24/N)], q941, 512, Fs);
[w5, ~] = freqz([1 -exp(-2*pi*31/N)], q1209, 512, Fs);
[w6, ~] = freqz([1 -exp(-2*pi*34/N)], q1336, 512, Fs);
[w7, ~] = freqz([1 -exp(-2*pi*38/N)], q1477, 512, Fs);
[w8, f] = freqz([1 -exp(-2*pi*42/N)], q1633, 512, Fs);

%% DTMF Decoder
Decode_output = [];
for i = 0:(length(tones)/1421-1)
    % Select individual dialed digits, one at a time
    tone = tones(1+1421*i : 1421*(i+1));
    
    % Remove initial silence duration
    tone = tone(401:end);
    
    % Make it even-length array to avoid sampling errors
    yDTMF = [tone 0];
    
    % Filter each touch-tone frequency
    y697 = filter(1, q697, yDTMF);
    y770 = filter(1, q770, yDTMF);
    y852 = filter(1, q852, yDTMF);
    y941 = filter(1, q941, yDTMF);
    y1209 = filter(1, q1209, yDTMF);
    y1336 = filter(1, q1336, yDTMF);
    y1477 = filter(1, q1477, yDTMF);
    y1633 = filter(1, q1633, yDTMF);
    
    % Select freq-strengths using Goertzel algorithm
    freq_strength(1) = sqrt(y697(N+1)^2 + y697(N)^2 -2*cos(2*pi*18/N)*y697(N+1)*y697(N));
    freq_strength(2) = sqrt(y770(N+1)^2 + y770(N)^2 -2*cos(2*pi*20/N)*y770(N+1)*y770(N));
    freq_strength(3) = sqrt(y852(N+1)^2 + y852(N)^2 -2*cos(2*pi*22/N)*y852(N+1)*y852(N));
    freq_strength(4) = sqrt(y941(N+1)^2 + y941(N)^2 -2*cos(2*pi*24/N)*y941(N+1)*y941(N));
    freq_strength(5) = sqrt(y1209(N+1)^2 + y1209(N)^2 -2*cos(2*pi*31/N)*y1209(N+1)*y1209(N));
    freq_strength(6) = sqrt(y1336(N+1)^2 + y1336(N)^2 -2*cos(2*pi*34/N)*y1336(N+1)*y1336(N));
    freq_strength(7) = sqrt(y1477(N+1)^2 + y1477(N)^2 -2*cos(2*pi*38/N)*y1477(N+1)*y1477(N));
    freq_strength(8) = sqrt(y1633(N+1)^2 + y1633(N)^2 -2*cos(2*pi*42/N)*y1633(N+1)*y1633(N));
    
    % Scale within the range of [-1,1]
    freq_strength = 2*freq_strength/N;
    
    % Threshold
    threshold = sum(freq_strength)/4;
    
    % DTMF frequencies
    f = [697 770 852 941 1209 1336 1477 1633];
    
    % Frquency vector
    freq = [0  4000];
    
    % Update threshold on each iteration
    threshold = [threshold threshold];
    
    % Find indices where freq-strength is greater than threshold 
    idx = find(freq_strength > threshold(1));
    
    % Determine DTMF frequencies against max. indices found
    estimated_dtmf = f(idx);
    
    % Begin decoding the dominant frequencies
    switch estimated_dtmf(1)
        case {697}
            switch estimated_dtmf(2)
                case {1209}
                    output='1';
                case {1336}
                    output='2';
                case {1477}
                    output='3';
                case {1633}
                    output='A';
            end
        case {770}
            switch estimated_dtmf(2)
                case {1209}
                    output='4';
                case {1336}
                    output='5';
                case {1477}
                    output='6';
                case {1633}
                    output='B';
            end
        case {852}
            switch estimated_dtmf(2)
                case {1209}
                    output='7';
                case {1336}
                    output='8';
                case {1477}
                    output='9';
                case {1633}
                    output='C';
            end
        case {941}
            switch estimated_dtmf(2)
                case {1209}
                    output='*';
                case {1336}
                    output='0';
                case {1477}
                    output='#';
                case {1633}
                    output='D';
            end
    end
    
    % Decoded digits
    Decode_output = [Decode_output, output];
end

fprintf('Dialpad input: %s\n', test_keys)
fprintf('Decoded output: %s\n', Decode_output)
