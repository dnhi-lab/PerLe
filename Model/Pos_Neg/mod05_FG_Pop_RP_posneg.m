%% fitting_fminsearch_sweepmodelself
% Complex model, one free parameter. Taken from Rosenblau et al., 2018
% ER = y * (ER + a*PE) + (1-y) * OP

%% Function
function sumSquareError = mod05_FG_Pop_RP_posneg(data, param, sweepCorr)
learnVec = zeros(length(data),1);
sweepVec = zeros(length(data),1);
resetVal = [1; diff(data(:,4))];
global startVal

pos = param(1);
if length(param) == 3
    strt = startVal;
    neg  = param(3);
else
    strt = param(3);
    neg  = param(4);
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

    sweepVec(i) = learnVec(i) * param(2) + (1-param(2))*data(i,3);
end

if pos < 0 || pos > 1
    sumSquareError = 10^25;
elseif param(2) < 0 || param(2) > 1
    sumSquareError = 10^25;
elseif strt < 0 || strt > 8
    sumSquareError = 10^25;
elseif neg < 0 || neg > 1
    sumSquareError = 10^25;
else
    sumSquareError = sum( ( data(:,1) - sweepVec ).^2 );
end
