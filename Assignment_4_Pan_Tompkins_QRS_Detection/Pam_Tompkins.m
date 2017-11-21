clear
close all;
%% 1 Prepare signal

ecg = load("521273S_ecg.txt.txt");
ecg = ecg - ecg(1);
dataset(1, :) = ecg;

%% LPF

b1 = [1 0 0 0 0 0 -2 0 0 0 0 0 1];
a1 = [1 -2 1] * 32;
lpf = filter(b1, a1, ecg);
dataset(2, :) = lpf;

%% HPF

b2 = zeros(1, 33);
b2(1) = -1/32; b2(17) = 1; b2(18) = 1; b2(33) = 1/32;
a2 = [1 -1];
hpf = filter(b1, a1, lpf);
dataset(3, :) = hpf;

%% Derivative

b3 = [1 2 0 -2 -1];
a3 = 8;
der = filter(b3, a3, hpf);
dataset(4, :) = der;

%% Squaring

sq = der .^ 2;
dataset(5, :) = sq;

%% Integration

b4 = ones(1, 30);
a4 = 30;
int = filter(b4, a4, sq);
dataset(6, :) = int;

%% Plotting data
titles = ["Original", "Low Pass", "High Pass", "Derivative", "Squaring", "Integration"];
Fs = 200;
len = length(ecg) / Fs;

%% QRS detection

[QRSstart, QRSend] = findqrs(int, 50, 700, 950);

plotting2(dataset, titles, Fs, len, QRSstart, QRSend);