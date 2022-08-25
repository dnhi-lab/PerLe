%% Analysis for Real Data sets
% Data is already pre-sorted etc.
% Columns: answerOther:  1, outcomeOther: 2, Answer Self:  3,
%          profile:      4, resets:       5, meanValues:   6,
%          itemNumber80: 7, medianValues: 8, stereoVal:    9.
% expInp = input('What experiment would you like to run [1-5]: ');
numModels = 5;
switch expInp
    case 1
        load('PerLe_Publish\Data\experiments\ExperimentOne.mat')
    case 2
        load('PerLe_Publish\Data\experiments\ExperimentTwo.mat')
    case 3
        load('PerLe_Publish\Data\experiments\ExperimentThree.mat')
    case 4
        load('PerLe_Publish\Data\experiments\ExperimentFour.mat')
        numModels = 8;
    case 5
        load('PerLe_Publish\Data\experiments\ExperimentFive.mat')
    otherwise
        error('Wrong input! Should be a number from 1-5')
end

%% Settings
plot_sub    = 0; % Create a subplot to put Model Comparison (BIC) and PXP in together

global startVal ansOpt modOpt modUse % Set this as global so that all other functions can use it
modUse     = ''; % Use of the 'posneg' models or the regular (any other option)
startVal   = 0;  % Used as a fixed value. If none set input as free parameter
modOpt     = ''; % Check if you want to run optimal model instead of regular
ansOpt     = 1:8;
if inp == 5; ansOpt = 1:5; end

%% Actual fitting
[pEst, bicMatrix, saveFit, getOptPE] = fitAll(dataSort, numPar, numModels, inp, sweepR);

%% Plotting Intermediary Results
% bicMin = sum(bicMatrix);
% if inp == 1
%     figTitle = 'ML data';
% elseif inp == 2
%     figTitle = 'ML data clu';
% elseif inp == 3
%     figTitle = 'ML data cre';
% elseif inp == 4
%     figTitle = 'ML data fash';
% elseif inp == 5
%     figTitle = 'ML data ipip';
% end
% 
% BICtitle = ['BIC scores: ',figTitle];
% if strcmp(modOpt, 'optimal'); disp('Optimal models used'); BICtitle = ['Optimal Models ' figTitle]; plot_sub = 0; end
% 
% Yticklab = BIC_fixed_plot_v2(bicMin, BICtitle, plot_sub,numModels);
% set(gca,'YtickLabel',Yticklab);
% xlabel('BIC score')
% 
% if ~strcmp(modOpt, 'optimal')
%     [BMS] = PXP_random_plot_v1(-bicMatrix, ['PXP random plot: ' figTitle], plot_sub,numModels);
% end
