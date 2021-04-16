%% For mapping out the parameter space of a certain model
% Uses a grid-search over the whole parameter space of an optimal model and saves the fit
% Also puts in participants fit parameters (white asterix is fit, black dot is
% fit for winning model).
function modelFits = map_param_space(dataSet, bicMatrix, pEst)
close all
%% Create the parameter options
fPBounds = [0 1];
svBounds = [0 8];
fPSteps  = 100;

a      = linspace(fPBounds(1),fPBounds(2),fPSteps+2)';
sv     = linspace(svBounds(1), svBounds(2), fPSteps+2)';
a(1)   = []; a(end) = []; % Don't want exactly zero or one (out of bounds)
sv(1)  = []; sv(end) = [];

paramOpt = [];
for iAdd = 1:fPSteps
    % 1. First Param, 2. Second Param, 3. First Param Position, 4. Second Param Position
    paramOpt = [paramOpt; [a, ones(fPSteps,1)*a(iAdd), (100:-1:1)', ones(fPSteps,1)*iAdd]]; %#ok<AGROW>
end
paramOpt = [paramOpt, repelem(linspace(1,8,fPSteps)',100,1)];

paramOptAll = repmat(paramOpt,100,1);
sv_rep = [repelem(sv,10000) repelem((1:100)',10000)];
paramOptAll = [paramOptAll sv_rep];

%% Run the fitting procedure using all parameter options
global startVal ansOpt modOpt
startVal = 0;
modOpt   = 'optimal'; % Check if you want to run optimal model instead of regular

% prm      = paramOptAll(:,[1:2, 6]);
% prmSmpl  = paramOptAll(:,[1,6]);


ansOpt   = 1:8;
if dataSet == 5; ansOpt = 1:5; end

% disp(['Running data set number: ', num2str(dataSet)])
switch dataSet
    case 1
        load('PerLe\Data\experiments\ExperimentOne.mat',   'dataSort', 'sweepR', 'inp')
    case 2
        load('PerLe\Data\experiments\ExperimentTwo.mat',   'dataSort', 'sweepR', 'inp')
    case 3
        load('PerLe\Data\experiments\ExperimentThree.mat', 'dataSort', 'sweepR', 'inp')
    case 4
        load('PerLe\Data\experiments\ExperimentFour.mat',  'dataSort', 'sweepR', 'inp')
    case 5
        load('PerLe\Data\experiments\ExperimentFive.mat',  'dataSort', 'sweepR', 'inp')
    otherwise
        error('Wrong input! Should be a number from 1-5')
end

numMod = 5;
if dataSet == 4; numMod = 8; end

modelFits = zeros(fPSteps,fPSteps,fPSteps,numMod);

% Get profile info (same for all participants)
data = dataSort.delBothSortBoth{1};
dataMean = data;
dataMean(:,3) = data(:,6);

dataSweep = dataSort.delBothSortProf{1};
dataSweepMean = dataSweep;
dataSweepMean(:,3) = dataSweepMean(:,6);

if dataSet == 4
    dataFashMean = data;
    dataFashMean(:,3) = dataFashMean(:,9);

    dataFashMeanSw = dataSweep;
    dataFashMeanSw(:,3) = dataFashMeanSw(:,9);
end

% Get the fits for every parameter setting
progBar(0,0,1) % initialize the progress bar
for iPrm = 1:fPSteps^3
    [modelFits(paramOptAll(iPrm,3),paramOptAll(iPrm,4), paramOptAll(iPrm,7), 1),~] = pseudolinearregressionmodel(dataMean, prmSmpl(iPrm,:));
    [modelFits(paramOptAll(iPrm,3),paramOptAll(iPrm,4), paramOptAll(iPrm,7), 2),~] = optimalsimplemodel(data, prmSmpl(iPrm,:));
    [modelFits(paramOptAll(iPrm,3),paramOptAll(iPrm,4), paramOptAll(iPrm,7), 3),~] = rlselfmodel(dataMean, prm(iPrm,:));
    [modelFits(paramOptAll(iPrm,3),paramOptAll(iPrm,4), paramOptAll(iPrm,7), 4),~] = sweepmodel(dataSweep, prmSmpl(iPrm,:), sweepR);
    [modelFits(paramOptAll(iPrm,3),paramOptAll(iPrm,4), paramOptAll(iPrm,7), 5),~] = sweepmodelself(dataSweepMean, prm(iPrm,:), sweepR);

    if dataSet == 4 % Add the three stereotypye models
        [modelFits(paramOptAll(iPrm,3),paramOptAll(iPrm,4), paramOptAll(iPrm,7), 6),~] = pseudolinearregressionmodel(dataFashMean, prmSmpl(iPrm,:));
        [modelFits(paramOptAll(iPrm,3),paramOptAll(iPrm,4), paramOptAll(iPrm,7), 7),~] = rlselfmodel(dataFashMean, prm(iPrm,:));
        [modelFits(paramOptAll(iPrm,3),paramOptAll(iPrm,4), paramOptAll(iPrm,7), 8),~] = sweepmodelself(dataFashMeanSw, prm(iPrm,:), sweepR);
        pEstTemp = [pEst(1),pEst(3),pEst(4),pEst(6),pEst(7),pEst(2),pEst(5),pEst(8)];
        pEst = pEstTemp;
        pEstSte  = [pEstTemp(6),pEst(1),pEst(7),pEst(1),pEst(8)];
    end
    
    if mod(iPrm, 1000) == 0
        progBar(iPrm,fPSteps^3,0)
    end
end

%% Plotting
% Parameter Estimates should be changed for experiment 4
% For dataset 4 I want to make 2 separate plots
modName = {'No Learning', 'Coarse Granularity', 'CG & Pop. RP', 'Fine Granularity', 'FG & Pop. RP'};
modNameSTE = {'No Learning STE', '', 'CG & STE RP', '', 'FG & STE RP'};
datName = {'ML data', 'ML data clu', 'ML data cre', 'ML data fas', 'ML data ipip'};
% fitMinMax = [min(modelFits,[],'all'), max(modelFits,[],'all')];
fitMinMax = [min(modelFits,[],'all'), mean(modelFits,'all')*.75];
fh = figure;

% Actual plotting
% subplot(2,3,1)
% plotParamSpace(modelFits(:,:,:,1),2,1,sv, bicMatrix, pEst, modName{1},fitMinMax)
% subplot(2,3,2)
% plotParamSpace(modelFits(:,:,:,2),2,2,sv, bicMatrix, pEst, modName{2},fitMinMax)
% subplot(2,3,3)
% plotParamSpace(modelFits(:,:,:,3),3,3,sv, bicMatrix, pEst, modName{3},fitMinMax)
% subplot(2,3,4)
% plotParamSpace(modelFits(:,:,:,4),2,4,sv, bicMatrix, pEst, modName{4},fitMinMax)
% subplot(2,3,5)
% plotParamSpace(modelFits(:,:,:,5),3,5,sv, bicMatrix, pEst, modName{5},fitMinMax)

subplot(2,3,1)
plotParamSpace_gamma(modelFits(:,:,:,1),2,1,a, bicMatrix, pEst, modName{1},fitMinMax)
subplot(2,3,2)
plotParamSpace_gamma(modelFits(:,:,:,2),2,2,a, bicMatrix, pEst, modName{2},fitMinMax)
subplot(2,3,3)
plotParamSpace_gamma(modelFits(:,:,:,3),3,3,a, bicMatrix, pEst, modName{3},fitMinMax)
subplot(2,3,4)
plotParamSpace_gamma(modelFits(:,:,:,4),2,4,a, bicMatrix, pEst, modName{4},fitMinMax)
subplot(2,3,5)
plotParamSpace_gamma(modelFits(:,:,:,5),3,5,a, bicMatrix, pEst, modName{5},fitMinMax)


sgtitle(['Parameter Space per model for data set: ', datName{dataSet}])
fh.WindowState = 'maximized';


if dataSet == 4
    fh2 = figure;
%     subplot(2,3,1)
%     plotParamSpace(modelFits(:,:,:,6),2,1,sv, bicMatrix, pEstSte, modNameSTE{1},fitMinMax)
%     subplot(2,3,3)
%     plotParamSpace(modelFits(:,:,:,7),3,3,sv, bicMatrix, pEstSte, modNameSTE{3},fitMinMax)
%     subplot(2,3,5)
%     plotParamSpace(modelFits(:,:,:,8),3,5,sv, bicMatrix, pEstSte, modNameSTE{5},fitMinMax)
    
    subplot(2,3,1)
    plotParamSpace_gamma(modelFits(:,:,:,6),2,1,a, bicMatrix, pEstSte, modNameSTE{1},fitMinMax)
    subplot(2,3,3)
    plotParamSpace_gamma(modelFits(:,:,:,7),3,3,a, bicMatrix, pEstSte, modNameSTE{3},fitMinMax)
    subplot(2,3,5)
    plotParamSpace_gamma(modelFits(:,:,:,8),3,5,a, bicMatrix, pEstSte, modNameSTE{5},fitMinMax)

    sgtitle(['Parameter Space per Stereotype model for data set: ', datName{dataSet}])
    fh2.WindowState = 'maximized';
end
