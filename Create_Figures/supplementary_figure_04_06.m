% Parameter Recovery
fh1 = figure;
fh2 = figure;
fh3 = figure;
subCnt = [1 6];

for iExp = 1:5
    dataInp = iExp;
    %% Get the profiles (based on data set) and create the rest of the data
%     dataInp  = input(['Profiles from what dataset would you like to use? [1-5]' newline ': ']);
    if dataInp < 1 || dataInp > 5; error('Cannot parse this input'); end
    load(['Data\simulations\prof_' num2str(dataInp)])

    %% Create the parameters
    numParam = 200;
    parameters = randi([1,99],numParam,2)/100;

    scale = 8;
    if dataInp == 5; scale = 5; end

    strt = randi([10,scale*100], numParam, 1)/100;
    parameters = [parameters, strt]; %#ok<AGROW>
    %% Simulate data
    [simData, data, numIt, sweepR] = sim_data(dataInp, profiles, numParam, parameters);

    %% Recover the parameters
    % recData = zeros(3, numIt, 5);
    recData = zeros(numIt, 3, 5);
    param       = [0.5 0.5 4.5];
    paramSimple = [0.5 4.5];

    for iRec = 1:numIt
        data(:,1) = simData(:,iRec,1);
        [recData(iRec,1:2,1), ~, ~] = fitting_fminsearch_model_01(data, paramSimple);

        data(:,1) = simData(:,iRec,2);
        [recData(iRec,1:2,2), ~, ~] = fitting_fminsearch_model_02(data, paramSimple);

        data(:,1) = simData(:,iRec,3);
        [recData(iRec,:,3), ~, ~]   = fitting_fminsearch_model_03(data, param);

        data(:,1) = simData(:,iRec,4);
        [recData(iRec,1:2,4), ~, ~] = fitting_fminsearch_model_04(data, paramSimple, sweepR);        

        data(:,1) = simData(:,iRec,5);
        [recData(iRec,:,5), ~, ~]   = fitting_fminsearch_model_05(data, param, sweepR);
    end

    %% Plot the results
    dataName = {'Data: Original','Data: Constructed Profiles','Data: Two Factors','Data: Fashion','Data: IPIP'};
    cPall = [53 101 161; 230 91 153; 255 166 0]./255; colAlpha = .3;
    %%  Alpha
    
    figure(fh1.Number);
    for iMod = 1:5
        subplot(5,5,iMod + (iExp-1)*5); hold on
        
        if iExp == 1 || iExp == 3 || iExp == 4
            if iMod == 5
                p = patch([0 1 1 0], [0 0 1 1],'k');
                p.FaceColor = [.466 .674 .188];
                p.FaceAlpha = colAlpha;
                p.EdgeColor = [.466 .674 .188];
                p.EdgeAlpha = colAlpha;
            end
        elseif iExp == 2
            if iMod == 3
                p = patch([0 1 1 0], [0 0 1 1],'k');
                p.FaceColor = [.466 .674 .188];
                p.FaceAlpha = colAlpha;
                p.EdgeColor = [.466 .674 .188];
                p.EdgeAlpha = colAlpha;
            end
        elseif iExp == 5
            if iMod == 4
                p = patch([0 1 1 0], [0 0 1 1],'k');
                p.FaceColor = [.466 .674 .188];
                p.FaceAlpha = colAlpha;
                p.EdgeColor = [.466 .674 .188];
                p.EdgeAlpha = colAlpha;
            end
        end
        
        if iMod == 1
            col = cPall(1,:);
        elseif iMod == 2 || iMod == 3
            col = cPall(2,:);
        else
            col = cPall(3,:);
        end
        s = scatter(parameters(:,1), recData(:,1,iMod),'filled');
        s.CData = col;
        title(['Model: ' num2str(iMod) ' || r: ' num2str(corr(parameters(:,1), recData(:,1,iMod)))])
        text(.7,.1, ['\rho: ' num2str(corr(parameters(:,1), recData(:,1,iMod)))]);
        xlabel('Simulated \alpha')
        ylabel('Fit \alpha')

        xlim([0 1]); ylim([0 1])
        xticks([0 1]); yticks(1);
        text(.5,.1, ['\rho: ' num2str(round(corr(parameters(:,1), recData(:,1,iMod)),2))],'FontWeight','bold','FontSize',14);
    end
    suptitle('Alpha')

    %% Start Value
    figure(fh2.Number);
    for iMod = 1:5
        subplot(5,5,iMod + (iExp-1)*5); hold on

        if iExp == 1 || iExp == 3 || iExp == 4
            if iMod == 5
                p = patch([0 scale scale 0], [0 0 scale scale],'k');
                p.FaceColor = [.466 .674 .188];
                p.FaceAlpha = colAlpha;
                p.EdgeColor = [.466 .674 .188];
                p.EdgeAlpha = colAlpha;
            end
        elseif iExp == 2
            if iMod == 3
                p = patch([0 scale scale 0], [0 0 scale scale],'k');
                p.FaceColor = [.466 .674 .188];
                p.FaceAlpha = colAlpha;
                p.EdgeColor = [.466 .674 .188];
                p.EdgeAlpha = colAlpha;
            end
        elseif iExp == 5
            if iMod == 4
                p = patch([0 scale scale 0], [0 0 scale scale],'k');
                p.FaceColor = [.466 .674 .188];
                p.FaceAlpha = colAlpha;
                p.EdgeColor = [.466 .674 .188];
                p.EdgeAlpha = colAlpha;
            end
        end
        if iMod == 1
            col = cPall(1,:);
        elseif iMod == 2 || iMod == 3
            col = cPall(2,:);
        else
            col = cPall(3,:);
        end
        
        
        if iMod == 1 || iMod == 2 || iMod == 4
            s = scatter(parameters(:,3), recData(:,2,iMod),'filled');
            r = corr(parameters(:,3), recData(:,2,iMod));
        else
            s = scatter(parameters(:,3), recData(:,3,iMod),'filled');
            r = corr(parameters(:,3), recData(:,3,iMod));
        end
        text(scale*.5,scale*.1, ['\rho: ' num2str(round(r,2))],'FontWeight','bold','FontSize',14);
        s.CData = col;
        
        xlim([0 scale]); ylim([0 scale]); xticks([0 scale]); yticks(scale);
    end
    
    %% Gamma
    figure(fh3.Number);
    cnt = 1;
    
    for iModComp = [3,5]
        if iModComp == 3
            subplot(2,5,subCnt(1)); hold on
            col = cPall(2,:);
        else
            subplot(2,5,subCnt(2)); hold on
            col = cPall(3,:);
        end
        
        if iExp == 1 || iExp == 3 || iExp == 4 || iExp == 5
            if iModComp == 5
                p = patch([0 1 1 0], [0 0 1 1],'k');
                p.FaceColor = [.466 .674 .188];
                p.FaceAlpha = colAlpha;
                p.EdgeColor = [.466 .674 .188];
                p.EdgeAlpha = colAlpha;
            end
        elseif iExp == 2
            if iModComp == 3
                p = patch([0 1 1 0], [0 0 1 1],'k');
                p.FaceColor = [.466 .674 .188];
                p.FaceAlpha = colAlpha;
                p.EdgeColor = [.466 .674 .188];
                p.EdgeAlpha = colAlpha;
            end
        end

        s = scatter(parameters(:,2), recData(:,2,iModComp),'filled');
        s.CData = col;
        title(['Model: ' num2str(iModComp) ' || r: ' num2str(corr(parameters(:,2), recData(:,2,iModComp)))])
        xlim([0 1]); ylim([0 1]); xticks([0 1]); yticks(1);
        xlabel([]); ylabel([])
        text(.5,.1, ['\rho: ' num2str(round(corr(parameters(:,2), recData(:,2,iModComp)),2))],'FontWeight','bold','FontSize',14);
        cnt = cnt + 1;
    end
    subCnt = subCnt + 1;
    
end
