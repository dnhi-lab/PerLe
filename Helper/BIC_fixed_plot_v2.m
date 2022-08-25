function Yticklab = BIC_fixed_plot_v2(bicF, title_tag, plot_sub, numMod)
figure
nn = size( bicF, 2);
bicF_rev = zeros(1,nn);
for ii = 1:nn
    bicF_rev(1,ii) = bicF(1,nn+1-ii);
end

bicF_rev = bicF_rev - max(bicF_rev);

% if plot_sub
%     figure('units','normalized','outerposition',[.1 .1 .5 .5])
%     subplot(1,2,1)
% else
%     figure
% end

% Color pallete, change these to change bar colors
cPall = [53 101 161; 230 91 153; 255 166 0]./255;
cPallSTE = [27 54 87; 174 56 109; 188 129 18]./255;

b = barh( bicF_rev, 'k' );
b.FaceColor = 'flat';

if numMod == 5
    % 5 models
    b.CData(5,:)   = cPall(1,:);
    b.CData(3:4,:) = repmat(cPall(2,:),2,1);
    b.CData(1:2,:) = repmat(cPall(3,:),2,1);
    Yticklab = {'Fine G. & Pop RP','Fine G.','Coarse G. & Pop RP', ...
        'Coarse G.', 'Regression Pop RP'};

%     b.CData(6,:)   = cPall(1,:);
%     b.CData(4:5,:) = repmat(cPall(2,:),2,1);
%     b.CData([1,3],:) = repmat(cPall(3,:),2,1);
%     b.CData(2,:) = [1,1,1];
%     Yticklab = {'Fine G. & Pop RP','Christoph''s Model','Fine G.','Coarse G. & Pop RP', ...
%         'Coarse G.', 'Regression Pop RP'};
elseif numMod == 8
%     % 8 models
%     b.CData(7:8,:) = repmat(cPall(1,:),2,1);
%     b.CData(4:6,:) = repmat(cPall(2,:),3,1);
%     b.CData(1:3,:) = repmat(cPall(3,:),3,1);
%     Yticklab = {'Fine G. & Pop RP','Fine G. & Self RP','Fine G.', ...
%         'Coarse G. & Pop RP','Coarse G. & Self RP','Coarse G.', ...
%         'Regression Pop RP','Regression Self RP'};
% elseif numMod == 11
%     % 11 models

%     b.CData(9,:) = cPallSTE(1,:);
%     b.CData(10:11,:) = repmat(cPall(1,:),2,1);
%     
%     b.CData(5,:)  = cPallSTE(2,:);
%     b.CData(6:8,:)  = repmat(cPall(2,:),3,1);
%     
%     b.CData(1,:)  = cPallSTE(3,:);
%     b.CData(2:4,:)  = repmat(cPall(3,:),3,1);
    b.CData(8,:) = cPall(1,:);
    b.CData(7,:) = cPallSTE(1,:);

    b.CData(5:6,:) = repmat(cPall(2,:),2,1);
    b.CData(4,:)   = cPallSTE(2,:);

    b.CData(2:3,:) = repmat(cPall(3,:),2,1);
    b.CData(1,:)   = cPallSTE(3,:);
    
    Yticklab = {'Fine G. & STE RP','Fine G. & Pop RP','Fine G.', ...
                'Coarse G. & STE RP','Coarse G. & Pop RP','Coarse G.', ...
                'Regression STE RP','Regression Pop RP'};
    
    %     Yticklab = {'Fine G. & STE RP','Fine G. & Pop RP','Fine G. & Self RP','Fine G.', ...
%         'Coarse G. & STE RP','Coarse G. & Pop RP','Coarse G. & Self RP','Coarse G.', ...
%         'Regression STE RP','Regression Pop RP','Regression Self RP'};
else
    error('Incorrect amount of models specified')
end

xticks(round(linspace(min(bicF)-max(bicF),0,5)))

title( title_tag )
