% Recursive function that finds the factors of a number.
% If the number is a prime it will add 1 and check again.
function fac = getFactor(numPlots)
if length(factor(numPlots)) == 1
    fac = getFactor(numPlots+1);
else
    fac = factor(numPlots);
end