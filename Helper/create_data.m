% Create data for simulations based on properties that are known
function [data, sweepR] = create_data(x)
%% Settings
nFactor = x.nFactor;
ansScal = x.ansScal;
nItems  = x.nItems;
nProfil = x.nProfil;
totProf = x.totProf;
nData   = x.nData;
noiLvl  = x.noiLvl;

nTrial  = nFactor*nItems;
blFact  = randi(ansScal + [1 -1], 1, nFactor);

%% Create Individual Profile Factor ratings (small deviations)
prof = repmat(blFact,nProfil,1) + 2*rand(nProfil,nFactor)-1;

% Create more trials and add noise
profs = repelem(prof,1,nItems) + randn(nProfil, nTrial)*noiLvl;

% Make sure it stays within the answer scale
profs(profs < ansScal(1)) = ansScal(1); profs(profs > ansScal(2)) = ansScal(2);

%% Create the summary data sweepR & RP
sweepR = corr(profs);
RP     = mean(profs,1)';
% figure; imagesc(sweepR); title('sweepR')%hold on; plot(RP, 'k')

%% Create full sets with multiple profiles and other info the models require
data = cell(nData,2);
for iDat = 1:nData
    randProf = randperm(nProfil);
    [dataBoth, dataProf] = deal(zeros(nTrial*totProf, 7));
    addIdx = 1:nTrial:(totProf+1)*nFactor*nItems;
    for iAdd = 1:totProf
        % Outcome other, Self Ratings, Profile Number, Resets, RP (mean), Input
        % Item Number, Random Order (for optProf only)
        optBoth = [profs(randProf(iAdd),:)', profs(randProf(end-iAdd),:)', ones(nTrial,1)*iAdd, ...
            repmat([1; zeros(nItems-1,1)],nFactor,1), RP, (1:nTrial)', randperm(nTrial)'];
        optProf = sortrows(optBoth,7);

        dataBoth(addIdx(iAdd):addIdx(iAdd+1)-1,2:8) = optBoth;
        dataProf(addIdx(iAdd):addIdx(iAdd+1)-1,2:8) = optProf;
    end
    data{iDat,1} = dataBoth;
    data{iDat,2} = dataProf;
end

