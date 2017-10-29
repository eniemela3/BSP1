function crossings = integer_crossings(data)

% Determines the locations of zero crossings in a signal

% The following code was used for help and inspiration:
% http://se.mathworks.com/matlabcentral/fileexchange/2432-crossing

% First look for exact zeros
zeros = find(data == 0);

% Then look for cases where two consecutive values are of different signs
prod = data(1:end-1) .* data(2:end);
crossings = find(prod < 0);

%Combining the two
crossings = sort([crossings zeros]);

end