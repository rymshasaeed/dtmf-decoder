% Define global variables
global keyNames dial_tone plot_2

% Set parameters
Fs = 8000;
t = (0:1:204*5)/Fs;
x = zeros(1, length(t));
x(1) = 1;

% Create a struct for dtmf keys and frequencies
dtmf.keys = ['1','2','3','A';
             '4','5','6','B';
             '7','8','9','C';
             '*','0','#','D'];
dtmf.colTones = ones(4,1)*[1209,1336,1477,1633];
dtmf.rowTones = [697;770;852;941]*ones(1,4);

% Find dialed key, (row and column for each keyname)
keyName = keyNames(length(keyNames));
[r, c] = find(dtmf.keys==keyName);

% Filter the dialed signal at dtmf frequencies
tone = filter([0 sin(2*pi*dtmf.rowTones(r,c)/Fs)], [1 -2*cos(2*pi*dtmf.rowTones(r,c)/Fs) 1],x) + ...
       filter([0 sin(2*pi*dtmf.colTones(r,c)/Fs)], [1 -2*cos(2*pi*dtmf.colTones(r,c)/Fs) 1],x);

% Play dialed tones and write to global variable
soundsc(tone,Fs);
dial_tone = [dial_tone, zeros(1,400),tone];

% Apply fft on the dialed signal
Ak = 2*abs(fft(tone))/length(tone);
Ak(1)= Ak(1)/2;
f = (0:1:(length(tone)-1)/2)*Fs/length(tone);

% Plot its spectrum
plot_2 = subplot(2,3,5);
plot(f, Ak(1:(length(tone)+1)/2))
grid on
title('Dialtone spectrum')
ylabel('Amplitude')
xlabel('Frequency (Hz)')
axis([500 2000 0 1])
