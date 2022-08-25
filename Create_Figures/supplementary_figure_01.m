% Plan is to create a figure that step-by-step builds up to our most complex model
% Starting from behavior: Participants Responses & decrease in PE, adding
% the RP, Rescorla & Wagner -> Course Granularity, & Fine Granularity

%% Settings
tLen = 100;
fLen = 4;
close all
fh = figure;
fh.Position = [470 50 970 950];
fRow = 7;
fCol = 6;
calCol = 1:fCol-1;
% For reference on what subplots to pick
figShap = reshape(1:7*6,6,7)';

% Colors
Col.PE    = [0 .447 .741];
Col.resp  = [.7 .7 .7];
Col.ideal = [.1 .1 .1];

% Add the Factor Patch info
% For the general patches (errors)
xPatch = [0 tLen tLen 0];
% For the background patches (Factors)
nPatch = 5;
sPatch = tLen/nPatch;
xPidx  = 0:sPatch:tLen;

%% Human Behavior: Responses and Prediction Errors
subplot(fRow,fCol,calCol)
% Let's say there's responses by a person that we want to model.
% This is what their responses might look like on a task that doesn't
% change over time

% First the ideal responses
pRespIdeal = sind((1:tLen) * 8) + randn(1,tLen)*.6;
pRespIdeal = pRespIdeal + abs(min(pRespIdeal))+4;
% We expect their absolute prediction error to go down over time
pPE = ((10:-.1:.1).^2)/ (100/(max(pRespIdeal)/2.8)) + randn(1,tLen)*.2;
pPE = pPE + abs(min(pPE));
% Now add these up to show how the participant learns
ranPN = 2*randi([0 1],tLen, 1)-1;
aResp = pRespIdeal' + ranPN.*pPE';
aResp(aResp > 10) = 10;

hold on
% Plot the factor background
yP = [0 0 max(aResp) max(aResp)];

% Plot the lines and the patch
plot(pRespIdeal,'Color',Col.ideal,'LineWidth',2); hold on
plot(aResp,'Color',Col.resp,'LineWidth',2)
patch([1:tLen tLen:-1:1], [zeros(1,tLen) fliplr(pPE)], Col.resp, 'FaceAlpha', .4, 'EdgeColor', 'none')

title('Behavior'); ylabel('scale'); xticks([]); xlabel('Trials over time')

text(-5,12,'\bf\fontsize{25}a')

% Separate subplot to add the legend
legPlot = subplot(fRow,fCol,calCol(end)+1); plot(1,nan,'Color',Col.ideal,'LineWidth',2); hold on
plot(1,nan,'Color',Col.resp,'LineWidth',2); patch([1 1 1 1], [1 1 1 1],Col.resp, 'FaceAlpha', .4, 'EdgeColor','none')
set(legPlot,'Visible','off');
l = legend({'Profile','Part. Resp.','Abs. PE'});
l.FontSize = 10;
l.Position = [.8 .86 .12 .06];

calCol = calCol+fCol;

%% Show the RP on Factors for two groups of people
subplot(fRow,fCol,calCol)
% Create a new Response function to use
pResp = [repelem([5 6],1,10),repelem(3,1,20),repelem([6,4],1,10),repelem([7,9],1,10),repelem(5,1,20)];
pRespMean = [5.5 3 5 8 5];
pResp = pResp + randn(1,100)*.5; pResp(pResp > 9.9) = 9.9;
plot(pResp,'Color',Col.ideal,'LineWidth',2); hold on
title('Building a model: Factor Reference Points')

% Add the background Factor patches
for iPat = 1:2:6
    xP = [xPidx(iPat) xPidx(iPat+1) xPidx(iPat+1) xPidx(iPat)];
    patch(xP,yP,'k', 'FaceAlpha', .1, 'EdgeColor','none')
end

% Colours
Col.badFit  = [171 44 68]/256;
Col.goodFit = [.4660 .674 .188];

% Create Factor Reference Points
rpGood = pRespMean + (randi([0 10],1,5)/10);
rpBad  = rpGood + [-3 3 3 -4 -4];

% Repeat the elements (to create straight lines)
for iP = 1:5
    plot(((0:20) + (iP-1)*20), repelem(rpGood(iP),1,sPatch+1),'Color',Col.goodFit,'LineWidth',2)
    plot(((0:20) + (iP-1)*20), repelem(rpBad(iP), 1,sPatch+1),'Color',Col.badFit,'LineWidth',2)
end

