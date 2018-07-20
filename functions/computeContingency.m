function [contingencyTable, matchIndicesSorted, noTruthIndices, noDetectionIndices, ...
    singleTruthSingleDetection, singleTruthMultipleDetections, singleDetectionMultipleTruths, ...
    multipleTruthsMultipleDetections] = computeContingency(matchIndices)
% COMPUTECONTINGENCY computes the contingency table given a matrix of matches
% CONTINGENCYTABLE = COMPUTECONTINGENCY(MATCHINDICES) returns a contingency table 
%               Obj Present?  no | yes
%            Detected? 
%               no            TN   FN
%               yes           FP   TP
%   given a binary matrix of |Detected| x |Present| where a detection can 
%   match to multiple ground truths and vice versa.
%
%   The function optionally returns
%       matchIndicesSorted: Sorted matchIndices with respect to different types of detections
%       noTruthIndices: Indices of detections without ground truth
%       noDetectionIndices: Indices of ground truths without detections
%       singleTruthSingleDetection: Pairs of indices of exclusive (one-to-one) matches
%       singleTruthMultipleDetections: Pairs of indices of nonexclusive ground truths shared by many detections
%       singleDetectionMultipleTruths: Pairs of indices of nonexclusive detections shared by many ground truths
%       multipleTruthsMultipleDetections: Pairs of nonexclusive ground truths and detections
%
%   See ../tests/testComputeContingency.m
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk
%
% nMatchesPerDetection = sum(matchIndices, 2);
% tmp = sortrows([nMatchesPerDetection, matchIndices]);
% matchIndices = tmp(:, 2:end);
% nMatchesPerTruth = sum(matchIndices);
% tmp = sortrows([nMatchesPerTruth; matchIndices]');
% matchIndices = tmp(:, 2:end)';

% find all matches
[rowIndices, colIndices] = find(matchIndices);
if isempty(rowIndices) & isempty(colIndices); 
    contingencyTable(1, 1) = NaN;
    contingencyTable(1, 2) = size(matchIndices, 2);
    contingencyTable(2, 1) = size(matchIndices, 1);
    contingencyTable(2, 2) = 0;
    return
end

nMatchesPerTruth = sum(matchIndices);
nMatchesPerDetection = sum(matchIndices, 2);

% No truth
noTruthIndices = find(nMatchesPerDetection == 0);
% Unique detections
noDetectionIndices = find(nMatchesPerTruth == 0);
%
detectionWSingleTruth = find(nMatchesPerDetection == 1)'; 
detectionWMultipleTruth = find(nMatchesPerDetection > 1)'; 
truthWSingleDetection = find(nMatchesPerTruth == 1);
truthWMultipleDetection = find(nMatchesPerTruth > 1);

% Unique matches
ind = any(bsxfun(@eq, rowIndices, detectionWSingleTruth), 2) & any(bsxfun(@eq, colIndices, truthWSingleDetection), 2);
singleTruthSingleDetection = sortrows([rowIndices(ind), colIndices(ind)]);
if isempty(singleTruthSingleDetection)
    singleTruthSingleDetection = zeros(0, 2);
end

% Single truth multiple detection
ind = any(bsxfun(@eq, rowIndices, detectionWSingleTruth), 2) & any(bsxfun(@eq, colIndices, truthWMultipleDetection), 2);
singleTruthMultipleDetections = sortrows([rowIndices(ind), colIndices(ind)]);

if ~isempty(singleTruthMultipleDetections)
    tmp = myunique(singleTruthMultipleDetections(:, 2)); % tmp = tmp(tmp(:, 2) == 1, 1);
    tmp(nMatchesPerTruth(tmp(:, 1))' == tmp(:, 2), :) = []; tmp = tmp(:, 1);
    singleTruthMultipleDetections(any(bsxfun(@eq, singleTruthMultipleDetections(:, 2), tmp'), 2), :) = [];
    singleTruthMultipleDetections = sortrows(singleTruthMultipleDetections, 2);
else
    singleTruthMultipleDetections = zeros(0, 2);
end

% Multiple truth single detection
ind = any(bsxfun(@eq, rowIndices, detectionWMultipleTruth), 2) & any(bsxfun(@eq, colIndices, truthWSingleDetection), 2);
singleDetectionMultipleTruths = sortrows([rowIndices(ind), colIndices(ind)]);

if ~isempty(singleDetectionMultipleTruths)
    tmp = myunique(singleDetectionMultipleTruths(:, 1)); % tmp = tmp(tmp(:, 2) == 1, 1);
    tmp(nMatchesPerDetection(tmp(:, 1)) == tmp(:, 2), :) = []; tmp = tmp(:, 1);
    singleDetectionMultipleTruths(any(bsxfun(@eq, singleDetectionMultipleTruths(:, 1), tmp'), 2), :) = [];
    singleDetectionMultipleTruths = sortrows(singleDetectionMultipleTruths);
else
    singleDetectionMultipleTruths = zeros(0, 2);
end

% Multiple matches
restOfDetections = setdiff(1:size(matchIndices, 1), unique([noTruthIndices; singleTruthSingleDetection(:, 1); singleTruthMultipleDetections(:, 1); singleDetectionMultipleTruths(:, 1)]));
restOfTruths = setdiff(1:size(matchIndices, 2), unique([noDetectionIndices(:); singleTruthSingleDetection(:, 2); singleTruthMultipleDetections(:, 2); singleDetectionMultipleTruths(:, 2)]));

ind = any(bsxfun(@eq, rowIndices, restOfDetections), 2) & any(bsxfun(@eq, colIndices, restOfTruths), 2);
multipleTruthsMultipleDetections = sortrows([rowIndices(ind), colIndices(ind)]);

% Assign detection to truth
matches = zeros(0, 2); noTruth = zeros(0, 2); noDetection = zeros(0, 2);
if ~isempty(multipleTruthsMultipleDetections)
    [matches, noTruth, noDetection] = greedyAssignment(multipleTruthsMultipleDetections);
else
    matches = zeros(0, 2); noTruth = zeros(0, 2); noDetection = zeros(0, 2); multipleTruthsMultipleDetections = zeros(0, 2);
end

% sorted matrix
matchIndicesSorted = matchIndices(...
    [noTruthIndices; singleTruthSingleDetection(:, 1); singleTruthMultipleDetections(:, 1); uniqueWOsort(singleDetectionMultipleTruths(:, 1)); unique(multipleTruthsMultipleDetections(:, 1))], ...
    [noDetectionIndices(:); singleTruthSingleDetection(:, 2); uniqueWOsort(singleTruthMultipleDetections(:, 2)); singleDetectionMultipleTruths(:, 2); unique(multipleTruthsMultipleDetections(:, 2))]);

falseNegatives = length(noDetectionIndices) + ...
    (size(singleDetectionMultipleTruths, 1) - ...
    length(unique(singleDetectionMultipleTruths(:, 1)))) + ...
    length(noDetection);
truePositives = size(singleTruthSingleDetection, 1) + ...
    length(unique(singleDetectionMultipleTruths(:, 1))) + ...
    length(unique(singleTruthMultipleDetections(:, 2))) + ...
    size(matches, 1);
falsePositives = length(noTruthIndices) + ...
    (size(singleTruthMultipleDetections, 1) - ...
    length(unique(singleTruthMultipleDetections(:, 2)))) + ...
    length(noTruth);

contingencyTable(1, 1) = NaN;
contingencyTable(1, 2) = falseNegatives;
contingencyTable(2, 1) = falsePositives;
contingencyTable(2, 2) = truePositives;

% Greedy assignment of multiple truths multiple detections
function [matches, noTruth, noDetection] = greedyAssignment(mTmD)
matches = []; noTruth = []; noDetection = [];
detectionList = unique(mTmD(:, 1));
for count = 1:length(detectionList)
    detection = detectionList(count);
    if isnan(detection); continue; end
    tmp = mTmD(mTmD(:, 1) == detection, 2); truth = tmp(1);
    if ~isnan(truth)
        matches = [matches; [detection, truth]];
    else
        noTruth = [noTruth; detection];
    end
    mTmD(mTmD(:, 1) == detection, 1) = NaN;
    mTmD(mTmD(:, 2) == truth, 2) = NaN;
end
noDetection = mTmD(:, 2); noDetection(isnan(noDetection)) = []; noDetection = unique(noDetection);

function vector = uniqueWOsort(vector)
if isempty(vector); return; end
vector = vector(logical([1; diff(vector) ~= 0]));