rng(4)
matchIndices = rand(200, 100) > 0.99;
[contingencyTable, matchIndicesSorted, noTruthIndices, noDetectionIndices, ...
    singleTruthSingleDetection, singleTruthMultipleDetections, singleDetectionMultipleTruths, ...
    multipleTruthsMultipleDetections] = computeContingency(matchIndices);

%%
sum(contingencyTable(:, 2))
sum(contingencyTable(2, :))

%%
sum(matchIndices(noTruthIndices, :), 2) % zero vector due to no matches
sum(matchIndices(:, noDetectionIndices), 1) % zero vector due to no matches

matchIndices(singleTruthSingleDetection(:, 1), singleTruthSingleDetection(:, 2)) % Identity matrix due to exclusive matches

matchIndices(singleTruthMultipleDetections(:, 1), unique(singleTruthMultipleDetections(:, 2))) % Each row has one 1

matchIndices(unique(singleDetectionMultipleTruths(:, 1)), singleDetectionMultipleTruths(:, 2)) % Each column has one 1

matchIndices(unique(multipleTruthsMultipleDetections(:, 1)), unique(multipleTruthsMultipleDetections(:, 2))); % arbitrary

%%
truePositives = singleTruthSingleDetection(:, 1);
falsePositives = noTruthIndices;
falseNegatives = noDetectionIndices;

[u, i] = unique(singleTruthMultipleDetections(:, 2)); % location of unique in i
truePositives = [truePositives; singleTruthMultipleDetections(i, 1)];
singleTruthMultipleDetections(i, :) = [];
falsePositives = [falsePositives; singleTruthMultipleDetections(:, 1)];

[u, i] = unique(singleDetectionMultipleTruths(:, 1)); % location of unique in i
truePositives = [truePositives; singleDetectionMultipleTruths(i, 1)];
singleDetectionMultipleTruths(i, :) = [];
falseNegatives = [falseNegatives; singleDetectionMultipleTruths(:, 2)];