% fitting_fminsearch_pseudolinearregression
% Should work like a linear regression

function [fittedValue, resultVec] = pseudolinearregressionmodel(data, param)
global getFit startVal
if length(param) == 1
    strt = startVal;
else
    strt = param(2);
end
    
resultVec = param(1) * data(:,3) + strt;

getFit = [resultVec - data(:,1) data(:,5)];
fittedValue = modelFit(data, resultVec);