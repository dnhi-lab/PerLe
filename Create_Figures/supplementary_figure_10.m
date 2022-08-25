% For plotting self vs population models
% Need to first run the analysis for the normal models (save BIC's in bicNormal)
% and then for Self Models (save in bicSelf)

global selfUse;
bicTotals = cell(1,5);
for expInp = 1:5
    selfUse = 0;
    analysisRealData
    bicNormal = bicMatrix;
    selfUse = 1;
    analysisRealData
    bicSelf = bicMatrix;
    
    if expInp == 4
        bicTotals{1,expInp} = sum([bicNormal(:,1) bicSelf(:,1) bicNormal(:,2)...
            bicNormal(:,3) bicNormal(:,4) bicSelf(:,4) bicNormal(:,5) ...
            bicNormal(:,6) bicNormal(:,7) bicSelf(:,5) bicNormal(:,8)]);
    else
        bicTotals{1,expInp} = sum([bicNormal(:,1) bicSelf(:,1) bicNormal(:,2) ...
            bicNormal(:,3) bicSelf(:,3) bicNormal(:,4) bicNormal(:,5) bicSelf(:,5)]);
    end
end

%%
charLabel = {'a','b','c','d','e'};
close all
fh = figure;
fh.Position = [856,419,989,487];
splot = subplot(2,3,1); plot(1,1); set(splot,'Visible','off');

modelLabel = {'1. No Learning Pop.','2. No Learning Self','3. Coarse G.','4. Coarse G. & Pop. RP',...
    '5. Coarse G. & Self RP','6. Fine G.','7. Fine G. & Pop. RP','8. Fine G. & Self RP', '', ...
    '9. No Learning STE', '10. Coarse G. & STE RP', '11. Fine G. & STE RP'};

text(0,1,modelLabel,'FontSize',9)

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
        b.CData(11,:)    = cPall(1,:);
        b.CData(10,:)    = [158,188,218]/255;
        b.CData(9,:)     = cPallSTE(1,:);
        
        b.CData([8,7],:) = repmat(cPall(2,:),2,1);
        b.CData(6,:)     = cPallPN(2,:);
        b.CData(5,:)     = cPallSTE(2,:);
        
        b.CData([4,3],:) = repmat(cPall(3,:),2,1);
        b.CData(2,:)     = cPallPN(1,:);
        b.CData(1,:)     = cPallSTE(3,:);
        
        yticklabels(fliplr({'1','2','9','3','4','5','10','6','7','8','11'}));
    else
        b.CData(8,:) = cPall(1,:);
        b.CData(7,:) = [158,188,218]/255;

        b.CData([6,5],:) = repmat(cPall(2,:),2,1);
        b.CData(4,:)     = cPallPN(2,:);

        b.CData([3,2],:) = repmat(cPall(3,:),2,1);
        b.CData(1,:)     = cPallPN(1,:);
        yticklabels(num2str((8:-1:1)'))
    end
    
    a = gca();
    text(a.XLim(1)*1.15,a.YLim(2)*1.1,['\fontsize{15}' charLabel{iExp}])
    title(['Experiment ' num2str(iExp)])
    xlabel('Summed BIC')
    
end