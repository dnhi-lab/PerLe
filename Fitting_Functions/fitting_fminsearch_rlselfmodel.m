%% fitting_fminsearch_rlselfmodel
% combination of RL & self-rating according to formula by Y. Niv: 
% rating = a*Vt + (1-a)own

%% Function
function [estimates, exitflag, bic] = fitting_fminsearch_rlselfmodel(data, param)
global modUse

if strcmp(modUse, 'posneg')
    model = @(param) rlselfmodel_posneg(data, param);
else
    model = @(param) rlselfmodel(data, param);
end

options = optimset('Display', 'final', 'MaxIter', 10000000);
[estimates, fval, exitflag] = fminsearch(model, param, options);

bic = calcBIC(length(data), length(param), fval);