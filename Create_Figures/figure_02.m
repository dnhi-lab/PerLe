%% Load some data (Doesn't matter what)
load('PerLe_Publish\Data\experiments\ExperimentFive.mat', 'sweepR')
load('PerLe_Publish\Data\summData.mat', 'avgSelf')

%% Open the figure
close all
fh = figure;
% So it fits within an A4
fh.Units = 'centimeters';
fh.Position = [1 1 18.9000 15];

% For reference what index the subplots should be
subShape = reshape(1:150,15,10)';

% Settings
finCol = [103,0,31; 178,24,43; 214,96,77; 244,165,130; 253,219,199; 247,247,247; ...
    209,229,240; 146,197,222; 67,147,195; 33,102,172; 5,48,97]/255;
refCol3 = [255,255,255;189,189,189;150,150,150;115,115,115;82,82,82;37,37,37]/255;

%% Reference Point
rp = subplot(10,15,reshape(((1:5)+repmat((0:15:60)',1,5)),1,25));

norIdx = 1:10:60;
gapIdx = 1:6:30;
avgGap = zeros(29,1);
for iAdpt = 1:5
    avgGap(gapIdx(iAdpt):gapIdx(iAdpt)+4) = avgSelf(norIdx(iAdpt):norIdx(iAdpt)+4);
end

% Plot the factors
b = barh(avgGap); b.FaceColor = 'flat'; b.EdgeColor = [1 1 1];
% Add the colors
for iC = 1:5
    b.CData(gapIdx(iC):gapIdx(iC)+4,:) = repmat(refCol3(iC+1,:),5,1);
end
xlim([0 4.5]); xticks(0:4); yticks([]); xlabel('\fontsize{10}Rating')
xticklabels({'\fontsize{10}1','\fontsize{10}2','\fontsize{10}3','\fontsize{10}4','\fontsize{10}5'});
% yyaxis right
a = gca();
a.YColor = [0 0 0];
yticks(3:6:30); yticklabels({'\fontsize{10}Extraversion','\fontsize{10}Neuroticism',...
    '\fontsize{10}Agreeable','\fontsize{10}Conscientious','\fontsize{10}Openness'})
title('\fontsize{12}Reference Point [RP]')

text(-1.5,a.YLim(2)*1.15,'\fontsize{20}a');

%% Coarse models
subplot(10,15,reshape(((6:10)+repmat((0:15:60)',1,5)),1,25));
gapIdx = 1:11:54;
coarse = repelem(eye(5) .* [5:-1:1],11,11); %#ok<NBRAK>
% Need to add the gaps between the Factors
coarse(gapIdx(2:5),:) = 0; coarse(:,gapIdx(2:5)) = 0;
coarse(1,:) = []; coarse(:,1) = [];
% Plot
imagesc(coarse); colormap(refCol3); %colormap(coaCol);

xticks([]); yticks([]); %xlabel('Coarse Factors')
% title({'\fontsize{20}Coarse Granularity','\fontsize{12}\rmGeneralizes over Factors'})
title('\color[rgb]{.902, .3569, .6}\fontsize{12}Coarse Granularity')
xlabel({'\fontsize{10}\rmGeneralizes over',' \bfF\rmactors'})

%% Fine Models
axFine = subplot(10,15,reshape(((11:15)+repmat((0:15:60)',1,5)),1,25));

imagesc(sweepR); c = colorbar;
colormap(axFine, finCol);
c.Position = [.920585176186717,.529100529100529,.017226890756303,.395061728395062];

xticks([]); yticks([]); %xlabel('Fine Factors')
title('\color[rgb]{1, .651, 0}\fontsize{12}Fine Granularity');
xlabel({'\fontsize{10}\rmGeneralizes over','\bfall\rm items'})

%% Model Title texts
fntSz = 12;
% Model 1
yPos = -3;
splot = subplot(10,15,76); plot(1,1);
set(splot,'Visible','off');
text(0,yPos,{'\color[rgb]{.2078,.3961,.6314}Model 1', '[No Learning]'},'FontSize',fntSz)
bText = text(-4.5,0,'\fontsize{20}b');
% Model 2
splot = subplot(10,15,91); plot(1,1);
set(splot,'Visible','off');
text(0,yPos,{'\color[rgb]{.902, .3569, .6}Model 2', '[Coarse Granularity]'},'FontSize',fntSz)
% Model 3
splot = subplot(10,15,106); plot(1,1);
set(splot,'Visible','off');
text(0,yPos,{'\color[rgb]{.902, .3569, .6}Model 3', '[Coarse Gran. & RP]'},'FontSize',fntSz)
% Model 4
splot = subplot(10,15,121); plot(1,1);
set(splot,'Visible','off');
text(0,yPos,{'\color[rgb]{1, .651, 0}Model 4', '[Fine Granularity]'},'FontSize',fntSz)
% Model 5
splot = subplot(10,15,136); plot(1,1);
set(splot,'Visible','off');
text(0,yPos,{'\color[rgb]{1, .651, 0}Model 5', '[Fine Gran. & RP]'},'FontSize',fntSz)

%% Model Text
% Model 1
splot = subplot(10,15,81); plot(1,1);
set(splot,'Visible','off');
text(-1,yPos,'\itP\rm = RP \cdot Slope + Int','FontSize',fntSz)
% Model 2
splot = subplot(10,15,96); plot(1,1);
set(splot,'Visible','off');
% text(0,1,'   P_{(t+1,F)} = P_{(t,F)}    +                     \alpha\cdotPE','FontSize',fntSz,'FontWeight','bold')
text(-1,yPos,'\itP_{\rm(\itt\rm+1,\itF\rm)} = \itP\rm_{(\itt,F\rm)}+ \it\alpha \rm\cdotPE','FontSize',fntSz)
% Model 3
splot = subplot(10,15,111); plot(1,1);
set(splot,'Visible','off');
text(-1,yPos,'\itP\rm_{(\itt\rm+1,\itF\rm)} = \it\gamma\rm \cdot RP + (1-\it\gamma)\rm \cdot (\itP\rm_{(\itt,F\rm)} + \it\alpha \rm\cdot PE)','FontSize',fntSz)
% Model 4
splot = subplot(10,15,126); plot(1,1);
set(splot,'Visible','off');
text(-1,yPos,'\itP\rm_{(\itt\rm+1,all)}= \itP\rm_{(\itt\rm,all)} + \it\alpha \rm\cdot PE \cdot SIM','FontSize',fntSz)
% Model 5
splot = subplot(10,15,141); plot(1,1);
set(splot,'Visible','off');
text(-1,yPos,'\itP\rm_{(\itt\rm+1,all)}= \it\gamma\rm \cdot RP + (1-\it\gamma\rm) \cdot (\itP\rm_{(\itt\rm,all)}+ \it\alpha\rm \cdot PE \cdot SIM)','FontSize',fntSz)
