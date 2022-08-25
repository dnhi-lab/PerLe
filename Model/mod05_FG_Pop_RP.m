%% fitting_fminsearch_sweepmodelself
% ER = y * (ER + a*PE) + (1-y) * OP

%% Function
function [fittedValue, predict, sweepVec] = mod05_FG_Pop_RP(data, param, sweepCorr)
learnVec = zeros(length(data),1);
sweepVec = zeros(length(data),1);
resetVal = [1; diff(data(:,4))];
global startVal getFit %getOpt

if length(param) == 2
    strt = startVal;
else
    strt = param(3);
end

for i = 1:length(data)
    % For each new profile you need to reset
    if(resetVal(i) == 1)
        spaceVec = zeros( length(sweepCorr), 1) +  strt;
    end
    
    learnVec(i) = spaceVec(data(i,7));           
    delta = data(i,2) - learnVec(i);

    spaceVec = spaceVec + param(1) * delta * sweepCorr(:, data(i,7));

    sweepVec(i) = learnVec(i) * param(2) + (1-param(2))*data(i,3);
end

if param(1) < 0 || param(1) > 1
    fittedValue = 10^25;
elseif param(2) < 0 || param(2) > 1
    fittedValue = 10^25;
elseif strt < 0 || strt > 8
    fittedValue = 10^25;
else
    getFit = [sweepVec - data(:,1) resetVal];
    [fittedValue, predict] = modelFit(data, sweepVec);
end