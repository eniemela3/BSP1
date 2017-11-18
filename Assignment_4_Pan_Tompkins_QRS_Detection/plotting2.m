function plotting2(datasets, titles, Fs, time)

figure;

rounds = length(titles);

for i = 1:rounds
    subplot(rounds, 1, i);
    len = (length(datasets(i, :)) -1 ) / Fs;
    plot(0:1/Fs:len, datasets(i, :));
    set(gca,'XLim',[0 time]);
    title(titles(i));
    xlabel("Time (s)");
    ylabel("Amplitude");    
end
    
end