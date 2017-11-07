clear;

signal1 = load("521273S_ecg_signal_1.dat");
signal2 = load("521273S_ecg_signal_2.dat");

Fs = 1000; % Hz
T = 1 / Fs;

%% 1

Fig1 = figure;
Fig2 = figure;

figure(Fig1);

subplot(5, 2, 1);
len1 = (length(signal1) -1 ) / Fs;
plot(0:T:len1, signal1);
set(gca,'XLim',[0 len1]);
xlabel("Time (s)");
title("Unfiltered signal 1");

subplot(5, 2, 2);
plot(0:T:len1, signal1);
set(gca, 'Xlim', [2 3]);
xlabel("Time (s)");

figure(Fig2);

subplot(5, 1, 1);
power1 = abs(fft(signal1, Fs));
plot(0:(Fs - 1), power1);
set(gca, 'Xlim', [0 Fs/2]);
xlabel("Frequency (Hz)");
title("Power spectrum of signal 1");
% should i do this with semilog instead? graph looks better this way

%% 2. Moving average filter

a1 = 1;
b1(1:10) = 1/10;
averaged = filter(b1, a1, signal1);

figure(Fig1);

subplot(5, 2, 3);
plot(0:T:len1, averaged);
set(gca,'XLim',[0 len1]);
xlabel("Time (s)");
title("Averaged signal 1");

subplot(5, 2, 4);
plot(0:T:len1, averaged);
set(gca, 'Xlim', [2 3]);
xlabel("Time (s)");

figure(Fig2);

subplot(5, 1, 2);
power2 = abs(fft(averaged, Fs));
plot(0:(Fs - 1), power2);
set(gca, 'Xlim', [0 Fs/2]);
xlabel("Frequency (Hz)");
title("Power spectrum of averaged signal 1");

response1 = freqz(b1, a1);
figure;
subplot(2, 1, 1);
plot(abs(response1));
title("Magnitude response");
xlabel("Frequency (Hz)");
subplot(2, 1, 2);
plot(angle(response1));
title("Phase response");
xlabel("Frequency (Hz)");

%% 3. Derivative based filter

a2 = [1 -0.995];
b2 = [1 -1] ./ T;
b2 = b2./real(max(freqz(b2, a2)));
derivated = filter(b2, a2, signal1);

figure(Fig1);

subplot(5, 2, 5);
plot(0:T:len1, derivated);
set(gca,'XLim',[0 len1]);
xlabel("Time (s)");
title("Derivative-filtered signal 1");

subplot(5, 2, 6);
plot(0:T:len1, derivated);
set(gca, 'Xlim', [2 3]);
xlabel("Time (s)");

figure(Fig2);

subplot(5, 1, 3);
power3 = abs(fft(derivated, Fs));
plot(0:(Fs - 1), power3);
set(gca, 'Xlim', [0 Fs/2]);
xlabel("Frequency (Hz)");
title("Power spectrum of derivative-filtered signal 1");

response2 = freqz(b2, a2);
figure;
subplot(2, 1, 1);
plot(abs(response2));
title("Magnitude response");
xlabel("Frequency (Hz)");
subplot(2, 1, 2);
plot(angle(response2));
title("Phase response");
xlabel("Frequency (Hz)");

%% 4. Comb filter

b_comb = [0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310];
a_comb = 1;

comb = filter(b_comb, a_comb, signal1);

figure(Fig1);

subplot(5, 2, 7);
plot(0:T:len1, comb);
set(gca,'XLim',[0 len1]);
xlabel("Time (s)");
title("Comb-filtered signal 1");

subplot(5, 2, 8);
plot(0:T:len1, comb);
set(gca, 'Xlim', [2 3]);
xlabel("Time (s)");

figure(Fig2);

subplot(5, 1, 4);
power4 = abs(fft(comb, Fs));
plot(0:(Fs - 1), power4);
set(gca, 'Xlim', [0 Fs/2]);
xlabel("Frequency (Hz)");
title("Power spectrum of comb-filtered signal 1");

response3 = freqz(b_comb, a_comb);
figure;
subplot(2, 1, 1);
plot(abs(response3));
title("Magnitude response");
xlabel("Frequency (Hz)");
subplot(2, 1, 2);
plot(angle(response3));
title("Phase response");
xlabel("Frequency (Hz)");

%% 5. Convolution of all 3 filters

a_conv = conv(a1, conv(a2, a_comb));
b_conv = conv(b1, conv(b2, b_comb));

convoluted = filter(b_conv, a_conv, signal1);

figure(Fig1);

subplot(5, 2, 9);
plot(0:T:len1, convoluted);
set(gca,'XLim',[0 len1]);
xlabel("Time (s)");
title("All filters on signal 1");

subplot(5, 2, 10);
plot(0:T:len1, convoluted);
set(gca, 'Xlim', [2 3]);
xlabel("Time (s)");

figure(Fig2);

subplot(5, 1, 5);
power5 = abs(fft(convoluted, Fs));
plot(0:(Fs - 1), power5);
set(gca, 'Xlim', [0 Fs/2]);
xlabel("Frequency (Hz)");
title("Power spectrum of all filters on signal 1");

response4 = freqz(b_conv, a_conv);
figure;
subplot(2, 1, 1);
plot(abs(response4));
title("Magnitude response");
xlabel("Frequency (Hz)");
subplot(2, 1, 2);
plot(angle(response4));
title("Phase response");
xlabel("Frequency (Hz)");