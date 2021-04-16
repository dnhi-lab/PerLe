% Input: How many subplots you need
% Returns: A somewhat ideal number of plots for the x and y-axis
%
% subNum = getSubNum(4)
% subNum:  2    2
function subNum = getSubNum(numPlots)

% Other helper function
subNum = getFactor(numPlots);

% Need to multiply
while length(subNum) > 2
    subNum = [subNum(1)*subNum(2) subNum(3:end)];
end 