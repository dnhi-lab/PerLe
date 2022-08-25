function Yticklab = BIC_fixed_plot_v5(bicF)
% figure
nn = size( bicF, 2);
bicF_rev = zeros(1,nn);
for ii = 1:nn
    bicF_rev(1,ii) = bicF(1,nn+1-ii);
end

bicF_rev = bicF_rev - max(bicF_rev);

cPall = [53 101 161; 230 91 153; 255 166 0]./255;
cPallSTE = [27 54 87; 174 56 109; 188 129 18]./255;

b = barh( bicF_rev, 'k' );
b.FaceColor = 'flat';

if length(bicF) == 5
    b.CData(5,:)   = cPall(1,:);
    b.CData(3:4,:) = repmat(cPall(2,:),2,1);
    b.CData(1:2,:) = repmat(cPall(3,:),2,1);
    Yticklab = {'Fine G. & Pop RP','Fine G.','Coarse G. & Pop RP', ...
        'Coarse G.', 'Regression Pop RP'};
else
    b.CData(8,:) = cPall(1,:);
    b.CData(7,:) = cPallSTE(1,:);

    b.CData(5:6,:) = repmat(cPall(2,:),2,1);
    b.CData(4,:)   = cPallSTE(2,:);

    b.CData(2:3,:) = repmat(cPall(3,:),2,1);
    b.CData(1,:)   = cPallSTE(3,:);
    Yticklab = {'Fine G. & STE RP','Fine G. & Pop RP','Fine G.','Coarse G. & STE RP','Coarse G. & Pop RP', ...
        'Coarse G.', 'Regression STE RP', 'Regression Pop RP'};
end
% xticks(round(linspace(min(bicF)-max(bicF),0,5)))
