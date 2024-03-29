%% fitting_fminsearch_optimalsimplemodel
% Simplest RL model independent from participant response

%% Function
function [fittedValue, resultVec] = mod02_Coarse_Granularity(data, parameters)
resultVec = zeros(length(data), 1);
global startVal getFit %getOpt

if length(parameters) == 1
    strt = startVal;
else
    strt = parameters(2);
end

% Actual model
for iModel = 1:length(data)

    if(data(iModel,5) == 1)
        resultVec(iModel) = strt;
    end
    % Calculation of Prediction Error.
    delta = data(iModel,2) - resultVec(iModel);
    resultVec(iModel + 1) = resultVec(iModel) + parameters(1) * delta;

end
resultVec(end) = [];
    
if parameters(1) < 0 || parameters(1) > 1
    fittedValue  = 10^25;
elseif strt < 0 || strt > 8
    fittedValue  = 10^25;
else
    getFit = [resultVec - data(:,1) data(:,5)];
    fittedValue = modelFit(data, resultVec);
end
