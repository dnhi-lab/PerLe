%% rlselfmodel
% combination of RL & self-rating according to formula by Y. Niv: 
% rating = a*Vt + (1-a)own

%% Function
function sumSquareError = rlselfmodel_posneg(data, p)
learnVec        = zeros(length(data),1);
learnAndSelfVec = zeros(length(data),1);
global startVal

pos = p(1);
if length(p) == 3
    strt = startVal;
    neg  = p(3);
else
    strt = p(3);
    neg  = p(4);
end

for i = 1:length(data)
     % This is the reset for a new profile, resets are column 5    
    if(data(i,5) == 1)
         learnVec(i) = strt;
    end
     
    delta = data(i,2) - learnVec(i);
    if delta < 0
        learnVec(i+1) = learnVec(i) + pos * delta;
    else
        learnVec(i+1) = learnVec(i) + neg * delta;
    end
    learnAndSelfVec(i) = p(2) * learnVec(i) + (1 - p(2)) * data(i,3);
end

% Since we use fminsearch (No bound)
if pos < 0 || pos > 1
    sumSquareError = 10^25;
elseif p(2) < 0 || p(2) > 1
    sumSquareError = 10^25;
elseif strt < 0 || strt > 8
    sumSquareError = 10^25;
elseif neg < 0 || neg > 1
    sumSquareError = 10^25;
else
    sumSquareError = sum( ( data(:,1) - learnAndSelfVec ).^2 );
end