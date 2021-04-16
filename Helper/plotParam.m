% Quick parameter plotter
close all
modName = fliplr(Yticklab);

for iMod = 1:length(pEst)
    param = zeros(length(pEst(1).model), length(pEst(iMod).model{1}));
    for iPar = 1:length(pEst(1).model)
        param(iPar,:) = pEst(iMod).model{iPar};
    end
    
    % Plotting
    figure
    suptitle([figTitle, ' Model: ',modName{iMod}])
    for iPlot = 1:length(pEst(iMod).model{1})
        subplot(1,length(pEst(iMod).model{1}),iPlot)
        stem(param(:,iPlot))
        if max(param(:,iPlot)) > 1
            ylim([0 ansOpt(end)])
        else
            ylim([0 1])
        end
        xlabel(['mean: ' num2str(round(mean(param(:,iPlot)),2))])
    end
end