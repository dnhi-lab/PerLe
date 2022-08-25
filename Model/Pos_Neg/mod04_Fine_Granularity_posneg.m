%% sweepmodel
% Complex model, one free parameter. Taken from Rosenblau et al., 2018
% ER = y * (ER + a*PE) + (1-y) * OP

%% Function
function sumSquareError = mod04_Fine_Granularity_posneg(data, param, sweepCorr)
learnVec = zeros(length(data),1);
sweepVec = zeros(length(data),1);
resetVal = [1; diff(data(:,4))];
global startVal
    
pos = param(1);
if length(param) == 2
    strt = startVal;
    neg  = param(2);
else
    strt = param(2);
    neg  = param(3);
end

for i = 1:length(data)
    % For each new profile you need to reset
    if(resetVal(i) == 1)
        spaceVec = zeros( length(sweepCorr), 1) +  strt;
    end
    
    learnVec(i) = spaceVec(data(i,7));           
    delta = data(i,2) - learnVec(i);
    if delta < 0
        spaceVec = spaceVec + pos * delta * sweepCorr(:, data(i,7));
    else
        spaceVec = spaceVec + neg * delta * sweepCorr(:, data(i,7));
    end

    sweepVec(i) = learnVec(i);
end
% Add bounding that is lacking in fminsearch
if pos < 0 || pos > 1
    sumSquareError = 10^25;
elseif strt < 0 || strt > 8
     sumSquareError = 10^25;
elseif neg < 0 || neg > 1
    sumSquareError = 10^25;
else
    sumSquareError = sum( ( data(:,1) - sweepVec ).^2 );
end