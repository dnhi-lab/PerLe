%% Check the absolute PEs over time from the winning model on all participants
close all

%% Settings
trialL = 60; profL = 4;
if inp == 5; trialL = 50; profL = 5; end
totL = trialL*profL;
winMod = (1:numPar)'; %#ok<*UNRCH>
winL   = numPar;
winIdx = find(min(sum(bicMatrix)) == sum(bicMatrix));
savePE = zeros(totL,winL);
savePEprof = zeros(trialL,profL,winL);

cnt = 1;
for iC = winMod'
    savePE(1:length(saveFit{iC,winIdx}),cnt) = abs(saveFit{iC,winIdx}(:,1));
    
    % Finding the resets per profile for the winning model
    idx = [find(saveFit{iC,winIdx}(:,2)); length(saveFit{iC,winIdx})];
    for iPr = 1:length(idx)-1
        % Get the absolute PE's per profile of the winning model
        savePEprof((idx(iPr)-idx(iPr))+1:idx(iPr+1)-idx(iPr),iPr,cnt) = abs(saveFit{iC,winIdx}(idx(iPr):idx(iPr+1)-1,1));
    end
    cnt = cnt + 1;
end

%% To plot the mean per profile
figure; hold on
profTot = zeros(trialL,profL);

% Calculate the average per profile over all participants
for iProf = 1:profL
    prof = squeeze(savePEprof(:,iProf,:));
    prof(prof == 0) = nan;
    
    profTot(:,iProf) = nanmean(prof,2);
    
    % To delete a run if it is all zeros
    prof(:,sum(isnan(prof)) == trialL) = [];
    profSTD = std(prof,0,2,'omitnan');
    profMean = movmean(nanmean(prof,2),3);
end
% Calculating mean and std
profSTDAll = std(profTot,0,2,'omitnan');
profMeanAll = movmean(nanmean(profTot,2),3);

% Removing NaN's
plotL = find(~isnan(profMeanAll), 1, 'last' );
profMeanAll = profMeanAll(1:plotL);
profSTDAll = profSTDAll(1:plotL);

%% Plotting the results
close all
plot(profMeanAll, 'k','LineWidth',2)
patch([1:plotL fliplr(1:plotL)], [profMeanAll-profSTDAll; flipud(profMeanAll+profSTDAll)]','r', 'FaceAlpha',0.1, 'EdgeColor','none')

[rho, pval] = corr(profMeanAll, (1:plotL)');
hold on
s = scatter((1:plotL)',profMeanAll);
s.MarkerEdgeColor = 'none';
l = lsline; set(l, 'LineWidth',2)

text(plotL-15,max(profMeanAll+profSTDAll)*.95,{['rho: ', num2str(rho)],['pVal: ',num2str(pval)]})

title(['Mean abs PE: ' figTitle ' # participants: ' num2str(winL)])

xlabel('Trial')
ylabel('Mean abs PE')

% saveas(figure(1), [figTitle '.png'])