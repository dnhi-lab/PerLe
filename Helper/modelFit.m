function [fitval, predict] = modelFit(data, estimate)
global modOpt

if strcmp(modOpt, 'optimal')
    fitval = sum( (data(:,2) - estimate).^2);
    predict = [];
else
% This is just for the regular models (how well it explains the data)
    fitval = sum( (data(:,1) - estimate).^2);
    predict = [data(:,1) estimate];
end