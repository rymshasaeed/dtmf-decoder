% Define global variables
global dial_tone plot_1 plot_2

Fs = 8000;
t = (0:length(dial_tone)-1)/Fs;
plot_1 = subplot(2,3,2);
plot(t,dial_tone)
grid on
title('Dial-tone')
ylabel('Amplitude')
xlabel('Time (s)')

for i = 0:(length(dial_tone)/1421-1)
    % Select individual dialed digits, one at a time
    tone = dial_tone(1+1421*i:1421*(i+1));
    
    % Remove initial silence duration
    tone = tone(401:end);
    
    % Apply fft on the dialed signal
    Ak = 2*abs(fft(tone))/length(tone);Ak(1)=Ak(1)/2;
    f = (0:1:(length(tone)-1)/2)*Fs/length(tone);
    
    % Plot its spectrum
    plot_2 = subplot(2,3,5);
    plot(f, Ak(1:(length(tone)+1)/2))
    grid on
    title('Dialtone spectrum')
    ylabel('Amplitude')
    xlabel('Frequency (Hz)')
    axis([500 2000 0 1])
    
    % Play tone for the dialed digits
    soundsc(tone,Fs)
    pause(0.25)
end

% Write to local directory
audiowrite('dial_tone.wav', (dial_tone')/2, Fs);
