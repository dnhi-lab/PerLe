%% fitting_fminsearch_optimalsimplemodel
% Simplest RL model independent from participant response

%% Function
function [estimates, exitflag, bic] = fitting_fminsearch_optimalsimplemodel(data, param)
global modUse

if strcmp(modUse, 'posneg')
    model = @(param) optimalsimplemodel_posneg(data, param);
else
    model = @(param) optimalsimplemodel(data, param);
end
options = optimset('Display', 'final', 'MaxIter', 10000000);
[estimates, fval, exitflag] = fminsearch(model, param, options);

bic = calcBIC(length(data), length(param), fval);
