%% rlselfmodel
% combination of RL & self-rating
% rating = a*Vt + (1-a)own

%% Function
function [fittedValue, predict, learnAndSelfVec] = rlselfmodel(data, param)
learnVec        = zeros(length(data),1);
learnAndSelfVec = zeros(length(data),1);
global startVal getFit

if length(param) == 2
    strt = startVal;
else
    strt = param(3);
end

for i = 1:length(data)
    % This is the reset for a new profile, resets are column 5
    if(data(i,5) == 1)
        learnVec(i) = strt;
    end

    delta = data(i,2) - learnVec(i);
    learnVec(i+1) = learnVec(i) + param(1) * delta;
    learnAndSelfVec(i) = param(2) * learnVec(i) + (1 - param(2)) * data(i,3);
end

% Since we use fminsearch (No bound)
if param(1) < 0 || param(1) > 1
    fittedValue = 10^25;
elseif param(2) < 0 || param(2) > 1
    fittedValue = 10^25;
% elseif strt < 0 || strt > 8
%     fittedValue = 10^25;
else
    getFit = [learnAndSelfVec - data(:,1) data(:,5)];
    [fittedValue, predict] = modelFit(data, learnAndSelfVec);
end