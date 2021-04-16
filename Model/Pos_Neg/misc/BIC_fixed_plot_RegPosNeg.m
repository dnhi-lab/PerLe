function BIC_fixed_plot_RegPosNeg( bicReg, bicPN, figTit, skipRegr)
numModels             = length(bicReg)+length(bicPN); %10;
bicTot                = zeros(1,numModels);
bicTot(1:2:numModels) = bicReg;
bicTot(2:2:numModels) = bicPN;
bicF_rev              = fliplr(bicTot);

bicF_rev = bicF_rev - max(bicF_rev);
figure

% Color palette, change these to change bar colors
cPall = [53 101 161; 230 91 153; 255 166 0]./255;
cPallSTE = [27 54 87; 174 56 109; 188 129 18]./255;

b = barh( bicF_rev, 'k' );
b.FaceColor = 'flat';

% These get turned around because the labels switch
% b.CData(1:2:numModels,:) = repmat(cPallSTE(1,:),numModels/2,1);
% b.CData(2:2:numModels,:) = repmat(cPall(1,:),numModels/2,1);

% 'Original' Colors
if numModels < 10
    b.CData([1 3 5 7],:) = repmat(cPall(1,:), 4, 1); % PosNeg Orange & Pink
    b.CData([2 4],:) = repmat(cPall(3,:), 2, 1); % Orange

    b.CData([6 8],:) = repmat(cPall(2,:), 2, 1); % Pink
else
    b.CData([1 3 5 7 9 11],:) = repmat(cPall(1,:), 6, 1); % PosNeg Orange & Pink
    b.CData(2,:) = cPallSTE(3,:); % STE Orange
    b.CData([4 6],:) = repmat(cPall(3,:), 2, 1); % Orange

    b.CData(8,:) = cPallSTE(2,:); % STE Pink
    b.CData([10 12],:) = repmat(cPall(2,:), 2, 1); % Pink
end

text(min(bicF_rev), numModels,   'Normal Models', 'Color', cPall(1,:))
text(min(bicF_rev), numModels-1, 'Pos/Neg Models','Color', cPallSTE(1,:))

title([figTit ': Reg vs PosNeg'])
yticks(2:2:numModels)
if skipRegr
    if numModels > 10
        yticklabels({'RL (STE & Sim.)', 'RL (Mean & Sim.)', 'RL (Similarity)', 'RL (STE & Fact.)', ...
            'RL (Mean & Fact.)', 'RL (Factors)'})
    else
        yticklabels({'RL (Mean & Sim.)', 'RL (Similarity)', 'RL (Mean & Fact.)', 'RL (Factors)'})
    end
else
    if numModels > 10
        yticklabels({'RL (STE & Sim.)', 'RL (Mean & Sim.)', 'RL (Similarity)', 'RL (STE & Fact.)', ...
            'RL (Mean & Fact.)', 'RL (Factors)', 'No learning (STE)', 'No learning (Mean)'})
    else
        yticklabels({'RL (Mean & Sim.)', 'RL (Similarity)', 'RL (Mean & Fact.)', 'RL (Factors)', 'No learning (Mean)'})
    end
end

xlabel('BIC score')