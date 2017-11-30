clear;

%% 1
data = load('521273S_emgforce.txt');
time = data(:,1);
force = data(:,2);
EMG = data(:,3);

%% 2
force = rescale(force, 0, 100);

%% 3
EMG = EMG - mean(EMG);

%% 4
figure;

subplot(2,1,1);
plot(time, force);
xlabel('Time ( s)');
ylabel('Force (%)');
hold;

subplot(2,1,2);
plot(time, EMG);
xlabel('Time ( s)');
ylabel('EMG (mV)');
hold;

%% 5
threshold = 10;
BEG = 1;
END = 1;
BEGs = [];
ENDs = [];
round = 1;
while ((BEG < length(time)) && (END < length(time)))
    while (force(BEG) < threshold)
        BEG = BEG + 1;
        if BEG > length(force)
            break;
        end
    end
    BEGs(round) = BEG;
    END = BEG + 1;
    if END > length(force)
        break;
    end
    while (force(END) > threshold)
        END = END + 1;
        if END > length(force)
            break;
        end
    end
    ENDs(round) = END;
    round = round + 1;
    BEG = END + 1;
end

BEGs = BEGs(1:length(BEGs)-1); % to account for last sample being added to "BEGs"

segments = cell(length(ENDs), 1);
MAXs = [];
for i = 1:length(ENDs)
    segments{i} = force(BEGs(i):ENDs(i));
    MAXs(i) = max(segments{i});
end

BEGs07 = [];
ENDs07 = [];
BEG07 = 1;
END07 = 1;

for i = 1:length(segments)
    while segments{i}(BEG07) < 0.7 * MAXs(i)
        BEG07 = BEG07 + 1;
        if BEG07 >= length(segments{i})
            break;
        end
    end
    BEGs07(i) = BEG07;
    END07 = BEG07 + 1;
    while segments{i}(END07) > 0.7 * MAXs(i)
        END07 = END07 + 1;
        if END07 >= length(segments{i})
            break;
        end
    end
    ENDs07(i) = END07;
end

%% 6
Fs = 2000; % Hz

subplot(2,1,1);
stem(BEGs ./ Fs, ones(1, length(BEGs)), 'k');
stem(ENDs ./ Fs, ones(1, length(ENDs)), 'k');

stem((BEGs07 + BEGs) ./ Fs, ones(1, length(BEGs07)), 'r');
stem((ENDs07 + BEGs) ./ Fs, ones(1, length(ENDs07)), 'r');

%% 7
forces07 = cell(length(ENDs07), 1); 
MEANs = [];
for i = 1:length(forces07)
    forces07{i} = force(BEGs(i) + BEGs07(i):BEGs(i) + ENDs07(i));
    MEANs(i) = mean(forces07{i});
end

%% 8
EMGs07 = cell(length(ENDs07), 1);
DRs = [];
for i = 1:length(EMGs07)
    EMGs07{i} = EMG(BEGs(i) + BEGs07(i):BEGs(i) + ENDs07(i));
    DRs(i) = max(EMGs07{i}) - min(EMGs07{i});
end

%% 9
MSs = [];
for i = 1:length(EMGs07)
    MSs(i) = sum(EMGs07{i}.^2) / length(EMGs07{i});
end

%% 10
ZCRs = [];

for i = 1:length(EMGs07)
    % First look for exact zeros
    zeros = find(EMGs07{i} == 0);

    % Then look for cases where two consecutive values are of different signs
    prod = EMGs07{i}(1:end-1) .* EMGs07{i}(2:end);
    crossings = find(prod < 0);
    
    ZCRs(i) = (length(zeros) + length(crossings)) / length(EMGs07{i}) * Fs;
end

%% 11
figure;

subplot(3,1,1);
%title('DR vs % MVC');
plot(MEANs, DRs);
ylabel('DR (mV)');
xlabel('% MVC');
hold;

subplot(3,1,2);
%title('MS vs % MVC');
plot(MEANs, MSs);
ylabel('MS');
xlabel('% MVC');
hold;

subplot(3,1,3);
%title('ZCR vs % MVC');
plot(MEANs, ZCRs);
ylabel('ZCR (Hz)');
xlabel('% MVC');
hold;

%% 13
grid = 0:100;

DR_coeffs = polyfit(MEANs, DRs, 1);
DR_eval = polyval(DR_coeffs, grid);
subplot(3,1,1);
plot(DR_eval);

MS_coeffs = polyfit(MEANs, MSs, 1);
MS_eval = polyval(MS_coeffs, grid);
subplot(3,1,2);
plot(MS_eval);

ZCR_coeffs = polyfit(MEANs, ZCRs, 1);
ZCR_eval = polyval(ZCR_coeffs, grid);
subplot(3,1,3);
plot(ZCR_eval);

%% 13

corrcoef_DR = corrcoef(DR_eval(floor(MEANs)), DRs);
corrcoef_MS = corrcoef(MS_eval(floor(MEANs)), MSs);
corrcoef_ZCR = corrcoef(ZCR_eval(floor(MEANs)), ZCRs);