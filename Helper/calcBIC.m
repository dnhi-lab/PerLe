%% BIC function
function bayesianValue = calcBIC(numTrials, numParam, fval)
bayesianValue = ( numTrials * log(fval/numTrials) ) + ( numParam * log(numTrials) );