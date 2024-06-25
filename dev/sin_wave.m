% Generate sin wave for fir_test_tb.sv, write in .mem for ROM
% -----------------
% Compatitive coefficients:
%   sample rate: 48000 hz
%   fc: 2000hz
%   fs: 14000hz
%   fir: equiripple, low pass, 4-tap
%   coef: 8 bits, fixed points

fs = 48000;
width = 8;        % ROM
depth = 1024;     % ROM

% low freq, to pass
f_low = 1000;
t = (0:depth-1)/fs; % timing vector
y_sin_low = sin(2*pi*f_low*t);  

% high freq, stop
f_high = 15000;
y_sin_high = sin(2*pi*f_high*t);

% middle, decay, to test stability
f_mid = 7000;
y_sin_mid = sin(2*pi*f_mid*t);

% combined, simulation
y_sin_combined = y_sin_low + y_sin_high + y_sin_mid;

% remove illegal data
y_sin_low_int = round(y_sin_low * (2^(width-1)-1)) + 2^(width-1) - 1;    
y_sin_high_int = round(y_sin_high * (2^(width-1)-1)) + 2^(width-1) - 1;    
y_sin_mid_int = round(y_sin_mid * (2^(width-1)-1)) + 2^(width-1) - 1;    
y_sin_combined_int = round(y_sin_combined * (2^(width-1)-1)) + 2^(width-1) - 1;    

% check illegal hex
y_sin_combined_int(y_sin_combined_int < 0 | y_sin_combined_int > 2^width - 1) = 0;

% gen .mem
fid_low = fopen('wave/sin_low.mem', 'w');
fprintf(fid_low, '%x\n', y_sin_low_int); 
fclose(fid_low);

fid_high = fopen('wave/sin_high.mem', 'w');
fprintf(fid_high, '%x\n', y_sin_high_int); 
fclose(fid_high);

fid_mid = fopen('wave/sin_mid.mem', 'w');
fprintf(fid_mid, '%x\n', y_sin_mid_int); 
fclose(fid_mid);

fid_combined = fopen('wave/sin_combined.mem', 'w');
fprintf(fid_combined, '%x\n', y_sin_combined_int); 
fclose(fid_combined);

% vis
figure;
subplot(4, 1, 1);
plot(t, y_sin_low);
title('低于2000Hz的正弦波 (1000Hz)');
xlabel('时间 (秒)');
ylabel('幅值');
grid on;

subplot(4, 1, 2);
plot(t, y_sin_mid);
title('在2000Hz和14000Hz之间的正弦波 (7000Hz)');
xlabel('时间 (秒)');
ylabel('幅值');
grid on;

subplot(4, 1, 3);
plot(t, y_sin_high);
title('高于14000Hz的正弦波 (15000Hz)');
xlabel('时间 (秒)');
ylabel('幅值');
grid on;

subplot(4, 1, 4);
plot(t, y_sin_combined);
title('合成波形 (1000Hz, 7000Hz 和 15000Hz)');
xlabel('时间 (秒)');
ylabel('幅值');
grid on;
