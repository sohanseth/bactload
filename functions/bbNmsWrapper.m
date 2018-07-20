function [count, bbs] = bbNmsWrapper(probMap, boxWidth, thresh)

addpath(genpath('~/Desktop/matlabToolbox/toolbox-master/'))
[I, J] = find(probMap > thresh); probMapLocs = [I, J];
% location where bounding box is out of image range is excluded
% [~, ~, probMapLocs] = extractBoxesSTFast(probMap, [], [I, J], boxWidth);
% probMapLocs(length(I)+1:end, :) = [];
bbs = ...
    bbNms([probMapLocs(:, 1), probMapLocs(:, 2), ...
    boxWidth * ones(size(probMapLocs, 1), 2), ...
    probMap(sub2ind(size(probMap), probMapLocs(:, 1), probMapLocs(:, 2)))]);
count = size(bbs, 1);
bbs = bbs(:, 1:2);