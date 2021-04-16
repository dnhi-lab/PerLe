%% Confusion Matrix

%% Generate random parameters
numParam = 200;
parameters = randi([20,80],numParam,2)/100;
%% Get the profiles (based on data set) and create the rest of the data
dataInp  = input(['Profiles from what dataset would you like to use? [1-5]' newline ': ']);
if dataInp < 1 || dataInp > 5; error('Cannot parse this input'); end
load(['Data\simulations\prof_' num2str(dataInp)])

%% Simulate data
[simData, data, numIt, sweepR] = sim_data(dataInp, profiles, numParam, parameters);

%% Recover the parameters
% recData = zeros(3, numIt, 5);
recFit = zeros(numIt, 5, 5);
param       = [0.5 0.5 4.5];
paramSimple = [0.5 4.5];

for iMod = 1:5
    for iParam = 1:numIt
        data(:,1) = simData(:,iParam,iMod);

        [~, ~, recFit(iParam,1,iMod)] = fitting_fminsearch_pseudolinearregression(data, paramSimple);

        [~, ~, recFit(iParam,2,iMod)] = fitting_fminsearch_optimalsimplemodel(data, paramSimple);

        [~, ~, recFit(iParam,3,iMod)] = fitting_fminsearch_rlselfmodel(data, param);

        [~, ~, recFit(iParam,4,iMod)] = fitting_fminsearch_sweepmodel(data, paramSimple, sweepR);        

        [~, ~, recFit(iParam,5,iMod)] = fitting_fminsearch_sweepmodelself(data, param, sweepR);
    end
end

%% Plot the results
dataName = {'Data: Original','Data: Constructed Profiles','Data: Two Factors','Data: Fashion','Data: IPIP'};

CM = squeeze(sum(min(recFit,[],2) == recFit));
plot_CM(CM','title',dataName{dataInp})