% Calc the PE between the good and bad fitting RP
goodSSE = abs(repelem(rpGood,1,sPatch) - pResp);
goodSSE(goodSSE == 0) = 0.01;
badSSE = abs(repelem(rpBad,1,sPatch) - pResp);

% Plot the patch PE for the RPs
patch([1:tLen tLen:-1:1], [zeros(1,tLen) fliplr(badSSE)], Col.badFit, 'FaceAlpha', .2, 'EdgeColor', 'none')
patch([1:tLen tLen:-1:1], [zeros(1,tLen) fliplr(goodSSE)], Col.goodFit, 'FaceAlpha', .4, 'EdgeColor', 'none')
ylim([0 10])
xticks(10:20:100); xticklabels({'Fac 1','Fac 2','Fac 3','Fac 4','Fac 5'})

text(-5,12,'\bf\fontsize{25}b')

% Plot the Legend
legPlot = subplot(fRow,fCol,calCol(end)+1);
plot(1,nan,'Color',Col.ideal,'LineWidth',2); hold on
plot(1,nan,'Color',Col.goodFit,'LineWidth',2)
plot(1,nan,'Color',Col.badFit,'LineWidth',2)
patch(1,1, Col.badFit, 'FaceAlpha', .2, 'EdgeColor', 'none')
patch(1,1, Col.goodFit, 'FaceAlpha', .4, 'EdgeColor', 'none')
set(legPlot,'Visible','off');
l = legend({'Profile','Good RP','Bad RP','PE good RP','PE bad RP'});
l.FontSize = 10;
l.Position = [.8 .71 .13 .1];

calCol = calCol+fCol;

%% Show the RP for individual items
subplot(fRow,fCol,calCol)
% Create a new Response function to use
% pResp = [repelem([5 6],1,10),repelem(3,1,20),repelem([6,4],1,10),repelem([7,9],1,10),repelem(5,1,20)];
% pRespMean = [5.5 3 5 8 5];
% pResp = pResp + randn(1,100)*.5; pResp(pResp > 9.9) = 9.9;
plot(pResp,'Color',Col.ideal,'LineWidth',2); hold on
title('Building a model: Individual Reference Points')

% Add the background Factor patches
for iPat = 1:2:6
    xP = [xPidx(iPat) xPidx(iPat+1) xPidx(iPat+1) xPidx(iPat)];
    patch(xP,yP,'k', 'FaceAlpha', .1, 'EdgeColor','none')
end

% Create Factor Reference Points
rpGoodInd = [5 6 3 3 6 4 7 9 5 5] + (randi([0 10],1,10)/10);
getGood = repelem(rpGoodInd,1,sPatch/2) + randn(1,100)*.5;

% Repeat the elements (to create straight lines)
for iP = 1:5
    plot(((1:20) + (iP-1)*20), getGood(((1:20) + (iP-1)*20)), 'Color', Col.goodFit, 'LineWidth', 2)
end

% Calc the PE between the good and bad fitting RP
goodSSE = abs(getGood - pResp);
goodSSE(goodSSE == 0) = 0.01;

% Plot the patch PE for the RPs
patch([1:tLen tLen:-1:1], [zeros(1,tLen) fliplr(goodSSE)], Col.goodFit, 'FaceAlpha', .4, 'EdgeColor', 'none')
ylim([0 10])
xticks(10:20:100); xticklabels({'Fac 1','Fac 2','Fac 3','Fac 4','Fac 5'})

text(-5,12,'\bf\fontsize{25}c')

% Plot the Legend
legPlot = subplot(fRow,fCol,calCol(end)+1);
plot(1,nan,'Color',Col.ideal,'LineWidth',2); hold on
plot(1,nan,'Color',Col.goodFit,'LineWidth',2)
patch(1,1, Col.goodFit, 'FaceAlpha', .4, 'EdgeColor', 'none')
set(legPlot,'Visible','off');
l = legend({'Profile','Good RP','PE good RP'});
l.FontSize = 10;
l.Position = [.8 .62 .13 .06];

calCol = calCol+fCol;
cols = [77 190 238; 62 152 190; 46 114 143; 31 76 95; 15 38 48]/255;

%% Coarse Granularity
% This is for the factors
facOneCol = [107,174,214;49,130,189;8,81,156]/255;
facTwoCol = [116,196,118;49,163,84;0,109,44]/255;
cMatCol = [255 255 255; 49,130,189; 49,163,84]/255;
subplot(fRow,fCol, calCol(1):calCol(end-1))

