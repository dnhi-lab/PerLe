function [BMS] = PXP_random_plot_v1( bicE, title_tag, plot_sub) % minus has to be added!

[BMS.alpha( 1, :), BMS.exp_r( 1, :), BMS.xp( 1, :), BMS.pxp( 1, :), BMS.bor( 1, :)] = spm_BMS( bicE );
ex1 = BMS.pxp( 1, :);
nn = size( ex1, 2);
ex1_rev = zeros(1,nn);
for ii = 1:nn
    ex1_rev(1,ii) = ex1(1,nn+1-ii);
end

if plot_sub
    subplot(1,2,2)
else
    figure
end

% Color pallete, change these to change bar colors
cPall = [53 101 161; 230 91 153; 255 166 0]./255;

b = barh( ex1_rev, 'k' );
b.FaceColor = 'flat';
% 5 models
b.CData(5,:)   = cPall(1,:);
b.CData(3:4,:) = repmat(cPall(2,:),2,1);
b.CData(1:2,:) = repmat(cPall(3,:),2,1);

% barh( ex1_rev, 'k' )
xlim([0,1])
set(gca,'XTick', 0:0.5:1)
title( title_tag )