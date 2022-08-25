% Creates figure that summarizes all the data from each experiment
close all
clear

for iExp = 1:5
    fh1 = figure;
    % So it fits within margins of Nat Comm.
    fh1.Units = 'centimeters';
    fh1.Position = [1 1 18.9000 16];

%% Plot the Computational models
%% Regular BIC
load(['Data\fig_03-07_results\fig' num2str(iExp) '_reg.mat'])
bicPlot = subplot(9,9,[1:4 10:13 19:22 28:31]);
BIC_fixed_plot_v5(bicMin);

title('\fontsize{12}Computational Models \fontsize{9}(Model Fit)')
switch iExp
    case 1
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 2 as reference)')
    case 2
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 1 as reference)')
    case 3
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 1 as reference)')
    case 4
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 2 as reference)')        
    case 5
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 1 as reference)')
end
yticks([])

yyaxis right
a = gca();
a.YColor = [0 0 0];

if length(bicMin) == 5
    yticks(1:5)
    yticklabels({'\fontsize{11}\bfFG\rm & Pop. \bfRP\rm','\fontsize{11}Fine Granularity','\fontsize{11}\bfCG\rm & Pop. \bfRP\rm', ...
        '\fontsize{11}Coarse Granularity','\fontsize{11}No Learning'})
else
    yticks(1:8)
    yticklabels({'\fontsize{11}\bfFG\rm & \bfSTE RP\rm','\fontsize{11}\bfFG\rm & Pop. \bfRP\rm','\fontsize{11}Fine Granularity', ...
        '\fontsize{11}\bfCG\rm & \bfSTE RP\rm','\fontsize{11}\bfCG\rm & Pop. \bfRP\rm', ...
        '\fontsize{11}Coarse Granularity', '\fontsize{11}No Learning \bfSTE\rm', '\fontsize{11}No Learning'})
end
bicPlot.Position = [0.13,0.577316513761468,0.327792207792208,0.347683486238532];

text(a.XLim(1)*1.1,a.YLim(2)*1.2,'\fontsize{20}a');

%% Simulated BIC
load(['Data\fig_03-07_results\fig' num2str(iExp) '_sim.mat'])
simPos = subplot(9,9,[6:9 15:18 24:27 33:36]);
BIC_fixed_plot_v5(bicMin);

title('\fontsize{12}Simulations \fontsize{9}(Best Performing Model)')
switch iExp
    case 1
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 2 as reference)')
    case 2
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 1 as reference)')
    case 3
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 2 as reference)')
    case 4
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 1-STE as reference)')        
    case 5
        xlabel('\fontsize{10}Summed BIC\fontsize{8} (Model 3 as reference)')
end
yticks([])

b = gca();
text(b.XLim(1)*1.1,b.YLim(2)*1.2,'\fontsize{20}b');

%% real data
sReal = subplot(9,9,[46:49 55:58]); hold on

model_free_newFig
title('Average PEs over trials')
xlabel('Trials')
sReal.Position = [0.13,0.296926605504587,0.245541125541126,0.160756880733945];

c = gca();
text(c.XLim(1)-(c.XLim(2)*.25),c.YLim(2)*1.1,'\fontsize{20}c');

%% Simulations
sSim = subplot(9,9,[64:67 73:76]); hold on
model_free_newFig_model
sSim.Position = [0.13,0.11,0.245541125541126,0.160756880733945];

%% GLM
subplot(9,9,[51:54 60:63 69:72 78:81]); hold on
modSim_GLM_v2
title('\fontsize{12}Standard Analysis \fontsize{9}(GLM)')
xticks(1:3)
xticklabels({'# Previous Trials','# Previous trials in factor','Sum abs. correlations'});
xtickangle(8)

ylabel('Parameter Estimates')

d = gca();
text(d.XLim(1)-(d.XLim(2)*.06),d.YLim(2)*1.42,'\fontsize{20}d');

%%
sTit = suptitle(['Experiment: ' num2str(iExp)]);
sTit.Position = [0.473389355742297,-0.05,0];

bicPlot.Position = [0.099201940035273,0.550342432970008,0.327792207792208,0.326575568242777];
simPos.Position = [0.614966129549464,0.550342432970008,0.305432900432901,0.326575568242777];

% Automatic Saving
% saveas(figure(1),['Figure_' num2str(iExp+2)])
% close all
clear
end