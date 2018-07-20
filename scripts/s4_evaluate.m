% This script apply the learned radial basis function on validation images.
% It assumes that the images are stored in ../data/imageList.m and the 
% radial basis functions centers and corresponding weights are stored in
% ../data/imageList_multires_kmeans_#.mat and ../data/imageList_multires_kmeans_LRR_#.mat
% respectively. It stores the probability map for each validation image in
% a cell array imgseqprob, the locations of objects for different thresholds 
% in a cell array bbs, and the respective objective counts in a cell array
% bactCount. It also builds a contingency table for each validation and threshold.

flagSave = true;
imageListFile = '../data/imageList';
addpath('~/Desktop/localDirectory/matlabToolbox/toolbox-master/matlab/')

%%
if ~exist('imageList', 'var'); load ../data/imageList; end
load(sprintf('%s_multires.mat', imageListFile), 'boxWidthList')
load ../data/annotationList.mat

rng default
CVIndices = generateCVIndices(max(patientList), 5);
for count = 1:5
    CVIndices{count}.train = any(bsxfun(@eq, patientList, find(CVIndices{count}.train)), 2);
    CVIndices{count}.test = any(bsxfun(@eq, patientList, find(CVIndices{count}.test)), 2);
end
CVIndicesFrame = CVIndices;

threshList = [0.7 0.8 0.9 0.95 0.99 0.999 0.9999 0.99999 0.999999 0.9999999 0.99999999 0.999999999];
for countCV = 1:5
    for countFrame = 1:length(patientList)
        fprintf('[%d]\n', countFrame)
        if CVIndicesFrame{countCV}.test(countFrame)
            load(sprintf('%s_multires_kmeans_LRR_%d', imageListFile, countCV));
            load(sprintf('%s_multires_kmeans_%d', imageListFile, countCV))
            
            centers = [centersPos{countCV}; centersNeg{countCV}];
            for countCent = 1:size(centers, 1)
                % centersList{countCent} = reshape(squeeze(mat2cell(reshape(centers(countCent, :), 9, 9, 9), 9, 9, ones(1, 9))), 3, 3)';
                centersList{countCent} = vec2patch(centers(countCent, :), boxWidthList, true);
            end
            
            if size(centersList{1}, 2) == 1 % using only current window
                distances = computeDistances(double(imageList{countFrame}(:, :, ceil(end/2))), centersList, boxWidthList);
            else
                distances = computeDistances(double(imageList{countFrame}), centersList, boxWidthList);
            end
            imgseqprob{countFrame} = 1 ./ (1 + exp(- sum(bsxfun(@times, exp(-distances.^2 / sigma^2), reshape(hyp{countCV}.w, 1, 1, length(hyp{countCV}.w)) ), 3) - hyp{countCV}.b));
            
            for thresh = threshList
                [bactCount(countFrame, thresh == threshList), bbs{countFrame, thresh == threshList}] = ...
                    bbNmsWrapper(imgseqprob{countFrame}, 9, thresh);
                if isempty(annotationList{countFrame}); annotationList{countFrame} = zeros(0, 2); end
                contingency(:, :, countFrame, thresh == threshList) = ...
                    computeContingencyWrapper(annotationList{countFrame}(:, [2 1]), bbs{countFrame, thresh == threshList}, imgseqprob{countFrame}, 8); % + 4 removed from bbs
            end
        end
    end
    if flagSave
        save(sprintf('%s_multires_kmeans_LRR_ip_%d', imageListFile, countCV), 'imgseqprob', 'bbs', 'bactCount', 'contingency', 'threshList', '-v7.3')
    end
end
% 