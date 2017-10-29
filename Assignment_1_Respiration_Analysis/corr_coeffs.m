function coeffs = corr_coeffs(data1, data2)

mean1 = mean(data1);
mean2 = mean(data2);
prod = data1 .* data2;
sq1 = data1.^2;
sq2 = data2.^2;
len = length(data1);

coeffs = sqrt((sum(prod) - len * mean1 * mean2).^2 / ...
         (sum(sq1) - len * mean1.^2) / (sum(sq2) - len * mean2.^2));
end