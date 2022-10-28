%% GLM-fitted Model Simulations
% fh = figure;
% for iExp = 1%:5

% Simulating
% iExp = 2;
%% Generate random parameters
numParam = 200;
parameters = randi([20,80],numParam,2)/100;
dir_base = 'C:\Users\frolichs\Documents\GitHub\RL\PerLe\Data\';

%% Get the profiles (based on data set) and create the rest of the data
if iExp < 1 || iExp > 5; error('Cannot parse this input'); end
load(['Data\simulations\prof_' num2str(iExp)])

% cPall = [53 101 161; 230 91 153; 255 166 0]./255;
cPall = [100 100 100; 230 91 153; 255 166 0]./255;
%% Simulate data
% [simData, data, numIt, sweepR] = sim_data(iExp, profiles, numParam, parameters);

%% The GLM Part
% Model free analysis

getStats = zeros(4,3,5);
% fh = figure;
% fh.Position = [680,216,809,882];
topLeft = {'a','b','c','d','e'};

% Load the data
profL = 4; facL = 5; sp = [2 3]; trialL = 60;
expNum = iExp;
switch expNum
    case 1
        dir_data = 'ML_DATA\';
        partName = 'ML_data_';
        partSim     = [138 238 139 239 140 240 141 241 142 242 143 243 144 244 ...
            145 245 146 246 147 247 148 248 149 249 150 151 251 152 252 153 253 262 264 165 265];
        facNames = {'Neuroticism','Extraversion','Extraversion','Agreeableness','Conscientiousness'};
    case 2
        dir_data = 'ML_DATA_clu\';
        partName = 'ML_data_clu_';
        partSim     = [1170 1270 1171 1271 1172 1272 1173 1273 1274 1175 1275 ...
            1176 1276 1177 1277 1178 1278 1179 1279 1180 1280 1181 1281 1182 1282 1183 1283, 3001:3013,3015];
        facL = 2; sp = [1 3];
        facNames = {'Agreeableness','Conscientiousness'};
    case 3
        dir_data = 'ML_data_cre\';
        partName = 'ML_data_cre_';
        partSim = [4001,4002,4004:4032,4037,4039:4044,4046,4047, 4050:4068];
        facL = 2; sp = [1 3];
        facNames = {'Agreeableness','Conscientiousness'};
    case 4
        dir_data = 'ML_data_fas\';
        partName = 'ML_data_fas_';
        partSim= 5001:5030; partSim(20) = [];
        load([dir_base dir_data 'neoOrder'],'neoOrder')
        facNames = {'Neuroticism','Extraversion','Extraversion','Agreeableness','Conscientiousness'};
    case 5
        dir_data = 'ML_data_ipip\';
        partName = 'ML_data_ipip_';
        partSim = 5001:5030; partSim([20 27]) = [];
        load([dir_base dir_data partName  '5001\' partName '5001'],'D')
        profL = 5; trialL = 50;
        facNames = {'Extraversion','Neuroticism','Agreeableness','Conscientiousness','Openness'};
end
load('C:\Users\frolichs\Documents\Koen\Projects\PerLe\PerLe_Publish\Data\sweeps.mat')
sweepR = sweeps{expNum,1};

%% Get Information
pLen = length(partSim);
parDat = nan(trialL,4,profL,pLen);
parDatv2 = nan(trialL,4,pLen);
pIdx = 1:trialL:(profL+1)*trialL;
idx3 = 1:trialL*profL:trialL*profL*(pLen+1);
for iP = 1:pLen
    load([dir_base dir_data partName num2str(partSim(iP)) '\' partName num2str(partSim(iP))],'DATA')
    d = DATA.exp_data;

    for iProf = 1:profL
        cmp  = [1 10];
        p = d(:,:,iProf);

        % Need to add the factor information for these profiles
        if expNum == 2 || expNum == 3
            p(p(:,3) <= 30,11) = 1;
            p(p(:,3) > 30,11)  = 2;
        elseif expNum == 4
            tmp = sortrows(p,3);
            tmp(:,11) = neoOrder(tmp(:,3));
            p = sortrows(tmp,1);
        elseif expNum == 5
            for iAdd = 1:facL
                p(p(:,3) >= cmp(1) & p(:,3) <= cmp(2),11) = iAdd;
                cmp = cmp + 10;
            end
        end
        % Remove the NaN's in the middle of the data
        p(isnan(p(:,6)),:) = [];

        getP = abs(p(:,6) - p(:,9));
        getP(:,2:4) = [(1:length(getP))' zeros(length(getP),2)];
        cntFac = zeros(1,facL);
        for iL = 2:length(getP)
            % Count the number of previous items in this factor
            getP(iL,3) = cntFac(p(iL,11));
            cntFac(p(iL,11)) = cntFac(p(iL,11)) + 1;
            % Get the summed correlations of previous info
            getP(iL,4) = sum(abs(sweepR(p(iL,3),p(1:iL-1,3))));
        end
        parDat(1:length(getP),:,iProf,iP) = getP;
        % Columns: 1. PE 2. # Previous Items 3. # Previous Factor, 4. # Summed Correlations.
        parDatv2(pIdx(iProf):pIdx(iProf)+length(getP)-1,:,iP) = getP;
    end
end

%% Do a regressor per participant then t-test on the beta's
% Loop over the participant and perform a regressor on each of the columns
pLen = size(parDatv2,3);
numR = 3;
% Because you're also getting the intercept betas back
betas = zeros(pLen, 2, numR);
for iP = 1:pLen
    y = parDatv2(:,1,iP);
    x = ones(length(y),1);
    for iR = 1:numR
        betas(iP,:,iR) = regress(y, [x, parDatv2(:,1+iR,iP)]);
    end
end

% Now do some t-tests on the beta's to see if they are significantly
% different from zero. One sided because we expect them to be smaller.
%     subplot(3,2,expNum); hold on
for iCom = 1:numR
    s = scatter((randi([25 75],pLen,1)/100)+(iCom-1), betas(:,2,iCom),'filled');
    s.CData = cPall(iCom,:);
end

for iCom = 1:numR
    [h,p, ~, stats] = ttest(betas(:,2,iCom),0,'Tail','Left');
    getStats(:,iCom, expNum) = [h,p,stats.tstat,stats.df];
    pVal = ['p: ' num2str(round(p,4))]; sigVal = '';
    if p < 0.001
        pVal = 'p: < 0.001';
        sigVal = '**';
    elseif p < 0.05
        sigVal = '*';
    end
    text(iCom-.4, min(min(squeeze(betas(:,2,:))))*.9,pVal,'FontWeight','Bold')
    text(iCom-.4, min(min(squeeze(betas(:,2,:))))*.85,sigVal,'FontWeight','Bold','FontSize',15)
end

plot([0 4], [0 0], 'color', [.8 .8 .8])
%     g = {'# prev. trials', '# prev. trials fact.','Sum Abs corr'};
%     boxplot([betas(:,2,1), betas(:,2,2),betas(:,2,3)],'Widths',.3,'Colors',[0 .447 .741; .85 .325 .098; .929 .694 .125])
boxplot([betas(:,2,1), betas(:,2,2),betas(:,2,3)],'Widths',.3,'Colors',cPall)
xlabel([]); xticks([])
%     ylabel('Parameter Estimates')
title(['Experiment: ' num2str(expNum)])

%     getAx = gca();
%     text(getAx.XLim(1),getAx.YLim(2)*.92,['\fontsize{22}' topLeft(iExp)])
% end
% end