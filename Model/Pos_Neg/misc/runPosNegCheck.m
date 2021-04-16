clear
global modUse
modUse = '';
analysisRealData
if inp == 4
    regBICmin = bicMin(3:end);
else
    regBICmin = bicMin(2:end);
end

modUse = 'posneg';
analysisRealData
if inp == 4
    pnBICmin = bicMin(3:end);
else
    pnBICmin = bicMin(2:end);
end

close all
BIC_fixed_plot_RegPosNeg(regBICmin, pnBICmin, figTitle, 1)
saveas(figure(1), [figTitle 'PNvsReg.png'])

% close all
% posneg_param_check
% saveas(figure(1), [figTitle 'paramCheck.png'])
% close all