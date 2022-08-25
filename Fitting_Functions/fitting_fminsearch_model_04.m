%% fitting_fminsearch_sweepmodel
% Sweep model based on the idea that traits that are similar should be updated
% as well (depending on how similar, ie. correlation).

%% Function
function [estimates, exitflag, bic] = fitting_fminsearch_model_04(data, param, sweepCorr)
global modUse

if strcmp(modUse, 'posneg')
    model = @(param) mod04_Fine_Granularity_posneg(data, param, sweepCorr);
else
    model = @(param) mod04_Fine_Granularity(data, param, sweepCorr);
end

options = optimset('Display', 'final', 'MaxIter', 10000000);
[estimates, fval, exitflag] = fminsearch(model, param, options);

bic = calcBIC(length(data), length(param), fval);