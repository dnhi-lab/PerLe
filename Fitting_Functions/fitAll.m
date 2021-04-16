function [pEst, bicMatrix, saveFit, extFl] = fitAll(dataSort, numPar, numModels, inp, sweepR)
global getFit modUse startVal

% Pos/Neg & Decay models use an extra parameter
if strcmp(modUse, 'posneg')
    param       = [0.5 0.5 4.5 0.5];
    paramSimple = [0.5 4.5 0.5];
else
    param       = [0.5 0.5 4.5];
    paramSimple = [0.5 4.5];
end
% If startVal is set that should be used instead of a fitted parameter
if startVal ~= 0
    param(3)       = [];
    paramSimple(2) = [];
end

if inp == 4; load('Data\sweepFash', 'fashSimil'); sweepR = fashSimil; numModels = 8; end
saveFit = cell(numPar,numModels);

pEst      = struct(repmat(struct('model', {cell(1,numPar)}),numModels,1));
bicMatrix = zeros(numPar, numModels);
extFl     = zeros(size(bicMatrix)); % ####### Can be deleted still ########

% load('C:\Users\frolichs\Documents\Koen\Projects\PerLe\misc_code\avgPerson.mat', 'avgPerson')
for iPar = 1:numPar
    % All regular models use both sorts and both deletes
    % The sweep models use profile sort and both deletes
    data = dataSort.delBothSortBoth{iPar};
    dataMean = data;
    dataMean(:,3) = data(:,6);

    dataSweep = dataSort.delBothSortProf{iPar};
    dataSweepMean = dataSweep;
    dataSweepMean(:,3) = dataSweepMean(:,6);

    if inp ~= 4
        [pEst(1).model{iPar}, ~, bicMatrix(iPar,1)] = fitting_fminsearch_pseudolinearregression(dataMean, paramSimple);
        saveFit{iPar,1} = getFit;
        [pEst(2).model{iPar}, ~, bicMatrix(iPar,2)] = fitting_fminsearch_optimalsimplemodel(data, paramSimple);
        saveFit{iPar,2} = getFit;
        [pEst(3).model{iPar}, ~, bicMatrix(iPar,3)] = fitting_fminsearch_rlselfmodel(dataMean, param);
        saveFit{iPar,3} = getFit;
        [pEst(4).model{iPar}, ~, bicMatrix(iPar,4)] = fitting_fminsearch_sweepmodel(dataSweep, paramSimple, sweepR);
        saveFit{iPar,4} = getFit;
        [pEst(5).model{iPar}, ~, bicMatrix(iPar,5)] = fitting_fminsearch_sweepmodelself(dataSweepMean, param, sweepR);
        saveFit{iPar,5} = getFit;
    else % Extra 'Stereotype' models for experiment four
        dataFashMean = data;
        dataFashMean(:,3) = dataFashMean(:,9);
        
        dataFashMeanSw = dataSweep;
        dataFashMeanSw(:,3) = dataFashMeanSw(:,9);
        
        [pEst(1).model{iPar}, ~, bicMatrix(iPar,1)] = fitting_fminsearch_pseudolinearregression(dataMean, paramSimple);
        saveFit{iPar,1} = getFit;
        [pEst(2).model{iPar}, ~, bicMatrix(iPar,2)] = fitting_fminsearch_pseudolinearregression(dataFashMean, paramSimple);
        saveFit{iPar,2} = getFit;
        [pEst(3).model{iPar}, ~, bicMatrix(iPar,3)] = fitting_fminsearch_optimalsimplemodel(data, paramSimple);
        saveFit{iPar,3} = getFit;
        [pEst(4).model{iPar}, ~, bicMatrix(iPar,4)] = fitting_fminsearch_rlselfmodel(dataMean, param);
        saveFit{iPar,4} = getFit;
        [pEst(5).model{iPar}, ~, bicMatrix(iPar,5)] = fitting_fminsearch_rlselfmodel(dataFashMean, param);
        saveFit{iPar,5} = getFit;
        [pEst(6).model{iPar}, ~, bicMatrix(iPar,6)] = fitting_fminsearch_sweepmodel(dataSweep, paramSimple, sweepR);
        saveFit{iPar,6} = getFit;
        [pEst(7).model{iPar}, ~, bicMatrix(iPar,7)] = fitting_fminsearch_sweepmodelself(dataSweepMean, param, sweepR);
        saveFit{iPar,7} = getFit;
        [pEst(8).model{iPar}, ~, bicMatrix(iPar,8)] = fitting_fminsearch_sweepmodelself(dataFashMeanSw, param, sweepR);
        saveFit{iPar,8} = getFit;
    end

end % End iPar