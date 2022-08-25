%% Add the modeling data
datNam = ['fig2_exp' num2str(iExp) '_mod.mat'];
load(datNam);
catMean = mean(catPE,2);
modCol = [.8 .3 .3];

% Calculate the Correlation from the simulations
[rhoSim, pval] = corr(catMean, (1:length(catMean))');
if pval < 0.001
    pTextSim = 'p < 0.001';
else
    pTextSim = ['p = ' num2str(round(pval,3))];
end

plotL = size(catMean,1);
cat_SEM  = std(catPE,[],2,'omitnan') ./ sqrt(length(catPE));

plot(catMean,'LineWidth',2, 'Color', 'k')
patch([1:plotL fliplr(1:plotL)], [catMean-cat_SEM; flipud(catMean+cat_SEM)]', 'k', 'FaceAlpha', .3, 'EdgeColor','none')

fh2 = figure;
s = scatter((1:plotL)',catMean);
s.MarkerEdgeColor = 'none';
lCat = lsline;
lsX = lCat.XData;
lsY = lCat.YData;
close
figure(fh1.Number)
plot(lsX,lsY,'LineWidth',2, 'Color', [.8 .3 .3])

% ylabel({'\bfSimulations', '\rmMean abs PE'})
ylabel('\rmMean abs PE')
xlabel('Trials')

l = legend({'abs PE','SEM','LSLine'},'Location','bestoutside');
title(l,'Simulations')

if iExp == 5; xlim([0, 50]); end
a = gca();
text(a.XLim(2)*(2/3), a.YLim(2)*.9, ['\rho: ' num2str(round(rhoSim,3))])
