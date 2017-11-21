function plotting2(datasets, titles, Fs, time, QRSstart, QRSend)

figure;

rounds = length(titles);

QRSstarts = ones(1, length(QRSstart));
QRSends = ones(1, length(QRSend));

for i = 1:rounds
    subplot(rounds, 1, i);
    len = (length(datasets(i, :)) -1 ) / Fs;
    plot(0:1/Fs:len, datasets(i, :));
    set(gca,'XLim',[0 time]);
    title(titles(i));
    xlabel("Time (s)");
    ylabel("Amplitude"); 
    if (i == 1)
        hold;
        stem(QRSstart / Fs - 0.105, QRSstarts * 1000, 'Marker', 'none');
        stem(QRSend / Fs - 0.105, QRSends * 1000, 'Marker', 'none');
    else if (i == 6)
        hold;
        stem(QRSstart / Fs, QRSstarts * 2000, 'Marker', 'none');
        stem(QRSend / Fs, QRSends * 2000, 'Marker', 'none');
    end
end

end