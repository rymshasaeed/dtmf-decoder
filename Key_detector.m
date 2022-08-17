function key = Key_detector(filename, tone_duration, pause_duration)

% Key_detector() - Dialpad keys detection function
%
% ARGUMENTS:
%           filename: audiofile of DTMF touch-tones (dtype: .mp3/.wav/.ogg/.flac/.au)
%           tone_duration: duration for dial tone (dtype: scalar)
%           pause_duration: mute interval in between the tones (dtype: scalar)
%           
% RETURNS:
%           key: decoded dialpad numbers (dtype: string)


% Touch-tone frequencies
lfg = [697, 770, 852, 941];        % Low frequency group 
hfg = [1209, 1336, 1477, 1633];    % High frequency group

% Touch-tone frequencies within 1.5% deviation
dtmf = [lfg(:);hfg(:)];
P = dtmf + dtmf*1.5/100;
N = dtmf - dtmf*1.5/10;

% Read touch-tones
[tones,Fs] = audioread(filename);

% Sort tones into separate vectors
n = int16((tone_duration + pause_duration)*Fs);
tones = reshape(tones,n,[]);
    
for i = 1 : size(tones,2)
    % Separate the tone from pause
    n = numel(tones(:,i)) - pause_duration*Fs;
    tone = tones(1:n, i);
    
    % Compute frequency response
    [mag, freq] = freqz(tone, Fs);
    mag = abs(mag);
    freq = freq*Fs/2/pi;
    
    % Find peak frequencies in each tone
    [~, idx1] = max(mag);
    mag(idx1) = -Inf;
    [~, idx2] = max(mag);
    
    if idx1 > idx2
        f_high = freq(idx1);
        f_low = freq(idx2);
    else
        f_high = freq(idx2);
        f_low = freq(idx1);
    end
    
    if f_low>N(1) && f_low<P(1)        
        if f_high>N(5) && f_high<P(5)
            key(i) = '1';
        elseif f_high>N(6) && f_high<P(6)
            key(i) = '2';
        elseif f_high>N(7) && f_high<P(7)
            key(i) = '3';
        elseif f_high>N(8) && f_high<P(8)
            key(i) = 'A';            
        end
    elseif f_low>N(2) && f_low<P(2)
        if f_high>N(5) && f_high<P(5)
            key(i) = '4';
        elseif f_high>N(6) && f_high<P(6)
            key(i) = '5';
        elseif f_high>N(7) && f_high<P(7)
            key(i) = '6';
        elseif f_high>N(8) && f_high<P(8)
            key(i) = 'B';
        end
    elseif f_low>N(3) && f_low<P(3)
        if f_high>N(5) && f_high<P(5)
            key(i) = '7';
        elseif f_high>N(6) && f_high<P(6)
            key(i) = '8';
        elseif f_high>N(7) && f_high<P(7)
            key(i) = '9';
        elseif f_high>N(8) && f_high<P(8)
            key(i) = 'C';
        end
    elseif f_low>N(4) && f_low<P(4)
        if f_high>N(5) && f_high<P(5)
            key(i) = '*';
        elseif f_high>N(6) && f_high<P(6)
            key(i) = '0';
        elseif f_high>N(7) && f_high<P(7)
            key(i) = '#';
        elseif f_high>N(8) && f_high<P(8)
            key(i) = 'D';
        end
    end    
end
end