%% fitting_fminsearch_sweepmodel
% Sweep model based on the idea that traits that are similar should be updated
% as well (depending on how similar, ie. correlation).

%% Function
function [estimates, exitflag, bic] = fitting_fminsearch_sweepmodel(data, param, sweepCorr)
global modUse

if strcmp(modUse, 'posneg')
    model = @(param) sweepmodel_posneg(data, param, sweepCorr);
else
    model = @(param) sweepmodel(data, param, sweepCorr);
end

options = optimset('Display', 'final', 'MaxIter', 10000000);
[estimates, fval, exitflag] = fminsearch(model, param, options);

bic = calcBIC(length(data), length(param), fval);