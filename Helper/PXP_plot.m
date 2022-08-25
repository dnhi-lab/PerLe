function [BMS] = PXP_plot(bicE)
[BMS.alpha( 1, :), BMS.exp_r( 1, :), BMS.xp( 1, :), BMS.pxp( 1, :), BMS.bor( 1, :)] = spm_BMS( bicE );
ex1 = BMS.pxp( 1, :);
nn = size( ex1, 2);
ex1_rev = zeros(1,nn);
for ii = 1:nn
    ex1_rev(1,ii) = ex1(1,nn+1-ii);
end

% Color pallete, change these to change bar colors
cPall = [53 101 161; 230 91 153; 255 166 0]./255;

b = barh( ex1_rev, 'k' );
b.FaceColor = 'flat';

if size(bicE,2) == 5
    % 5 models
    b.CData(5,:)   = cPall(1,:);
    b.CData(3:4,:) = repmat(cPall(2,:),2,1);
    b.CData(1:2,:) = repmat(cPall(3,:),2,1);
    yticklabels(fliplr({'No Learning','Coarse Granularity','CG & Pop. RP',...
        'Fine Granularity','FG & Pop. RP'}));
elseif size(bicE,2) == 8
    % 8 models
    b.CData(7:8,:) = repmat(cPall(1,:),2,1);
    b.CData(4:6,:) = repmat(cPall(2,:),3,1);
    b.CData(1:3,:) = repmat(cPall(3,:),3,1);
    yticklabels(fliplr({'No Learning','No Learning STE','Coarse Granularity', ...
        'CG & Pop. RP', 'CG & STE RP','Fine Granularity','FG & Pop. RP','FG & STE. RP'}));
end

xlabel('Protected Exceedance Probability')
xlim([0,1])
set(gca,'XTick', 0:0.5:1)