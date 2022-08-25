function [simData, data, numIt, sweepR] = sim_data(dataInp, profiles, numParam, parameters)
% Get profile info
% Item list:
load 'Data\ML_TRAIT_125_bot_v1.mat' TRAIT_125_bot;
if dataInp == 1 || dataInp == 4
    toDelete     = [9, 11, 17, 21, 25, 28, 33, 34, 37, 39, 52, 59, 60, 61, 62, 69, 74, 75, 78, 80];
    item60 = 1:80;
    item60(toDelete) = [];

    avgSelf = nanmean(TRAIT_125_bot(1:80,:),2);
    avgSelf = avgSelf(item60);

    sweepR = corr(TRAIT_125_bot(1:80,:)', 'rows', 'pairwise');
elseif dataInp == 2 || dataInp == 3
    load 'Data\ML_conv_125_to_60_v1.mat' conv_125_to_60;
%     toDelete = find( (ismember(1:125, conv_125_to_60)) == 0);
    item60   = conv_125_to_60';

    avgSelf = nanmean(TRAIT_125_bot(:,:),2);
    avgSelf = avgSelf(item60);

    sweepR = corr(TRAIT_125_bot(:,:)', 'rows', 'pairwise');
else
    item60 = 1:50;
    load Data\summData avgSelf sweepR
end

% Create the "data" matrix:
profSize = size(profiles);
dataSize = profSize(1) * profSize(2);
data = [zeros(dataSize,1) ,...
    reshape(profiles, dataSize,1)  ,... % Data
    repmat(avgSelf, profSize(2),1) ,... % Pop. Mean
    zeros(dataSize,1), ...
    reshape([ones(1,profSize(2));zeros(profSize(1)-1,profSize(2))],dataSize,1), ... % Adds the resets
    zeros(dataSize,1), ...
    repmat(item60', profSize(2),1)]; % Item list 60

%% Simulate data and add noise
global startVal modOpt modUse
startVal = 0;
% Unnecessary for simulation but needs to be added for models to function
modOpt = '';
modUse = '';

numIt = numParam;
simData = zeros(dataSize, numIt, 5);
for iSim = 1:numIt
    if size(parameters,2) == 2
        [~, simData(:,iSim,1)]    = mod01_No_Learning(data, [parameters(iSim,1),4.5]);
        [~, simData(:,iSim,2)]    = mod02_Coarse_Granularity(data, [parameters(iSim,1),4.5]);
        [~, ~, simData(:,iSim,3)] = mod03_CG_Pop_RP(data, parameters(iSim,:));
        [~, ~, simData(:,iSim,4)] = mod04_Fine_Granularity(data, [parameters(iSim,1),4.5], sweepR);
        [~, ~, simData(:,iSim,5)] = mod05_FG_Pop_RP(data, parameters(iSim,:), sweepR);
    elseif size(parameters,2) == 3    
        [~, simData(:,iSim,1)]    = mod01_No_Learning(data, parameters(iSim,[1 3]));
        [~, simData(:,iSim,2)]    = mod02_Coarse_Granularity(data, parameters(iSim,[1 3]));
        [~, ~, simData(:,iSim,3)] = mod03_CG_Pop_RP(data, parameters(iSim,:));
        [~, ~, simData(:,iSim,4)] = mod04_Fine_Granularity(data, parameters(iSim,[1 3]), sweepR);
        [~, ~, simData(:,iSim,5)] = mod05_FG_Pop_RP(data, parameters(iSim,:), sweepR);
    else
        error('Did not get a correct number of parameters size([],2) should be: 2 or 3')
    end
end

% Add some noise
simNoise = randn([dataSize, numIt, 5])*.5;
simData = simData + simNoise;
simData(simData < 1) = 1;
simData(simData > 8) = 8;