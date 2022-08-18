clc, clearvars, close all

% Can be varied as per ITU or Bellcore recommendations 
tone_duration = 100e-3;
pause_duration = 50e-3;

%% Testing on user defined key
disp('Testing user-defined digits....')
dialed = input('Dial any number: ', 's');

% Tones generation
[tones, Fs] = Key_generator(dialed, tone_duration, pause_duration);

% Detection
decoded = Key_detector('tones.wav', tone_duration, pause_duration);
fprintf('Decoded: %s\n\n', decoded)

% Plot tones in time domain
t = (0:1:numel(tones)-1)/Fs;
figure(1);
plot(t, tones)
xlabel('Duration (s)')
ylabel('Amplitude')
title({['Time domain representation'], ['8 tones - ' num2str(dialed)]})
grid on
axis tight

% Play dialed keys
soundsc(tones, Fs)

%% Testing for all keys
disp('Testing for all Dialpad keys....')

% Dialpad keys
all_keys = '123A456B789C*0#D';
fprintf('All keys: %s\n', all_keys)

% Tones generation
[tones, Fs] = Key_generator(all_keys, tone_duration, pause_duration);

% Detection
decoded = Key_detector('tones.wav', tone_duration, pause_duration);
fprintf('Decoded: %s\n\n', decoded)

% Sort tones into separate vectors
n = int16((tone_duration + pause_duration)*Fs);
tones = reshape(tones,n,[]);

% Separate the tone from pause
n = size(tones,1) - pause_duration*Fs;
tones = tones(1:n, :);

% Plot each tone separately
for i = 1:numel(all_keys)
    % in time domain
    figure(2);
    subplot(4,4,i)
    plot((0:1:n-1)/Fs, tones(1:n,i))
    title(num2str(all_keys(i)))    
    grid on
    
    % in frequency domain
    [mag, freq] = freqz(tones(:,i));
    figure(3);
    subplot(4,4,i)
    plot(freq*Fs/2/pi, abs(mag)/max(abs(mag)))
    xlim([0 2000])
    title(num2str(all_keys(i)))
    grid on
end
figure(2); sgtitle('Time domain representation')
figure(3); sgtitle('Frequency domain representation')

%% Testing for detection by adding white Gaussian noise
disp('Testing noisy tones....')
dialed = '#A62442';
fprintf('Dialed: %s\n',dialed)

% Tones generation
[tones, Fs] = Key_generator(dialed, tone_duration, pause_duration);

% Add white noise to each tone
tones = awgn(tones, 10);

% Detection
decoded = Key_detector('tones.wav', tone_duration, pause_duration);
fprintf('Detected: %s\n',decoded)

% Plot noisy tones in time domain
t = (0:1:numel(tones)-1)/Fs;
figure(4);
plot(t, tones)
xlabel('Duration (s)')
ylabel('Amplitude')
title({'8 Noisy tones', num2str(dialed)})
grid on
axis tight

% Play noisy tones
soundsc(tones, Fs)
