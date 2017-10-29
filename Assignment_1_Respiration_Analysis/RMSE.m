function rmse = RMSE(data1, data2)

squares = (data1 - data2) .^2;
residual_sum = sum(squares);
rmse = sqrt(residual_sum / length(data1));
end