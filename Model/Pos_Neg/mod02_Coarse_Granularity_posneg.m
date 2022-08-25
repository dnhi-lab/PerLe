%% fitting_fminsearch_optimalsimplemodel
% Simplest RL model independent from participant response

%% Function
function sumSquareError = mod02_Coarse_Granularity_posneg(data, p)
resultVec = zeros(length(data), 1);
global startVal

pos = p(1);
if length(p) == 2
    strt = startVal;
    neg = p(2);
else
    strt = p(2);
    neg = p(3);
end

 % Actual model
 for iModel = 1:length(data)

     % This is the reset for a new profile, resets are column 21
%      if(data(iModel,5) == 1)
%          resultVec(iModel) = startVal;
%          if(length(p) == 3); resultVec(iModel) = p(2); end
%      end

    if(data(iModel,5) == 1)
         resultVec(iModel) = strt;
     end

     % Calculation of Prediction Error.
     delta = data(iModel,2) - resultVec(iModel);
     if delta < 0
         resultVec(iModel + 1) = resultVec(iModel) + pos * delta;
     else
         resultVec(iModel + 1) = resultVec(iModel) + neg * delta;
     end
 end
 resultVec(end) = [];

 if pos < 0 || pos > 1
     sumSquareError = 10^25;
 elseif strt < 0 || strt > 8
     sumSquareError = 10^25;
 elseif neg < 0 || neg > 1
     sumSquareError = 10^25;
 else
     sumSquareError = sum( ( data(:,1) - resultVec ).^2 );
 end