% Plots selected participants' responses as well as the optimal models
close all;
load('Data\experiments\ExperimentTwo.mat')
parLen = length(dataSort.delBothSortBoth);
checkOrder = zeros(60,4,parLen);

%% Get a separate profile
[dB, dP] = deal(cell(parLen,1));

for iPar = 1:parLen
    dBoth = dataSort.delBothSortBoth{1,iPar};
    dProf = dataSort.delBothSortProf{1,iPar};
    
    dB{iPar,1} = dBoth(dBoth(:,4) == 1,:);
    dP{iPar,1} = dProf(dProf(:,4) == 1,:);
end

global startVal ansOpt modOpt getFit%modUse % Set this as global so that all other functions can use it
for iR = 1:2
    param       = [0.5 0.5 4.5];
    paramSimple = [0.5 4.5];

    plot_sub    = 0; % Create a subplot to put Model Comparison (BIC) and PXP in together
    numModels   = 5;
    
    startVal   = 0; % Used as a fixed value. If none set input as free parameter
    modOpt     = ''; % Check if you want to run optimal model instead of regular
    if iR == 1
        modOpt = 'optimal';
    end
    ansOpt     = 1:8;

    % If startVal is set that should be used instead of a fitted parameter
    if startVal ~= 0
        param(3)       = [];
        paramSimple(2) = [];
    end

    saveFit = cell(numPar,numModels);
    pEst      = struct(repmat(struct('model', {cell(1,numPar)}),numModels,1));
    bicMatrix = zeros(numPar, numModels);
    load('C:\Users\frolichs\Documents\Koen\Projects\PerLe\PerLe_Publish\Data\experiments\ExperimentTwo.mat', 'sweepR')

    for iPar = 1:numPar
        % All regular models use both sorts and both deletes
        % The sweep models use profile sort and both deletes
        data = dB{iPar};
        dataMean = data;
        dataMean(:,3) = data(:,6);

        dataSweep = dP{iPar};
        dataSweepMean = dataSweep;
        dataSweepMean(:,3) = dataSweepMean(:,6);

        [pEst(1).model{iPar}, ~, bicMatrix(iPar,1)] = fitting_fminsearch_model_01(dataMean, paramSimple);
        saveFit{iPar,1} = getFit;
        [pEst(2).model{iPar}, ~, bicMatrix(iPar,2)] = fitting_fminsearch_model_02(data, paramSimple);
        saveFit{iPar,2} = getFit;
        [pEst(3).model{iPar}, ~, bicMatrix(iPar,3)] = fitting_fminsearch_model_03(dataMean, param);
        saveFit{iPar,3} = getFit;
        [pEst(4).model{iPar}, ~, bicMatrix(iPar,4)] = fitting_fminsearch_model_04(dataSweep, paramSimple, sweepR);
        saveFit{iPar,4} = getFit;
        [pEst(5).model{iPar}, ~, bicMatrix(iPar,5)] = fitting_fminsearch_model_05(dataSweepMean, param, sweepR);
        saveFit{iPar,5} = getFit;
    end

    bicMin = zeros(41,5);
    for iC = 1:41
        [~,idx] = min(bicMatrix(iC,:));
        bicMin(iC,idx) = 1;
    end

    if iR == 1
        optimFit = saveFit;
        optimMin = bicMin;
    end
end

%%
fh = figure;
fh.Position = [30 350 1350 580];

gdFit = 6;
bdFit = 8;

cPall = [53 101 161; 230 91 153; 255 166 0]./255;
outCol = [0.4660 0.6740 0.1880];
optCol = [.5 .5 .5];
colIdx = [1 2 2 3 3];

idx = 1:3:15;

subplot(2,3,1)
plot(dB{gdFit,1}(:,1),'Color',optCol,'linewidth',2); hold on
plot(dB{gdFit,1}(:,2),'Color',outCol,'linewidth',2);
p = patch([0 30 30 0],[2 2 8.5 8.5],'k');
p.FaceAlpha = .05; p.EdgeAlpha = 0;
ylim([2,8.5]); title('')
xticks([0 15 30 45 60]); yticks(8); xticklabels({'0','Agreeable','30','Conscientious','60'})
ylabel('Answers')
title({'Profile Self-Ratings &','Participant Answers'})
text(-18, 6, {'Participant w.','best fitting','strategy'},'FontSize',12,'FontWeight','bold','HorizontalAlignment','center')
l = legend({'Profile Answers','Participant Answers'});
l.Position = [.172839508534,.472342975318,.117037034674,.062931032838];
text(-1,9,'\fontsize{22}a')

