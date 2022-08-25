%% fitting_fminsearch_optimalsimplemodel
% Simplest RL model independent from participant response

%% Function
function [estimates, exitflag, bic] = fitting_fminsearch_model_02(data, param)
global modUse

if strcmp(modUse, 'posneg')
    model = @(param) mod02_Coarse_Granularity_posneg(data, param);
else
    model = @(param) mod02_Coarse_Granularity(data, param);
end
options = optimset('Display', 'final', 'MaxIter', 10000000);
[estimates, fval, exitflag] = fminsearch(model, param, options);

bic = calcBIC(length(data), length(param), fval);
