function [FPRList, TPRList, AUC, thresholdList] = computeROC(trueLabel, values, thresholdList)

% The function computes the FPR and TPR values given a set of true labels
% and output of a classifier (does not need to be probability values). The
% threshold values are by default placed at the output of classifier.
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

if nargin == 2
    thresholdList = sort(values');
end

FPRList = zeros(length(thresholdList), 1);
TPRList = zeros(length(thresholdList), 1);
for threshold = thresholdList
    [FPRList(threshold == thresholdList), ...
        TPRList(threshold == thresholdList)] = ...
        computeFPRTPR(trueLabel, values >= threshold);
end
thresholdList = thresholdList(:);

[FPRUnique, FPRIndex] = unique(FPRList); TPRUnique = TPRList(FPRIndex); thresholdList = thresholdList(FPRIndex);
FPRList = FPRUnique; TPRList = TPRUnique;
AUC = sum(diff(FPRUnique) .* (TPRUnique(1:end-1) + TPRUnique(2:end)) * 0.5);

function [FPR, TPR] = computeFPRTPR(trueLabel, estimatedLabel)

TP = sum(estimatedLabel .* trueLabel);
TPR = TP / sum(trueLabel);
FP = sum(estimatedLabel .* (1 - trueLabel));
FPR = FP / sum(1 - trueLabel);