%%
clear

%%

signals1 = load("521273S_signals1.mat");
signals2 = load("521273S_signals2.mat");

mhb = signals1.mhb;
fhb = signals1.fhb;
abd_sig1 = signals1.abd_sig1;
abd_sig2 = signals1.abd_sig2;
abd_sig3 = signals1.abd_sig3;

RRiInput = signals2.RRiInput;
RespReference = signals2.RespReference;

Fs1 = 1000; % Hz
Fs2 = 4; % Hz

%% Case 1
dataset1(1,:) = mhb;
dataset1(2,:) = abd_sig1;

c1 = 0.999; % optimized
energy1 = 186;
mu1 = c1 / energy1;
FIR_length1 = 7; % optimized

lmsfilt1 = dsp.LMSFilter('Length', FIR_length1, 'StepSize', mu1); 

dataset1(3,:) = fhb;
[filtered1, output1] = lmsfilt1(mhb, abd_sig1);
dataset1(4,:) = output1;

titles1 = ["mhb", "abd\_sig1", "LMSFilt estimate"];
plotting(dataset1, titles1, Fs1, 10);

corrcoef1 = corrcoef(fhb, output1);
mse1 = immse(fhb, output1);

%% Case 2
dataset2(1,:) = mhb;
dataset2(2,:) = abd_sig2;

c2 = 0.999; % optimized
energy2 = 186;
mu2 = c2 / energy2;
FIR_length2 = 9; % optimized

lmsfilt2 = dsp.LMSFilter('Length', FIR_length2, 'StepSize', mu2); 

dataset2(3,:) = fhb;
[filtered2, output2] = lmsfilt2(mhb, abd_sig2);
dataset2(4,:) = output2;

titles2 = ["mhb", "abd\_sig2", "LMSFilt estimate"];
plotting(dataset2, titles2, Fs1, 10);

corrcoef2 = corrcoef(fhb, output2);
mse2 = immse(fhb, output2);

%% Case 3
dataset3(1,:) = mhb;
dataset3(2,:) = abd_sig3;

c3 = 0.999; % optimized
energy3 = 186;
mu3 = c3 / energy3;
FIR_length3 = 21; % optimized

lmsfilt3 = dsp.LMSFilter('Length', FIR_length3, 'StepSize', mu3); 

dataset3(3,:) = fhb;
[filtered3, output3] = lmsfilt3(mhb, abd_sig3);
dataset3(4,:) = output3;

titles3 = ["mhb", "abd\_sig3", "LMSFilt estimate"];
plotting(dataset3, titles3, Fs1, 10);

corrcoef3 = corrcoef(fhb, output3);
mse3 = immse(fhb, output3);

%% Case 4
dataset4(1,:) = RRiInput;
dataset4(2,:) = RespReference;

c4 = 0.999; % optimized
energy4 = 93;
mu4 = c4 / energy4;
FIR_length4 = 1; % optimized

lmsfilt4 = dsp.LMSFilter('Length', FIR_length4, 'StepSize', mu4); 

dataset4(3,:) = RespReference;
[filtered4, output4] = lmsfilt4(RespReference, RRiInput);
dataset4(4,:) = filtered4;

time4 = length(RRiInput) / Fs2;

titles4 = ["RRiInput", "RespReference", "LMSFilt result"];
plotting(dataset4, titles4, Fs2, time4);

corrcoef4 = corrcoef(RespReference, filtered4);
mse4 = immse(RespReference, filtered4);


%%
%close all;