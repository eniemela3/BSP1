clear;

%% 1
data = load('521273S_data_lab6.mat.mat');
Fs = 1000; % Hz

%% 2
fields = fieldnames(data);
% for i = 1:length(fields)
%     figure;
%     plot(data.(fields{i}));
%     title(string(fields{i}));
% end

%% 3
intervals = cell(5,1);
intervals = {[600:23000],
             [225:21900],
             [725:17500],
             [450:20600],
             [1000:23000]};

for i = 1:length(intervals)
    data.(fields{2*i-1}) = data.(fields{2*i-1})(intervals{i});
    data.(fields{2*i}) = data.(fields{2*i})(intervals{i});
end

% for i = 1:length(fields)
%     figure;
%     plot(data.(fields{i}));
%     title(string(fields{i}));
% end

%% 4, 5, 6
peaks = cell(5,1);
window_len = 300; % ms
all_systoles = cell(5,1);
all_psds = cell(5,1);
avg_psds = cell(5,1);
mean_freqs = [];

for i = 1:length(peaks)
    field_ecg = join(['ECG_pat' string(i)], "");
    field_pcg = join(['PCG_pat' string(i)], "");
    
    % 5
    [peakOnsets, peakOffsets] = detectPeaks(Pan_Tompkins_Function(data.(field_ecg), Fs));
    peaks{i} = [peakOnsets, peakOffsets];
    
    % 4
    figure;
    subplot(3,1,1);
    plot(data.(field_ecg)(peakOnsets(1):peakOnsets(3)));
    subplot(3,1,2);
    plot(data.(field_pcg)(peakOnsets(1):peakOnsets(3)));
    subplot(3,1,3);
    spectrogram(data.(field_pcg)(peakOnsets(1):peakOnsets(3)), 50, 45, [], Fs, 'MinThreshold', -30, 'yaxis');
    
    % 6, 7
    systoles = [];
    welches = [];
    meanwelches = [];
    
    for j = 1:length(peakOnsets)
        try
            systole = data.(field_pcg)(peakOnsets(j):peakOnsets(j) + window_len);
            systoles(j,:) = systole;
            [welch, freq] = pwelch(systole, [], [], [], Fs);
            %meanwelch = mean(welch);
            %meanwelches(j) = meanwelch;
            welches(j,:) = welch;
        catch ME
        end     
    end
    all_systoles{i} = systoles;
    all_psds{i} = welches;
    avg_psds{i} = mean(welches);
    mean_freqs(i) = meanfreq(avg_psds{i}, freq);
end

%% 7
figure;
for i = 1:5
    subplot(5,3,3*i-2);
    plot(all_systoles{i}(1,:));
    title(join(['Patient ' string(i) ', First systole'], ""));
    xlabel('Time (s)');
    subplot(5,3,3*i-1);
    plot(freq, all_psds{i}(1,:));
    title('PSD');
    xlabel('Frequency (Hz)');
    subplot(5,3,3*i);
    plot(freq, avg_psds{i});
    title('Mean PSD');  
    xlabel('Frequency (Hz)');
end
    