% Parameter Recovery

%% Get the profiles (based on data set) and create the rest of the data
dataInp  = input(['Profiles from what dataset would you like to use? [1-5]' newline ': ']);
if dataInp < 1 || dataInp > 5; error('Cannot parse this input'); end
load(['Data\simulations\prof_' num2str(dataInp)])

%% Create the parameters
numParam = 200;
parameters = randi([1,99],numParam,2)/100;

scale = 8;
if dataInp == 5; scale = 5; end
    
strt = randi([10,scale*100], numParam, 1)/100;
parameters = [parameters, strt];
%% Simulate data
[simData, data, numIt, sweepR] = sim_data(dataInp, profiles, numParam, parameters);

%% Recover the parameters
% recData = zeros(3, numIt, 5);
recData = zeros(numIt, 3, 5);
param       = [0.5 0.5 4.5];
paramSimple = [0.5 4.5];

for iRec = 1:numIt
    data(:,1) = simData(:,iRec,1);
    [recData(iRec,1:2,1), ~, ~] = fitting_fminsearch_pseudolinearregression(data, paramSimple);

    data(:,1) = simData(:,iRec,2);
    [recData(iRec,1:2,2), ~, ~] = fitting_fminsearch_optimalsimplemodel(data, paramSimple);

    data(:,1) = simData(:,iRec,3);
    [recData(iRec,:,3), ~, ~] = fitting_fminsearch_rlselfmodel(data, param);

    data(:,1) = simData(:,iRec,4);
    [recData(iRec,1:2,4), ~, ~] = fitting_fminsearch_sweepmodel(data, paramSimple, sweepR);        

    data(:,1) = simData(:,iRec,5);
    [recData(iRec,:,5), ~, ~] = fitting_fminsearch_sweepmodelself(data, param, sweepR);
end

%% Plot the results
dataName = {'Data: Original','Data: Constructed Profiles','Data: Two Factors','Data: Fashion','Data: IPIP'};
%  Alpha
figure
for iMod = 1:5
    subplot(2,3,iMod)
    scatter(parameters(:,1), recData(:,1,iMod))
    title(['Model: ' num2str(iMod) ' || r: ' num2str(corr(parameters(:,1), recData(:,1,iMod)))])
    xlabel('Simulated \alpha')
    ylabel('Fit \alpha')
    xlim([0 1]); ylim([0 1])
end
suptitle(dataName{dataInp})

% Start Value
figure
for iMod = 1:5
    subplot(2,3,iMod)
    if sum(iMod == [1 2 4])
        scatter(parameters(:,3), recData(:,2,iMod))
        r = corr(parameters(:,3), recData(:,2,iMod));
    else
        scatter(parameters(:,3), recData(:,3,iMod))
        r = corr(parameters(:,3), recData(:,3,iMod));
    end
    title(['Model: ' num2str(iMod) ' || r: ' num2str(r)])
    xlabel('Simulated Starting Value')
    ylabel('Fit Starting Value')
    xlim([0 scale]); ylim([0 scale])
end
suptitle(dataName{dataInp})

% Gamma
figure
cnt = 1;
for iModComp = [3,5]
    subplot(1,2, cnt)
    scatter(parameters(:,2), recData(:,2,iModComp))
    title(['Model: ' num2str(iModComp) ' || r: ' num2str(corr(parameters(:,2), recData(:,2,iModComp)))])
    xlabel('Simulated \gamma')
    ylabel('Fit \gamma')
    cnt = cnt + 1;
    xlim([0 1]); ylim([0 1])
end
suptitle(dataName{dataInp})

%% Plot only model 5
figure
subplot(1,2,1)
scatter(parameters(:,1), recData(:,1,iMod))
title(['r: ' num2str(corr(parameters(:,1), recData(:,1,5)))])
xlabel('Simulated \alpha')
ylabel('Fit \alpha')

subplot(1,2,2)
scatter(parameters(:,2), recData(:,2,5))
title(['r: ' num2str(corr(parameters(:,2), recData(:,2,5)))])
xlabel('Simulated \gamma')
ylabel('Fit \gamma')
suptitle('Best Fitting model Parameter Recovery')