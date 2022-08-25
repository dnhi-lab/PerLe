%% sweepmodel
% Complex model, one free parameter. Taken from Rosenblau et al., 2018
% ER = y * (ER + a*PE) + (1-y) * OP

%% Function
function [fittedValue, predict, sweepVec] = mod04_Fine_Granularity(data, param, sweepCorr)
learnVec = zeros(length(data),1);
sweepVec = zeros(length(data),1);
resetVal = [1; diff(data(:,4))];
global startVal getFit % getOpt

if length(param) == 1
    strt = startVal;
else
    strt = param(2);
end

for i = 1:length(data)
    if(resetVal(i) == 1)
        spaceVec = zeros( length(sweepCorr), 1) +  strt;
    end

    learnVec(i) = spaceVec(data(i,7));           
    delta = data(i,2) - learnVec(i);

    spaceVec = spaceVec + param(1) * delta * sweepCorr(:, data(i,7));

    sweepVec(i) = learnVec(i);
end

% Add bounding that is lacking in fminsearch
if param(1) < 0 || param(1) > 1
    fittedValue = 10^25;
% % elseif strt < 0 || strt > 8
% %     fittedValue = 10^25;
else
    getFit = [sweepVec - data(:,1) resetVal];
    [fittedValue, predict] = modelFit(data, sweepVec);
end