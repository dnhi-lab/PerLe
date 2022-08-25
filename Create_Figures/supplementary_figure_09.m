% For plotting positive negative models
% Need to first run the analysis for the normal models (save BIC's in bicNormal)
% and then for Positive/ Negative Models (save in bicPosNeg)
global modUse;
bicTotals = cell(1,5);
for expInp = 1:5
    modUse     = '';
    analysisRealData
    bicNormal = bicMatrix;
    modUse     = 'posneg';
    analysisRealData
    bicPosNeg = bicMatrix;
    
    if expInp == 4
        bicTotals{1,expInp} = reshape([sum(bicNormal(:,3:end));sum(bicPosNeg(:,3:end))],1,12);
    else
        bicTotals{1,expInp} = reshape([sum(bicNormal(:,2:end));sum(bicPosNeg(:,2:end))],1,8);
    end
end

%% Plotting
charLabel = {'a','b','c','d','e'};
close all
fh = figure;
fh.Position = [856,419,989,487];
splot = subplot(2,3,1); plot(1,1); set(splot,'Visible','off');
modelLabel = {'12. Fine G. & STE RP Pos/Neg','11. Fine G. & STE RP', ...
    '10. Coarse G. & STE Pos/Neg','9. Coarse G. & STE RP','', ...
    '8. Fine G. & Pop RP Pos/Neg','7. Fine G. & Pop RP','6. Fine G. Pos/Neg', ...
    '5. Fine Granularity','4. Coarse G. & Pop RP Pos/Neg','3. Coarse G. & Pop RP','2. Coarse G. Pos/Neg','1. Coarse Granularity'};
text(0,1,fliplr(modelLabel),'FontSize',9)

for iExp = 1:5
    subplot(2,3,iExp+1)
    bicTot = bicTotals{1,iExp};
    
    nn = size(bicTot, 2);
    bicF_rev = zeros(1,nn);
    for ii = 1:nn
        bicF_rev(1,ii) = bicTot(1,nn+1-ii);
    end

    bicF_rev = bicF_rev - max(bicF_rev);

    % Color pallete, change these to change bar colors
    cPall    = [53 101 161; 230 91 153; 255 166 0]./255;
    cPallSTE = [27 54 87; 174 56 109; 188 129 18]./255;
    cPallPN  = [166,97,26;94,60,153]./255;

    b = barh( bicF_rev, 'k' );
    b.FaceColor = 'flat';

    if iExp == 4
        b.CData([12,10],:) = repmat(cPall(2,:),2,1);
        b.CData([6,4],:) = repmat(cPall(3,:),2,1);

        b.CData([11,9],:) = repmat(cPallPN(2,:),2,1);
        b.CData([5,3],:) = repmat(cPallPN(1,:),2,1);
        
        b.CData(8,:) = [.5 .5 .5];
        b.CData(7,:) = [.3 .3 .3];
        b.CData(2,:) = [.5 .5 .5];
        b.CData(1,:) = [.3 .3 .3];
        
        yticklabels(fliplr({'1','2','3','4','9','10','5','6','7','8','11','12'}))
    else        
        b.CData([8,6],:) = repmat(cPall(2,:),2,1);
        b.CData([4,2],:) = repmat(cPall(3,:),2,1);

        b.CData([7,5],:) = repmat(cPallPN(2,:),2,1);
        b.CData([3,1],:) = repmat(cPallPN(1,:),2,1);
        yticklabels(num2str((8:-1:1)'))
    end
    a = gca();
    text(a.XLim(1)*1.15,a.YLim(2)*1.1,['\fontsize{15}' charLabel{iExp}])
    title(['Experiment ' num2str(iExp)])
    xlabel('Summed BIC')
end