%% fitting_fminsearch_pseudolinearregression
% Should work like a linear regression

%% Function
function [estimates, exitflag, bic] = fitting_fminsearch_pseudolinearregression(data, param)
model = @(param) pseudolinearregressionmodel(data,param);

options = optimset('Display', 'final', 'MaxIter', 10000000);
[estimates, fval, exitflag] = fminsearch(model, param, options);

bic = calcBIC(length(data), length(param), fval);