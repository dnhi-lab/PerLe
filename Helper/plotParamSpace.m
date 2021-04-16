function plotParamSpace(modelFit, numParam, modNum, sv, bicMatrix, pEst, modName, minMax)
revCM = 64:-1:1;
cMap = jet;
cMap = cMap(revCM,:);
if numParam == 2 % If the model only has two parameters
    imagesc(squeeze(modelFit(:,1,:)))
    title(['Model:' modName])
else % Model has 3 parameters
    % Plot with the best fitting start val
    bestFit = zeros(100,1);
    for iFit = 1:100
        bestFit(iFit) = min(modelFit(:,:,iFit),[],'all');
    end
    [~, idx] = min(bestFit);
    imagesc(modelFit(:,:,idx))
    title(['Model:' modName '| Optimal Start Value: ' num2str(sv(idx))])
end
colormap(cMap)

%% Labels
caxis(minMax)
cb = colorbar;
cb.Label.String = 'SSE';
cb.FontSize = 14;

yticks([1 50 100])
yticklabels({'1', '.5', '0'})
ylabel('Param: \alpha', 'FontWeight','bold', 'FontSize', 18)
if numParam == 3
    xticks([1 50 100])
    xticklabels({'0', '.5', '1'})
    xlabel('Param: \gamma', 'FontWeight','bold', 'FontSize', 18)
elseif numParam == 2
    xticks([1 50 100])
    xticklabels({'1', '4', '8'})
    xlabel('Param: Start Value', 'FontWeight','bold', 'FontSize', 14)
    if modNum == 1
        xlabel('Param: Intercept', 'FontWeight','bold', 'FontSize', 14)
        ylabel('Param: Slope', 'FontWeight','bold', 'FontSize', 18)
    end
else
    warning('Did not get a correct amount of parameters')
end

%% Add the individual parameter estimates
bicRes = [bicMatrix min(bicMatrix,[],2)];
winMod = find(bicRes(:,modNum) == bicRes(:,end));

hold on
for iScat = 1:length(bicMatrix)
    if numParam == 3 % Three parameter models (use alpha and gamma)
        if sum(winMod == iScat) % If it is the winning model
            scatter(pEst(modNum).model{1,iScat}(2)*(100),   100-(pEst(modNum).model{1,iScat}(1)*100), 'filled','d','MarkerFaceColor',[.5 .5 .5])
        else
            scatter(pEst(modNum).model{1,iScat}(2)*(100),   100-(pEst(modNum).model{1,iScat}(1)*100), 'filled','MarkerFaceColor',[.9 .9 .9])
        end
    else % Two parameter models (use alpha and startVal)
        if sum(winMod == iScat)
            scatter(pEst(modNum).model{1,iScat}(2)*(100/8), 100-(pEst(modNum).model{1,iScat}(1)*100), 'filled','d','MarkerFaceColor',[.5 .5 .5])
        else
            scatter(pEst(modNum).model{1,iScat}(2)*(100/8), 100-(pEst(modNum).model{1,iScat}(1)*100), 'filled','MarkerFaceColor',[.9 .9 .9])
        end
    end
end
    