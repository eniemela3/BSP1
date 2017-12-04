function ecg = Pan_Tompkins_Function(ecg, Fs)

if Fs ~= 200
    resample(ecg, 200, Fs);
end
ecg = ecg - ecg(1);

%% LPF

b1 = [1 0 0 0 0 0 -2 0 0 0 0 0 1];
a1 = [1 -2 1] * 32;
ecg = filter(b1, a1, ecg);

%% HPF

b2 = zeros(1, 33);
b2(1) = -1/32; b2(17) = 1; b2(18) = -1; b2(33) = 1/32;
a2 = [1 -1];
ecg = filter(b2, a2, ecg);

%% Derivative
b3 = [1 2 0 -2 -1];
a3 = 8;
ecg = filter(b3, a3, ecg);

%% Squaring

ecg = ecg .^ 2;

%% Integration

b4 = ones(1, 30);
a4 = 30;
ecg = filter(b4, a4, ecg);

