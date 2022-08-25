function [pEst, bicMatrix, saveFit, getOptPE] = fitAll(dataSort, numPar, numModels, ~, sweepR)
global getFit startVal modUse selfUse %getOpt
% modUse = '';

param       = [0.5 0.5 4.5];
paramSimple = [0.5 4.5];
% Added to get the free RP's
if strcmp(modUse, 'posneg')
    param       = [0.5 0.5 4.5 0.5];
    paramSimple = [0.5 4.5 0.5];
end

% If startVal is set that should be used instead of a fitted parameter
if startVal ~= 0
    param(3)       = [];
    paramSimple(2) = [];
end

saveFit = cell(numPar,numModels);
pEst      = struct(repmat(struct('model', {cell(1,numPar)}),numModels,1));
bicMatrix = zeros(numPar, numModels);

getOptPE = cell(numModels,numPar);

for iPar = 1:numPar
    % All regular models use both sorts and both deletes
    % The sweep models use profile sort and both deletes
    if numModels == 5
        if selfUse
            data = dataSort.delBothSortBoth{iPar};
            dataMean = data;
            dataSweep = dataSort.delBothSortProf{iPar};
            dataSweepMean = dataSweep;
        else
            data = dataSort.delBothSortBoth{iPar};
            dataMean = data;
            dataMean(:,3) = data(:,6);
            dataSweep = dataSort.delBothSortProf{iPar};

            dataSweepMean = dataSweep;
            dataSweepMean(:,3) = dataSweepMean(:,6);
        end
        % 5 Models
        [pEst(1).model{iPar}, ~, bicMatrix(iPar,1)] = fitting_fminsearch_model_01(dataMean, paramSimple);
        saveFit{iPar,1} = getFit;

        [pEst(2).model{iPar}, ~, bicMatrix(iPar,2)] = fitting_fminsearch_model_02(data, paramSimple);
        saveFit{iPar,2} = getFit;

        [pEst(3).model{iPar}, ~, bicMatrix(iPar,3)] = fitting_fminsearch_model_03(dataMean, param);
        saveFit{iPar,3} = getFit;

        [pEst(4).model{iPar}, ~, bicMatrix(iPar,4)] = fitting_fminsearch_model_04(dataSweep, paramSimple, sweepR);
        saveFit{iPar,4} = getFit;

        [pEst(5).model{iPar}, ~, bicMatrix(iPar,5)] = fitting_fminsearch_model_05(dataSweepMean, param, sweepR);
        saveFit{iPar,5} = getFit;

    elseif numModels == 8
        if selfUse
            data = dataSort.delBothSortBoth{iPar};
            dataMean = data;
            dataSweep = dataSort.delBothSortProf{iPar};
            dataSweepMean = dataSweep;
        else
            data = dataSort.delBothSortBoth{iPar};
            dataMean = data;
            dataMean(:,3) = data(:,6);
            dataSweep = dataSort.delBothSortProf{iPar};

            dataSweepMean = dataSweep;
            dataSweepMean(:,3) = dataSweepMean(:,6);
        end
        
        dataSte = data;
        dataSte(:,3) = data(:,9);

        dataSweepSte = dataSweep;
        dataSweepSte(:,3) = dataSweepSte(:,9);

        [pEst(1).model{iPar}, ~, bicMatrix(iPar,1)] = fitting_fminsearch_model_01(dataMean, paramSimple);
        saveFit{iPar,1} = getFit;
        [pEst(2).model{iPar}, ~, bicMatrix(iPar,2)] = fitting_fminsearch_model_01(dataSte, paramSimple);
        saveFit{iPar,2} = getFit;

        [pEst(3).model{iPar}, ~, bicMatrix(iPar,3)] = fitting_fminsearch_model_02(data, paramSimple);
        saveFit{iPar,3} = getFit;
        [pEst(4).model{iPar}, ~, bicMatrix(iPar,4)] = fitting_fminsearch_model_03(dataMean, param);
        saveFit{iPar,4} = getFit;
        [pEst(5).model{iPar}, ~, bicMatrix(iPar,5)] = fitting_fminsearch_model_03(dataSte, param);
        saveFit{iPar,5} = getFit;

        [pEst(6).model{iPar}, ~, bicMatrix(iPar,6)] = fitting_fminsearch_model_04(dataSweep, paramSimple, sweepR);
        saveFit{iPar,6} = getFit;
        [pEst(7).model{iPar}, ~, bicMatrix(iPar,7)] = fitting_fminsearch_model_05(dataSweepMean, param, sweepR);
        saveFit{iPar,7} = getFit;
        [pEst(8).model{iPar}, ~, bicMatrix(iPar,8)] = fitting_fminsearch_model_05(dataSweepSte, param, sweepR);
        saveFit{iPar,8} = getFit;
    else
        error('Wrong amount of models specified')
    end
end % End iPar