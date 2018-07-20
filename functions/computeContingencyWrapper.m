function contingencyTable = computeContingencyWrapper(groundTruth, estAnnot, probMap, d)
% COMPUTECONTINGENCYWRAPPER is a wrapper for computeContingency
% CONTINGENCYTABLE = COMPUTECONTINGENCYWRAPPER(GROUNDTRUTH, ESTANNOT,
%   PROBMAP, D) returns the contingency table CONTINGENCYTABLE given the
%   2D locations of the ground truth annotations in vector GROUNDTRUTH,
%   the 2D locations of the estimated annotations in vector ESTANNOT, and
%   the the probability values at each pixel of the image in the matrix
%   PROBMAP. The function optionally takes the radius D (default 3) around
%   detection for matching with a ground truth.
%
% Example: computeContingencyWrapper(annotationList{I}(:, [2 1]), bbs{1} + 4, imgseqprob{1})

if nargout == 3
    d = 4;
end

groundTruth = round(groundTruth);
estAnnot = round(estAnnot);
if nargin == 3
    probValues = probMap(sub2ind(size(probMap), groundTruth(:, 1), groundTruth(:, 2)));
    groundTruth(isnan(probValues), :) = [];
end

matchIndices = pdist2(estAnnot, groundTruth, 'euclidean') < d; 
contingencyTable = computeContingency(matchIndices);