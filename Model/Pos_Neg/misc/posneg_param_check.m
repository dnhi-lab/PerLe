% Check parameters for positive and negative values
% Model one doesn't have pos/neg
pLen = length(pEst(1).model);
allParam = zeros(pLen, 2, 4);
modPars  = [1 3; 1 4; 1 3; 1 4]; mods = 4; sub = 1;
modName  = { 'RL (Factors)', 'RL (Mean & Fact.)', 'RL (Similarity)', 'RL (Mean & Sim.)'};
if inp == 4
    modPars  = [1 3; 1 4; 1 4; 1 3; 1 4; 1 4];
    mods = 6;
    sub = 2;
    modName  = { 'RL (Factors)', 'RL (Mean & Fact.)', 'RL (STE & Fact.)', 'RL (Similarity)', 'RL (Mean & Sim.)', 'RL (STE & Sim.)'};
end

fh = figure;
sNum = getSubNum(mods);

for iMod = 1:mods
    for iPar = 1:pLen
        allParam(iPar, :, iMod) = pEst(iMod+sub).model{iPar}(modPars(iMod,:));
    end
    
    % Plotting
    subplot(sNum(1),sNum(2),iMod)
    sizeLim = max(max(allParam(:,:,iMod)))*1.1;
    scatter(allParam(:,1,iMod),allParam(:,2,iMod))
    ylim([0 sizeLim]); xlim([0 sizeLim])
    xlabel('Negative'); ylabel('Positive')
    hold on
    plot([0, sizeLim],[0, sizeLim])
    title(modName{iMod})

    text(sizeLim*.8,sizeLim*.2, ['# neg: ' num2str(sum(allParam(:,1,iMod)>allParam(:,2,iMod)))])
    text(sizeLim*.2,sizeLim*.8, ['# pos: ' num2str(sum(allParam(:,1,iMod)<allParam(:,2,iMod)))])
end

suptitle(figTitle)
fh.WindowState = 'maximized';