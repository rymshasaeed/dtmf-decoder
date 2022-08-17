function [tones,Fs] = Key_generator(key, tone_duration, pause_duration)

% Key_generator() - Tones Generation Function
%
% ARGUMENTS:
%           key: dialpad numbers (dtype: string)
%           tone_duration: duration for dial tone (dtype: scalar)
%           pause_duration: mute interval in between the tones (dtype: scalar)
%           
% RETURNS:
%           tones: DTMF touch-tones (dtype: row vector)
%           Fs: sampling frequency  (dtype: scalar)


% Sampling frequency: twice of the highest frequency i.e. 2(4 kHZ)
Fs  = 8000;

% Initialize a vector for tone
x = zeros(1, tone_duration*Fs);
x(1) = 1;

% Initialize a vector for Pause in between the tones
Pause = zeros(1, pause_duration*Fs);

% Touch-tone frequencies
lfg = [697, 770, 852, 941];        % Low frequency group
hfg = [1209, 1336, 1477, 1633];    % High frequency group

% Dial tone generation
tones = [];
for i = 1:numel(key)
    switch key(i)
        case '1'
            f1 = hfg(1,1);
            f2 = lfg(1,1);
        case '2'
            f1 = hfg(1,2);
            f2 = lfg(1,1);
        case '3'
            f1 = hfg(1,3);
            f2 = lfg(1,1);
        case 'A'
            f1 = hfg(1,4);
            f2 = lfg(1,1);
        case '4'
            f1 = hfg(1,1);
            f2 = lfg(1,2);
        case '5'
            f1 = hfg(1,2);
            f2 = lfg(1,2);
        case '6'
            f1 = hfg(1,3);
            f2 = lfg(1,2);
        case 'B'
            f1 = hfg(1,4);
            f2 = lfg(1,2);
        case '7'
            f1 = hfg(1,1);
            f2 = lfg(1,3);
        case '8'
            f1 = hfg(1,2);
            f2 = lfg(1,3);
        case '9'
            f1 = hfg(1,3);
            f2 = lfg(1,3);
        case 'C'
            f1 = hfg(1,4);
            f2 = lfg(1,3);
        case '*'
            f1 = hfg(1,1);
            f2 = lfg(1,4);
        case '0'
            f1 = hfg(1,2);
            f2 = lfg(1,4);
        case '#'
            f1 = hfg(1,3);
            f2 = lfg(1,4);
        case 'D'
            f1 = hfg(1,4);
            f2 = lfg(1,4);
        otherwise
            disp('Invalid Input');
    end
    
    H_low = filter([0 sin(2*pi*f2/Fs)],[1 -2*cos(2*pi*f2/Fs) 1],x);
    H_high = filter([0 sin(2*pi*f1/Fs)],[1 -2*cos(2*pi*f1/Fs) 1],x);
    k = H_low + H_high;
    X = [k, Pause];
    tones = [tones, X];
end

% Normalize the tones (avoids clipping while writing to wav format)
tones = tones/max(abs(tones));

% Save tones as .wav file
audiowrite('tones.wav', tones, Fs);

end