goodRespFac1 = [4.656,4.826,4.704,4.576,4.895,6.206,4.78,5.052,5.369,5.045,5.803,5.979,6.284,6.602,6.315,6.888,6.116,5.533,6.174,6.27];
goodRespFac2 = [2.89,2.418,3.524,3.051,3.298,3.053,3.158,2.83,2.768,3.769,3.602,3.227,2.915,2.588,2.19,3.615,2.932,3.417,3.738,2.272];
goodPResp = [goodRespFac1 goodRespFac2];

plot(goodPResp,'Color',Col.ideal,'LineWidth',2); hold on
title('Building a model: Coarse Granularity')

ylim([0 10])
patch([0 20 20 0],[0 0 10 10],'k', 'FaceAlpha', .1, 'EdgeColor','none')
xticks([10 30]); xticklabels({'Fac 1', 'Fac 2'});

% For Factor One
posCheck = [5 10 15];
facOnePE = [3.4, 1.8, 1];
correctAns = goodPResp(posCheck);
guesses = correctAns - facOnePE;

for iP = 1:3
    plot([0 20],[guesses(iP) guesses(iP)],'linewidth',2,'color',facOneCol(iP,:))
    plot([posCheck(iP) posCheck(iP)], [guesses(iP) correctAns(iP)],'color',facOneCol(iP,:))
    text(posCheck(iP)-1,8.5,['PE: ' num2str(facOnePE(iP))])
end
s = scatter(posCheck, guesses,'filled');
s.CData = facOneCol;
s = scatter(posCheck, goodPResp(posCheck),'filled');
s.CData = facOneCol;

% For Factor Two
posCheck = [25 30 35];
facTwoPE = [2.8, 1.4, .6];
correctAns = goodPResp(posCheck);
guesses = correctAns + facTwoPE;

for iP = 1:3
    plot([20 40],[guesses(iP) guesses(iP)],'linewidth',2,'color',facTwoCol(iP,:))
    plot([posCheck(iP) posCheck(iP)], [guesses(iP) correctAns(iP)],'color',facTwoCol(iP,:))
    text(posCheck(iP)-1,1.5,['PE: ' num2str(facTwoPE(iP))])
end
s = scatter(posCheck, guesses,'filled');
s.CData = facTwoCol;
s = scatter(posCheck, goodPResp(posCheck),'filled');
s.CData = facTwoCol;

text(-2.5,12,'\bf\fontsize{25}d')

% This is for the small plot with two factors
subplot(fRow, fCol, calCol(end))
cFac = eye(2); cFac(4) = 2;
imagesc(repelem(cFac,5,5))
xticks([]); yticks([]);
title('Coarse Matrix')
% #################################
colormap(cMatCol);
% #################################
text(1.5,2.7,'\bfFac 1')
text(6.5,7.7,'\bfFac 2')

legPlot = subplot(fRow,fCol,calCol(end)+1);
for iP = 1:3
    plot(1,nan,'linewidth',2,'color',facOneCol(iP,:)); hold on
end
for iP = 1:3
    plot(1,nan,'linewidth',2,'color',facTwoCol(iP,:))
end
set(legPlot,'Visible','off');
l = legend({'t = 1','t = 2','t = 3','t = 1','t = 2','t = 3'});
title(l,'Factor Timesteps');
l.FontSize = 9;
l.Position = [.8 .5 .14 .06];

calCol = calCol+fCol;

%% Add the Similarity RL
subplot(fRow,fCol, calCol(1:end-1))
% If you only want to plot this figure:
% figure; subplot(2,6,1:4) # For the first row
% Put these subplots in place of the other subplots in this code block
% subplot(2,6,[5 6 11 12]) # for the similarity matrix
% subplot(2,6,7:10) % For the bottom row
pRespSub = repelem([5 6.5 3 2],1,5) + rand(1,20)*.85; %pResp([1:10 21:30]);
plot(.5:1:20,pRespSub ,'Color',Col.ideal,'LineWidth',2); hold on
title('Building a model: Similarity Reinforcement Learning')
xticks(4.5); xticklabels('5')

% Add the background Factor patch
% iPat = 1;
xP = [0 10 10 0];
patch(xP,yP,'k', 'FaceAlpha', .1, 'EdgeColor','none')

% Add the prediction and subsequent error
scatter(4.5,0.2,'k','filled')
% Other items
othr = .5:1:20; othr(5) = [];
s = scatter(othr,repmat(.2,1,19),'filled');
s.CData = [.5 .5 .5];
% Add the Formula
text(12, 7.5, 'PE_t*\alpha*\rho_t    \alpha: .5','FontSize',12,'FontWeight','Bold')

