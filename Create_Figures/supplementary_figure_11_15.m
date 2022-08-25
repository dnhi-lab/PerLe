%% For mapping out the parameter space of a certain model
% Uses a grid-search over the whole parameter space of an optimal model and saves the fit
% Also puts in participants fit parameters (white asterix is fit, black dot is
% fit for winning model).

% You need to run main_analysis first for each experiment you want to
% visualize. 
% dataSet is the number of the experiment, bicMatrix and pEst can be
% directly taken from the variables of the same name produced in
% main_analysis

% That is, after running main_analysis you can run the function like this:
% modelFits = supplementary_figure_11_15(expInp, bicMatrix, pEst)

function modelFits = supplementary_figure_11_15(dataSet, bicMatrix, pEst)
close all
%% Create the parameter options
fPBounds = [0 1];
svBounds = [0 8];
fPSteps  = 100;

a      = linspace(fPBounds(1),fPBounds(2),fPSteps+2)';
sv     = linspace(svBounds(1), svBounds(2), fPSteps+2)';
a(1)   = []; a(end) = []; % Don't want exactly zero or one (out of bounds)
sv(1)  = []; sv(end) = []; %#ok<NASGU>

%% Run the fitting procedure using all parameter options
global startVal ansOpt modOpt
startVal = 0;
modOpt   = 'optimal'; % Check if you want to run optimal model instead of regular

ansOpt   = 1:8;
if dataSet == 5; ansOpt = 1:5; end

% disp(['Running data set number: ', num2str(dataSet)])
switch dataSet
    case 1
        load('C:\Users\frolichs\Documents\Koen\Projects\PerLe\misc_code\modelFits\modelFits_ML_Data.mat','modelFits')
    case 2
        load('C:\Users\frolichs\Documents\Koen\Projects\PerLe\misc_code\modelFits\modelFits_ML_Data_Clu.mat','modelFits')
    case 3
        load('C:\Users\frolichs\Documents\Koen\Projects\PerLe\misc_code\modelFits\modelFits_ML_Data_Cre.mat','modelFits')
    case 4
        load('C:\Users\frolichs\Documents\Koen\Projects\PerLe\misc_code\modelFits\modelFits_ML_Data_Fash.mat','modelFits')
    case 5
        load('C:\Users\frolichs\Documents\Koen\Projects\PerLe\misc_code\modelFits\modelFits_ML_Data_IPIP.mat','modelFits')
    otherwise
        error('Wrong input! Should be a number from 1-5')
end

if dataSet == 4 % Add the three stereotypye models
    pEstTemp = [pEst(1),pEst(3),pEst(4),pEst(6),pEst(7),pEst(2),pEst(5),pEst(8)];
    pEst = pEstTemp;
    pEstSte  = [pEstTemp(6),pEst(1),pEst(7),pEst(1),pEst(8)];
end

%% Plotting
% Parameter Estimates should be changed for experiment 4
% For dataset 4 I want to make 2 separate plots
modName = {'No Learning', 'Coarse Granularity', 'Coarse G. & Pop. RP', 'Fine Granularity', 'Fine G. & Pop. RP'};
modNameSTE = {'No Learning STE', '', 'CG & STE RP', '', 'FG & STE RP'};
fitMinMax = [min(modelFits,[],'all'), mean(modelFits,'all')*.75];
fh = figure;

xPos = -15;
yPos = -10;
if dataSet ~= 4
    subplot(2,3,1)
    plotParamSpace_gamma(modelFits(:,:,:,1),2,1,a, bicMatrix, pEst, modName{1},fitMinMax)
    text(xPos,yPos,'a','FontSize',25,'FontWeight','Bold')

    subplot(2,3,2)
    plotParamSpace_gamma(modelFits(:,:,:,2),2,2,a, bicMatrix, pEst, modName{2},fitMinMax)
    text(xPos,yPos,'b','FontSize',25,'FontWeight','Bold')

    subplot(2,3,3)
    plotParamSpace_gamma(modelFits(:,:,:,3),3,3,a, bicMatrix, pEst, modName{3},fitMinMax)
    text(xPos,yPos,'c','FontSize',25,'FontWeight','Bold')

    subplot(2,3,4)
    plotParamSpace_gamma(modelFits(:,:,:,4),2,4,a, bicMatrix, pEst, modName{4},fitMinMax)
    text(xPos,yPos,'d','FontSize',25,'FontWeight','Bold')

    subplot(2,3,5)
    plotParamSpace_gamma(modelFits(:,:,:,5),3,5,a, bicMatrix, pEst, modName{5},fitMinMax)
    text(xPos,yPos,'e','FontSize',25,'FontWeight','Bold')

    % sgtitle(['Parameter Space per model for data set: ', datName{dataSet}])
    sgtitle(['Experiment ', num2str(dataSet)])
    % fh.WindowState = 'maximized';
    fh.Position = [259,317,904,662];
    
else
    subplot(3,3,1)
    plotParamSpace_gamma(modelFits(:,:,:,1),2,1,a, bicMatrix, pEst, modName{1},fitMinMax)
    text(xPos,yPos,'a','FontSize',25,'FontWeight','Bold')

    subplot(3,3,2)
    plotParamSpace_gamma(modelFits(:,:,:,2),2,2,a, bicMatrix, pEst, modName{2},fitMinMax)
    text(xPos,yPos,'b','FontSize',25,'FontWeight','Bold')

    subplot(3,3,3)
    plotParamSpace_gamma(modelFits(:,:,:,3),3,3,a, bicMatrix, pEst, modName{3},fitMinMax)
    text(xPos,yPos,'c','FontSize',25,'FontWeight','Bold')

    subplot(3,3,4)
    plotParamSpace_gamma(modelFits(:,:,:,4),2,4,a, bicMatrix, pEst, modName{4},fitMinMax)
    text(xPos,yPos,'d','FontSize',25,'FontWeight','Bold')

    subplot(3,3,5)
    plotParamSpace_gamma(modelFits(:,:,:,5),3,5,a, bicMatrix, pEst, modName{5},fitMinMax)
    text(xPos,yPos,'e','FontSize',25,'FontWeight','Bold')
    cb = colorbar;
    cb.Label.String = 'SSE';
    cb.FontSize = 14;
    cb.Position = [.651236787425246,.39186295503212,.014879649890591,.19271948608137];
    
    subplot(3,3,7)
    plotParamSpace_gamma(modelFits(:,:,:,6),2,1,a, bicMatrix, pEstSte, modNameSTE{1},fitMinMax)
    text(xPos,yPos,'f','FontSize',25,'FontWeight','Bold')

    subplot(3,3,8)
    plotParamSpace_gamma(modelFits(:,:,:,7),3,3,a, bicMatrix, pEstSte, modNameSTE{3},fitMinMax)
    text(xPos,yPos,'g','FontSize',25,'FontWeight','Bold')
    
    subplot(3,3,9)
    plotParamSpace_gamma(modelFits(:,:,:,8),3,5,a, bicMatrix, pEstSte, modNameSTE{5},fitMinMax)
    text(xPos,yPos,'h','FontSize',25,'FontWeight','Bold')
    
    fh.Position = [360,153,914,934];
end
sgtitle(['Experiment ', num2str(dataSet)])
colormap(flipud(viridis))
