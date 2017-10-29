clear;

%% Loading data from files

beltsignals = load("521273S_beltsignals.txt");
chest = beltsignals(:, 1);
abdomen = beltsignals(:, 2);

spirometer = load("521273S_spirometer.txt");
regression1 = load("521273S_regressioncoefficients1.txt");
regression2 = load("521273S_regressioncoefficients2.txt");
regression3 = load("521273S_regressioncoefficients3.txt");

%% Downsampling spirometer signal to 50 Hz

originalFrequency = 100; % Hz
newFrequency = 50; % Hz
spirometer = resample(spirometer, newFrequency, originalFrequency); % this takes a while to run!

%% Computing predicted respiratory air flows

estimate1 = regression1(1) .* chest + regression1(2) .* abdomen;
estimate2 = regression2(1) .* chest + regression2(2) .* abdomen + ...
            regression2(3) .* chest .^2 + regression2(4) .* abdomen .^2;
estimate3 = regression3(1) .* chest + regression3(2) .* abdomen + ...
            regression3(3) .* chest .* abdomen;
        
%% Evaluation of models

corr_coeffs1a = corr_coeffs(estimate1, spirometer);
corr_coeffs2a = corr_coeffs(estimate2, spirometer);
corr_coeffs3a = corr_coeffs(estimate3, spirometer);

corr_coeffs1b = corrcoef(estimate1, spirometer);
corr_coeffs2b = corrcoef(estimate2, spirometer);
corr_coeffs3b = corrcoef(estimate3, spirometer);

rmse1 = RMSE(estimate1, spirometer);
rmse2 = RMSE(estimate2, spirometer);
rmse3 = RMSE(estimate3, spirometer);

%% Figures

figure;

subplot(2, 1, 1); 
hold;
plot(spirometer, "k");
plot(estimate1, "r");
plot(estimate2, "b");
plot(estimate3, "g");
title("Real and predicted air flows");
xlabel("Time (s)"); 
ylabel("Respiratory Air Flow");

subplot(2, 1, 2);
hold;
title("Respiratory belt signals");
xlabel("Time (s)");
ylabel("Respiratory Air Flow");
plot(chest, "b");
plot(abdomen, "g");

%% Respiratory rate

crossings = integer_crossings(spirometer) ./ newFrequency; % s
frequencies = 1 ./ (2 *(crossings(2:end) - crossings(1:end-1))); % Hz
rates = frequencies * 60; % breaths per minute
rate_average = mean(rates);