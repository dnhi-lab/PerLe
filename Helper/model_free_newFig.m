expInp = iExp;
trialL  = 60;
profL   = 4;

% expInp = input('What experiment would you like to run [1-5]: ');
switch expInp
    case 1
        load('Data\experiments\ExperimentOne.mat')
    case 2
        load('Data\experiments\ExperimentTwo.mat')
    case 3
        load('Data\experiments\ExperimentThree.mat')
    case 4
        load('Data\experiments\ExperimentFour.mat')
    case 5
        load('Data\experiments\ExperimentFive.mat')
        trialL = 50;
        profL  = 5;
    otherwise
        error('Wrong input! Should be a number from 1-5')
end

%% Order based on profile
parLen = length(dataSort.delBothSortBoth);
savePE = zeros(trialL,profL*parLen);
parIdx = 0:profL:profL*parLen;

saveX  = nan(trialL,3,profL*parLen);
nFac   = 5;

parDat = zeros(trialL, profL);
parAVG = zeros(trialL,parLen);
for iP = 1:parLen
%         d = dataSort.delBothSortBoth{1,iP};
    d = dataSort.delBothSortProf{1,iP};

    aPE = abs(d(:,2) - d(:,1));
    for iProf = 1:profL
        profPE = aPE(d(:,4) == iProf);
        pL = length(profPE);

        % n Last trials
        saveX(1:pL,1,parIdx(iP)+iProf) = 1:pL;
        saveX(1,2:3,parIdx(iP)+iProf) = [0 0];
        cntFac = zeros(1,nFac);
        if pL < 60
            profPE(pL+1:trialL) = nan(1,trialL-pL);
        end
        savePE(:, parIdx(iP)+iProf) = profPE;
        parDat(:,iProf) = profPE;
    end
    parAVG(:,iP) = nanmean(parDat,2);
end

%% Calculating averages and SEM
PE_mean = nanmean(parAVG,2);
PE_SEM  = std(parAVG,[],2,'omitnan') ./ sqrt(parLen);
plotL   = size(PE_mean,1);

 %% Plotting the results
plotCol = [0 0 0];
plot(PE_mean, 'k','LineWidth',2, 'Color', plotCol);
patch([1:plotL fliplr(1:plotL)], [PE_mean-PE_SEM; flipud(PE_mean+PE_SEM)]',plotCol, 'FaceAlpha',.3, 'EdgeColor','none')

[rhoPar, pval] = corr(PE_mean, (1:plotL)');
if pval < 0.001
    pTextPar = 'p < 0.001';
else
    pTextPar = ['p = ' num2str(round(pval,3))];
end
hold on

% Create a new figure to get the least squares info so you can plot it
% and use it in the legend
fh2 = figure;
s = scatter((1:plotL)',PE_mean);
s.MarkerEdgeColor = 'none';
lCat = lsline;
lsX = lCat.XData;
lsY = lCat.YData;
close
figure(fh1.Number)
plot(lsX,lsY,'LineWidth',2, 'Color', [.8 .3 .3])

ylim([min(PE_mean-PE_SEM)*.9, max(PE_mean+PE_SEM)*1.1])
xlabel('Trials')
%     ylabel({'\bfParticipants', '\rmMean abs PE'})
ylabel('Mean abs PE')

l = legend({'abs PE','SEM','LSLine'},'Location','bestoutside');
title(l,'Participants')

if iExp == 5; xlim([0, 50]); end
a = gca();
text(a.XLim(2)*(2/3), a.YLim(2)*.9, ['\rho: ' num2str(round(rhoPar,3))])
