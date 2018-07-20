% This script trains a radial basis function classifier on each 
% cross-valiadation fold. It assumes that the training data (X and Y) are 
% stored in ../data/imageList_multires_XY.mat along with cross-validation 
% splits CVIndices. It stores the centers of the radial basis functions in 
% ../data/imageList_multires_kmeans_#.mat as centersPos and centersNeg, and
% the corresponding  weights (hyp{1}) and width of the kernel (sigma) in 
% ../data/imageList_multires_kmeans_LRR_#.mat along with predictions on the
% validation image patches YPred.

flagSave = true;
imageListFile = '../data/imageList';
nCenter = 16; % number of centers for RBF

%% Find representative vectors in positive and negative set using k-means
load(sprintf('%s_multires_XY', imageListFile), 'X', 'Y', 'CVIndices')

for countCV = 1:5 %
    if exist(sprintf('%s_multires_kmeans_%d.mat', imageListFile, countCV), 'file')
        fprintf('file exists!');
        continue
    end
    fprintf('%d\n', countCV)
    
    X_ = X(CVIndices{countCV}.train, :);
    Y_ = Y(CVIndices{countCV}.train);
    [idxPos{countCV}, centersPosNotSorted{countCV}] = fkmeans(X_(Y_ == 1, :), nCenter);
    % [idxNeg{countCV}, centersNegNotSorted{countCV}] = fkmeans(X_(Y_ == 0, :), 3 * nCenter);
    X_(Y_ == 1, :) = []; % for saving space
    [idxNeg{countCV}, centersNegNotSorted{countCV}] = fkmeans(X_, 3 * nCenter);
    
    idxPosOrdered{countCV} = myunique(idxPos{countCV});
    idxNegOrdered{countCV} = myunique(idxNeg{countCV});   
    
    % centersPos and centersNeg are sorted in terms of cluster size
    centersPos{countCV} = centersPosNotSorted{countCV}(idxPosOrdered{countCV}(end:-1:1, 1), :);
    centersNeg{countCV} = centersNegNotSorted{countCV}(idxNegOrdered{countCV}(end:-1:1, 1), :);

    if flagSave
        save(sprintf('%s_multires_kmeans_%d', imageListFile, countCV), 'idxPos', 'idxNeg', 'centersPos', 'centersNeg', 'centersPosNotSorted', 'centersNegNotSorted')
    end
end
fprintf('k-means done!\n');

%% Run parameters of radial basis function networks, and store performance
for countCV = 1:5
    if exist(sprintf('%s_multires_kmeans_LRR_%d.mat', imageListFile, countCV), 'file')
        fprintf('Regression output file exists.\n')
        continue
    end
    if ~exist('X', 'var')
        load(sprintf('%s_multires_XY', imageListFile), 'X', 'Y', 'CVIndices')
    end
    load(sprintf('%s_multires_kmeans_%d', imageListFile, countCV), 'centersPos', 'centersNeg')
    
    centers = [centersPos{countCV}; centersNeg{countCV}];
    D = pdist2(X, centers);
    
    DCenters = squareform(pdist(centers));
    sigma = median(DCenters(:));
    XTrain = exp(-D(CVIndices{countCV}.train, :).^2 / sigma^2);
    XTest = exp(-D(CVIndices{countCV}.test, :).^2 / sigma^2);
    YTrain = Y(CVIndices{countCV}.train);
    [XTrain, YTrain] = createBalance(XTrain, YTrain);
    
    [YPred(CVIndices{countCV}.test, 1), hyp{countCV}] = LRRWrapper(XTrain, YTrain, XTest);
    [FPR{countCV}, TPR{countCV}, AUC{countCV}] = computeROC(Y(CVIndices{countCV}.test), YPred(CVIndices{countCV}.test), 0:0.01:1);
    
    if flagSave
        save(sprintf('%s_multires_kmeans_LRR_%d', imageListFile, countCV), 'YPred', 'hyp', 'CVIndices', 'FPR', 'TPR', 'AUC', 'centers', 'sigma')
    end
end