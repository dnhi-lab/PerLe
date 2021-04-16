function BIC_fixed_plot_v2( bicF, title_tag, plot_sub)

nn = size( bicF, 2);
bicF_rev = zeros(1,nn);
for ii = 1:nn
    bicF_rev(1,ii) = bicF(1,nn+1-ii);
end

bicF_rev = bicF_rev - max(bicF_rev);

if plot_sub
    figure('units','normalized','outerposition',[.1 .1 .5 .5])
    subplot(1,2,1)
else
    figure
end

% Color pallete, change these to change bar colors
cPall = [53 101 161; 230 91 153; 255 166 0]./255;
% Would be cool to use this color #ff6374 as a highlight for the winning model

b = barh( bicF_rev, 'k' );
b.FaceColor = 'flat';

% 5 models
b.CData(5,:)   = cPall(1,:);
b.CData(3:4,:) = repmat(cPall(2,:),2,1);
b.CData(1:2,:) = repmat(cPall(3,:),2,1);

xticks(round(linspace(min(bicF)-max(bicF),0,5)))

title( title_tag )
