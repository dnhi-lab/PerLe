%% fitting_fminsearch_rlselfmodel
% combination of RL & self-rating according to formula by Y. Niv: 
% rating = a*Vt + (1-a)own

%% Function
function [estimates, exitflag, bic] = fitting_fminsearch_model_03(data, param)
global modUse

if strcmp(modUse, 'posneg')
    model = @(param) mod03_CG_Pop_RP_posneg(data, param);
else
    model = @(param) mod03_CG_Pop_RP(data, param);
end

options = optimset('Display', 'final', 'MaxIter', 10000000);
[estimates, fval, exitflag] = fminsearch(model, param, options);

bic = calcBIC(length(data), length(param), fval);