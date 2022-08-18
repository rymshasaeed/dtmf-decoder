clc, clearvars, close all

%% Define global variables
global keyNames dial_tone plot_1 plot_2 plot_3 plot_4 Decode_output
keyNames = [];
dial_tone = [];
Decode_output = [];

%% GUI Window
set(gcf,'WindowState', 'maximized','Name','DTMF Encoder-Decoder');

%% Set plots layout
plot_1 = subplot(2,3,2);
grid on
title('Dial-tone')
ylabel('Amplitude')
xlabel('Time (s)')
axis([0 0.035 -2 2])

plot_2 = subplot(2,3,5);
grid on
title('Dialtone spectrum')
ylabel('Amplitude')
xlabel('Frequency (Hz)')
axis([500 2000 0 1])

plot_3 = subplot(2,3,3);
grid on
title('Bandpass filter responses')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
axis([500 2000 0 1])

plot_4 = subplot(2,3,6);
grid on
title('Decoded dialtone spectrum')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
axis([500 2000 0 1])

%% Buttons
% Get screen size
Size = get(0, 'ScreenSize');

% Initial position
pos_init = [Size(1)+100, Size(4)-300];

% Inital size
size_init = 50;

%% UI Elements
% Dialed digits
InputDisplay = uicontrol('Style', 'text', 'Position', [pos_init+[0 size_init*2],150,30],'String','Dialed digits','FontSize',15,'HorizontalAlignment','left');
Display = uicontrol('Style', 'edit', 'Position',[pos_init+[0 size_init*1.3],315,30],'String','KeyNames','FontSize',15,'HorizontalAlignment','left','BackgroundColor',[0.98 0.98 0.98]);
set(Display, 'String', keyNames);

% Dialpad buttons
button1 = uicontrol;
set(button1,'String','1','Position',[pos_init(1)+50, pos_init(2),repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button1,'Callback','button_1');

button2 = uicontrol;
set(button2,'String','2','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*1 0],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button2,'Callback','button_2');

button3 = uicontrol;
set(button3,'String','3','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*2 0],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button3,'Callback','button_3');

buttonA = uicontrol;
set(buttonA,'String','A','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*3 0],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(buttonA,'Callback','button_A');

button4 = uicontrol;
set(button4,'String','4','Position',[[pos_init(1)+50, pos_init(2)]+[0 -size_init*1],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button4,'Callback','button_4');

button5 = uicontrol;
set(button5,'String','5','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*1 -size_init*1],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button5,'Callback','button_5');

button6 = uicontrol;
set(button6,'String','6','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*2 -size_init*1],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button6,'Callback','button_6');

buttonB = uicontrol;
set(buttonB,'String','B','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*3 -size_init*1],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(buttonB,'Callback','button_B');

button7 = uicontrol;
set(button7,'String','7','Position',[[pos_init(1)+50, pos_init(2)]+[0 -size_init*2],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button7,'Callback','button_7');

button8 = uicontrol;
set(button8,'String','8','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*1 -size_init*2],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button8,'Callback','button_8');

button9 = uicontrol;
set(button9,'String','9','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*2 -size_init*2],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button9,'Callback','button_9');

buttonC = uicontrol;
set(buttonC,'String','C','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*3 -size_init*2],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(buttonC,'Callback','button_C');

buttonStar = uicontrol;
set(buttonStar,'String','*','Position',[[pos_init(1)+50, pos_init(2)]+[0 -size_init*3],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(buttonStar,'Callback','button_Star');

button0 = uicontrol;
set(button0,'String','0','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*1 -size_init*3],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(button0,'Callback','button_0');

buttonSign = uicontrol;
set(buttonSign,'String','#','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*2 -size_init*3],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(buttonSign,'Callback','button_Sign');

buttonD = uicontrol;
set(buttonD,'String','D','Position',[[pos_init(1)+50, pos_init(2)]+[size_init*3 -size_init*3],repmat(size_init,1,2)],'BackgroundColor',[0.75 0.85 0.90]);
set(buttonD,'Callback','button_D');

buttonDialtone = uicontrol;
set(buttonDialtone,'String','Generate dialtone','FontSize',10,'Position',[[pos_init(1)+50, pos_init(2)]+[0 -size_init*4],size_init*4,size_init],'BackgroundColor',[115, 167, 191]/255);
set(buttonDialtone,'Callback','button_Dialtone');

buttonDecode = uicontrol;
set(buttonDecode,'String','Decode','FontSize',10,'Position',[[pos_init(1)+50, pos_init(2)]+[0 -size_init*5],size_init*4,size_init],'BackgroundColor',[149, 209, 237]/255);
set(buttonDecode,'Callback','Key_detector');

buttonClear = uicontrol;
set(buttonClear,'String','Clear','FontSize',10,'Position',[[pos_init(1)+50, pos_init(2)]+[0 -size_init*6],size_init*4,size_init],'BackgroundColor',[189, 234, 255]/255);
set(buttonClear,'Callback','button_Clear');

DecodeDisplay = uicontrol('Style', 'text', 'Position',[pos_init+[0 -size_init*7],150,30],'String', 'Decoded digits','FontSize',15,'HorizontalAlignment','left');
Display2 = uicontrol('Style', 'edit', 'Position',[pos_init+[0 -size_init*7.7],315,30],'String', 'KeyNames','FontSize',15,'HorizontalAlignment','left','BackgroundColor',[0.98 0.98 0.98]);

set(Display2,'String',Decode_output);