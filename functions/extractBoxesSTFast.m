function [boxSeq, boxSeqLabel, boxLoc] = extractBoxesSTFast(img, imgannot, boxLoc, boxWidthList)
% EXTRACTBOXESSTFAST extracts spatio-temporal image patches from a list of 
%   images and corresponding list of annotations.
%   [BOXSEQ, BOXSEQLABEL, BOXLOC] = EXTRACTBOXESSTFAST(IMG, IMGANNOT)
%   returns a T x V cell array of image patches BOXSEQ, a T x V matrix of 
%   the number of annotations in each image patch BOXSEQLABEL, and a matrix 
%   (T x 2) of centers  of each image patch BOXLOC, given a sequence of 
%   image IMG, and a matrix of annotations IMGANNOT. Image patches are 
%   extracted around the annotations (positive patches), and some random 
%   locations (negative patches). 
%
%   Optional arguments:
%       BOXLOC = M x 2 dimensional matrix of patch centers. If provided,
%           then image patches are extracted around these locations, T = M.
%       BOXWIDTHLIST = A V x 1 vector of patch sizes. Default [9, 27, 45]. 
%           Each patch is downsampled to the size of the minimum patch size.
%
%   See testExtractBoxesSTFast.m
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

imgX = size(img, 1); imgY = size(img, 2); T = size(img, 3);
% If patch locations are not specified, then extracts patches around 
% annotations and additionally at random locations (if unbalance ~= 0)
if nargin == 2 || isempty(boxLoc)
    unbalance = 0; % proportion of positive vs negative frames    
    boxLoc = [imgannot; [randi(imgX, unbalance * size(imgannot, 1), 1), randi(imgY, unbalance * size(imgannot, 1), 1)]];
end

if nargin < 4
    boxWidthList = [9, 27, 45];
end

downsampleList = ceil(boxWidthList / boxWidthList(1));
imageList = cell(length(downsampleList), 1); imageList{1} = img; clear img
for downsample = downsampleList(2:end)
    for countT = 1:size(imageList{1}, 3)
        C = conv2(imageList{1}(:, :, countT), ones(downsample) / downsample^2);
        imageList{downsample == downsampleList}(:, :, countT) = C(floor(downsample/2)+1:end-floor(downsample/2), floor(downsample/2)+1:end-floor(downsample/2));
    end    
end

for boxWidth = boxWidthList
    downsample = downsampleList(boxWidth == boxWidthList);
    pmAroundCenter = (boxWidth - downsample) / 2;    
    pmRowInd{boxWidth == boxWidthList} = reshape(reshape((-pmAroundCenter:downsample:pmAroundCenter)' * ones(1,boxWidthList(1)), boxWidthList(1)^2, 1) * ones(1, T), boxWidthList(1)^2 * T, 1)';
    pmColInd{boxWidth == boxWidthList} = reshape(reshape(ones(boxWidthList(1),1) * (-pmAroundCenter:downsample:pmAroundCenter), boxWidthList(1)^2, 1) * ones(1, T), boxWidthList(1)^2 * T, 1)';
    pmTimeInd{boxWidth == boxWidthList} = reshape(ones(boxWidthList(1)^2, 1) * (1:T), boxWidthList(1)^2 * T, 1)';

    indXList{boxWidth == boxWidthList} = bsxfun(@plus, boxLoc(:, 1), pmRowInd{boxWidth == boxWidthList});
    indYList{boxWidth == boxWidthList} = bsxfun(@plus, boxLoc(:, 2), pmColInd{boxWidth == boxWidthList});
    indZList{boxWidth == boxWidthList} = ones(size(boxLoc, 1), 1) * pmTimeInd{boxWidth == boxWidthList};
    outOfBound{boxWidth == boxWidthList} = ...
        any(indXList{boxWidth == boxWidthList} < 1 | indYList{boxWidth == boxWidthList} < 1 ...
        | indXList{boxWidth == boxWidthList} > imgX | indYList{boxWidth == boxWidthList} > imgY, 2);
end

outOfBound = any(cell2mat(outOfBound), 2);
boxLoc(outOfBound, :) = [];
for boxWidth = boxWidthList
    indXList{boxWidth == boxWidthList}(outOfBound, :) = [];
    indYList{boxWidth == boxWidthList}(outOfBound, :) = [];
    indZList{boxWidth == boxWidthList}(outOfBound, :) = [];
    
    boxSeq{boxWidth == boxWidthList} = ...
        reshape(imageList{boxWidth == boxWidthList}(sub2ind(size(imageList{boxWidth == boxWidthList}), indXList{boxWidth == boxWidthList}, indYList{boxWidth == boxWidthList}, indZList{boxWidth == boxWidthList})), size(boxLoc, 1), boxWidthList(1), boxWidthList(1), T);
    
    if ~isempty(imgannot)
        boxSeqLabel(:, boxWidth == boxWidthList) = sum(double(...
            bsxfun(@gt, imgannot(:, 1), indXList{boxWidth == boxWidthList}(:, 1)') & bsxfun(@lt, imgannot(:, 1), indXList{boxWidth == boxWidthList}(:, end)') ...
            & bsxfun(@gt, imgannot(:, 2), indYList{boxWidth == boxWidthList}(:, 1)') & bsxfun(@lt, imgannot(:, 2), indYList{boxWidth == boxWidthList}(:, end)')), 1)';
    else
        boxSeqLabel(:, boxWidth == boxWidthList) = zeros(size(boxSeq{boxWidth == boxWidthList}, 1), 1);
    end
    boxSeq{boxWidth == boxWidthList} = cellfun(@(x)(squeeze(x)), mat2cell(boxSeq{boxWidth == boxWidthList}, ones(size(boxSeq{boxWidth == boxWidthList}, 1), 1), boxWidthList(1), boxWidthList(1), T), 'UniformOutput', false);
end

% Remove NaNs
tmp = []; for count2 = 1:size(boxSeq, 2); tmp = [tmp, boxSeq{count2}]; end; boxSeq = tmp;
delInd = any(cell2mat(cellfun(@(x)(any(isnan(x(:)))), tmp, 'UniformOutput', false)), 2);
boxSeq(delInd, :) = []; boxSeqLabel(delInd, :) = []; boxLoc(delInd, :) = [];

% Normalize
normalization = 'epsilon';
switch normalization
    case 'histogram'
        boxSeq = cellfun(@(x)(bsxfun(@rdivide, x, sum(sum(x, 1), 2))), boxSeq, 'UniformOutput', false);
    case 'epsilon'
        % epsilon normalization
        boxSeq = cellfun(@(x)(bsxfun(@rdivide, x, boxWidthList(1)^2 + sum(sum(x, 1), 2))), boxSeq, 'UniformOutput', false);
end

%% Note
% boxLoc is the center of the box

%% TODO
% remove patches with all zeros
% Remove warning "Warning: Number of input vectors, 4, did not match the input matrix's number of dimensions, 3. 1 trailing singleton input vectors were removed.". Happens when T = 1, and hence the fourth dimension is basically missing.