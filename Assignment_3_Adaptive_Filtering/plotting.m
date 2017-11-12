function plotting(datasets, titles, Fs, time)

figure;

rounds = length(titles);

for i = 1:rounds
    subplot(3, 1, i);
    len = (length(datasets(i, :)) -1 ) / Fs;
    plot(0:1/Fs:len, datasets(i, :));
    set(gca,'XLim',[0 time]);
    title(titles(i));
    xlabel("Time (s)");
    ylabel("Amplitude (mV)");    
end

hold;
plot(0:1/Fs:len, datasets(i+1, :));
    
end