% Plot prof + best model (good fit)
subplot(2,3,2)
numBPM = find(optimMin(gdFit,:));
plot(dB{gdFit,1}(:,1),'Color',optCol,'linewidth',2); hold on
optFit = dB{gdFit,1}(:,1) + optimFit{gdFit,numBPM}(:,1);
optFit(optFit > 8) = 8;
plot(optFit, 'Color', cPall(colIdx(numBPM),:),'linewidth',2,'linestyle','--')

p = patch([0 30 30 0],[2 2 8.5 8.5],'k');
p.FaceAlpha = .05; p.EdgeAlpha = 0;
ylim([2,8.5])
xticks([0 15 30 45 60]); yticks(8); xticklabels({'0','Agreeable','30','Conscientious','60'})
ylabel('Answers')
title({'Profile Self-Ratings &','Best Performing Model'})
leg = legend({'Profile Answers','Model 5 [Fine G. & Pop. RP]'});
leg.Position = [.462469138186,.472342975318,.117037034674,.062931032838];
text(-1,9,'\fontsize{22}b')

% Plot Prof + part ans
subplot(2,3,3)
plot(dB{gdFit,1}(:,2),'Color',outCol,'linewidth',2); hold on
% Participant Answers
numFit = find(bicMin(gdFit,:));
parFit = dB{gdFit,1}(:,2) + saveFit{gdFit,numFit}(:,1);
parFit(parFit > 8) = 8;
plot(parFit, 'Color', cPall(colIdx(numFit),:),'linewidth',2)
p = patch([0 30 30 0],[2 2 8.5 8.5],'k');
p.FaceAlpha = .05; p.EdgeAlpha = 0;
ylim([2,8.5])
xticks([0 15 30 45 60]); yticks(8); xticklabels({'0','Agreeable','30','Conscientious','60'})
ylabel('Answers')
title({'Participant Answers &','Fitted Model'})
text(-1,9,'\fontsize{22}c')

% Bad fitting participant
subplot(2,3,4)
plot(dB{bdFit,1}(:,1),'Color',optCol,'linewidth',2); hold on
plot(dB{bdFit,1}(:,2),'Color',outCol,'linewidth',2);
p = patch([0 30 30 0],[2 2 8.5 8.5],'k');
p.FaceAlpha = .05; p.EdgeAlpha = 0;
ylim([2,8.5]); title('')
xticks([0 15 30 45 60]); yticks(8); xticklabels({'0','Agreeable','30','Conscientious','60'})
ylabel('Answers')
% title({'Profile Self-Ratings &','Participant Answers'})
text(-18, 6, {'Participant w.','ill fitting','strategy'},'FontSize',12,'FontWeight','bold','HorizontalAlignment','center')
l = legend({'Profile Answers','Participant Answers'});
l.Position = [.172839508534,.472342975318,.117037034674,.062931032838];
text(-1,9,'\fontsize{22}d')

% Plot prof + best model (good fit)
subplot(2,3,5)
numBPM = find(optimMin(bdFit,:));
plot(dB{bdFit,1}(:,1),'Color',optCol,'linewidth',2); hold on
optFit = dB{bdFit,1}(:,1) + optimFit{bdFit,numBPM}(:,1);
optFit(optFit > 8) = 8;
plot(optFit, 'Color', cPall(colIdx(numBPM),:),'linewidth',2,'linestyle','--')

p = patch([0 30 30 0],[2 2 8.5 8.5],'k');
p.FaceAlpha = .05; p.EdgeAlpha = 0;
ylim([2,8.5])
xticks([0 15 30 45 60]); yticks(8); xticklabels({'0','Agreeable','30','Conscientious','60'})
ylabel('Answers')
text(-1,9,'\fontsize{22}e')

% Plot Prof + part ans
subplot(2,3,6)
plot(dB{bdFit,1}(:,2),'Color',outCol,'linewidth',2); hold on
% Participant Answers
numFit = find(bicMin(bdFit,:));
parFit = dB{bdFit,1}(:,2) + saveFit{bdFit,numFit}(:,1);
parFit(parFit > 8) = 8;
plot(parFit, 'Color', cPall(colIdx(numFit),:),'linewidth',2)
plot(1,nan,'Color', cPall(colIdx(numBPM),:),'linewidth',2)
p = patch([0 30 30 0],[2 2 8.5 8.5],'k');
p.FaceAlpha = .05; p.EdgeAlpha = 0;
ylim([2,8.5])
xticks([0 15 30 45 60]); yticks(8); xticklabels({'0','Agreeable','30','Conscientious','60'})
ylabel('Answers')
numBPM = find(optimMin(gdFit,:));
text(-1,9,'\fontsize{22}f')

leg = legend({'Participant Answers','Model 1 [No Learning]','Model 5 [Fine G. & Pop. RP]'});
leg.Position = [.741728397578,.452515389933,.122222219705,.091379307878];
