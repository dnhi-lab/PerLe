% For plotting the protected exceedance plots
% Make sure the settings in main_analysis are set for the normal model
% and comment-out the input() asking for the experiment number

%% Create a figure
close all
clear
fh1 = figure;
fh1.Position = [335,421,1028,537];
topLetter = {'a','b','c','d','e'};

%% Run all 5 experiments
for expInp = 1:5
    s = subplot(2,3,expInp);
    main_analysis
    PXP_plot(-bicMatrix)
    text(-.15,size(bicMatrix,2)*1.4,topLetter{expInp},'FontSize',25)
    title(['Experiment ' num2str(expInp)])
end
% suptitle('Protected Exceedance Probability: all experiments')