pRespItm = pRespSub(5);
scatter(4.5,pRespItm,'k','filled')
plot([4.5 4.5], [0 pRespItm],'k')
text(5, 3.5,['PE_t: ' num2str(round(pRespItm,2))])

% Calulcate the similarity matrix
simMat = ([ones(10) zeros(10); zeros(10) ones(10)] + rand(20)*1.5);
simMat = simMat / max(simMat,[],'all'); simMat(logical(eye(20))) = 1;

% Add the updated Predictions
updItem = (simMat(5,:)*round(pRespItm,2)*.5);
s = scatter(.5:1:20,updItem,'r','filled');
s.MarkerFaceAlpha = .5;

text(-1.25,12,'\bf\fontsize{25}e')

% Add the Similarity Model
getSub = calCol(end):calCol(end)+1;
getSub = [getSub getSub+fCol];
subplot(fRow,fCol, getSub)

% Create a Correlation Matrix (calculations happen up already)
i = imagesc(simMat); hold on; 

% colormap('gray'); % Run once with the other colormap and once with this
% one. Then paste together in photo editor program

xticks([]); yticks(5); title('Similarity Matrix')
% Add a red bar around the Similarity Matrix
plot([0 21],[4.5 4.5],'r','linewidth',2); plot([0 21],[5.5 5.5],'r','linewidth',2)
plot([.6 .6],[4.5 5.5],'r','linewidth',2); plot([20.4 20.4],[4.5 5.5],'r','linewidth',2);

% Add the Similarity Matrix row here
subplot(fRow,fCol,getSub(2)+1:getSub(3)-1)
xticks([]); yticks([]);

% Red box around the patch
plot(1,nan); hold on;
text(-.75,2.5,'\rho','FontWeight','Bold','FontSize',14)
ylim([0,5]); yticks([]); xticks([])

% Bottom replicate the row from the Similarity Matrix
for iP = 1:length(pRespSub)
    patch([iP-1 iP iP iP-1],[0 0 5 5],i.CData(5,iP));
end
% Need to plot the correlation values separately
for iP = 1:length(pRespSub)
    if i.CData(5,iP) > .5
        cD = [0 0 0];
    else
        cD = [1 1 1];
    end
    text(iP-.5,1.5,num2str(round(simMat(5,iP),2)),'Rotation',90,'Color',cD,'FontWeight','Bold')
end
% % Red box around the patch
plot([0 20],[0 0],'r');plot([0 20],[5 5],'r');
plot([0 0],[0 5],'r'); plot([20 20],[0 5],'r');

%% Plot that combines Factor RP and Sim RL using gamma
subplot(fRow,fCol,figShap(end,1:end-1))
plot(pResp,'Color',Col.ideal,'LineWidth',2); hold on
title('Building a model: Combining Factor RP & Similarity RL')
% Add the background Factor patches
for iPat = 1:2:6
    xP = [xPidx(iPat) xPidx(iPat+1) xPidx(iPat+1) xPidx(iPat)];
    patch(xP, yP, 'k', 'FaceAlpha', .1, 'EdgeColor', 'none')
end
ylim([0 10]); xticks(10:20:100); xticklabels({'Fac 1','Fac 2','Fac 3','Fac 4','Fac 5'})

% Add the formula for the combination (using the \gamma)
text(25,-3,'\gamma * Factor RP + (1 - \gamma) * Similarity RL','FontWeight','bold','FontSize',13)
gamVal = linspace(0,1,3);

allRP  = repelem(rpBad,1,sPatch);
allSim = getGood - repelem([-3 3 3 -4 -4],1,sPatch); allSim(allSim > 10) = 10;

vCol  = cols(1:2:end,:);
for iGam = 1:length(gamVal)
    plotVal = gamVal(iGam) * allRP + (1-gamVal(iGam)) * allSim;
    plot(plotVal,'Color',cols(iGam,:),'LineWidth',2)
end

text(-5,12,'\bf\fontsize{25}f')

% Plot the Legend
legPlot = subplot(fRow,fCol,figShap(end,end));
plot(1,nan,'k','LineWidth',2); hold on
plot(1,nan,'Color',vCol(1,:),'LineWidth',2);
plot(1,nan,'Color',vCol(2,:),'LineWidth',2);
plot(1,nan,'Color',vCol(3,:),'LineWidth',2);
set(legPlot,'Visible','off');
l = legend({'Profile',['\gamma: ' num2str(gamVal(1))],['\gamma: ' num2str(gamVal(2))],['\gamma: ' num2str(gamVal(3))]});
l.FontSize = 10;
l.Position = [.8 .11 .09 .08];
