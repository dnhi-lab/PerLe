%% Plotting of the confusion matrix
% Input: Confusion Matrix 
% Optional: 'cmap' = 'rwb' for different colormap: red - white - blue
%
% plot_CM(confusion_matrix)
% Plot standard confusion matrix with fit percentages
%
% plot_CM(confusion_matrix, 'cmap', 'rwb')
% Plot confusion matrix with fit percentages and red-white-blue colormap
%
% plot_CM(confusion_matrix, 'title', 'The Title')
% Plot confusion matrix with fit percentages and a title

% Majority of the ideas from the 10 simple rules paper
function plot_CM(CM, varargin)
sz = size(CM);
% Quick check for matrix symmetry
if sz(1) ~= sz(2); error('Expected a symmetrical matrix'); end

% Use imagesc to plot initial values
% figure; clf;
imagesc(CM)


%% Add the percentages to the squares
% CM_per = CM./sum(CM,2);
for iY = 1:sz(1)
    for iX = 1:sz(2)
%         t(iX,iY) = text(iX,iY, num2str(round(CM_per(iY,iX),3)*100)); %#ok<AGROW>
        t(iX,iY) = text(iX,iY, num2str(round(CM(iY,iX),3)*100)); %#ok<AGROW>
        set(t(iX,iY), 'horizontalalignment', 'center', 'verticalalignment', 'middle');
    end
end

%% Draw lines between squares
hold on
for iL = 1:sz(1)
%     plot([0 iL],[0,0], 'k')
    % Horizontal lines
    plot([0, 5.5], [iL+.5, iL+.5], 'k')
    
    % Vertical lines
    plot([iL-0.5, iL-0.5], [0, 5.5], 'k')
end

%% Change some visuals
yticks(1:sz(1)); xticks(1:sz(2))
set(gca, 'xaxislocation', 'top', 'tickdir', 'out')   
xlabel('fit model')
ylabel('simulated model')
title('')

%% Different colormap red - white - blue
% Colors taken from colorbrewer website
rbCP = [103,0,31; 178,24,43; 214,96,77; 244,165,130;
253,219,199; 247,247,247; 209,229,240; 146,197,222;
67,147,195; 33,102,172; 5,48,97]/255;
if nargin > 1
    % If cmap exists as an argument
    if sum(strcmp(varargin, 'cmap'))
        varIdx = find(strcmp(varargin, 'cmap'));
        if nargin - 1 > varIdx
            % And the argument after is 'rwb' change the colormap
            if strcmp(varargin{varIdx + 1}, 'rwb')
                colormap(rbCP)
            end
        end
    end
    % If title exists as an argument
    if sum(strcmp(varargin, 'title'))
        varIdx = find(strcmp(varargin, 'title'));
        if nargin - 1 > varIdx
            title(varargin{varIdx+1})
        end
    end
end