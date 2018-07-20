function [imgseqprob, bbs, objCount] = annotateVideo2(imgseq, param, varargin)
% ANNOTATEVIDEO2 estimates bacterial/celluar load in each image frame
%   [IMGSEQPROB, BBS, OBJCOUNT] = ANNOTATEVIDEO2(IMGSEQ, PARAM) estimates
%   the probability map IMGSEQPROB, location of objects BBS and count of
%   objects OBJCOUNT at each image frame given sequence of images IMGSEQ
%   and parameters of the filter PARAM. Both IMGSEQ and IMGSEQPROB are 3D
%   matrices of same dimensions. BBS is a array of cells. BBS{i,t} contains 
%   a 2D vector x-y locations of size OBJCOUNT(i,t) at t-th threshold
%
%   ANNOTATEVIDEO2 takes the following optional inputs:
%       boxWidthList: List of image patch sizes used as features (default *)
%       filename: if provided then intermediate imgseqprob, bbs, objCount are saved
%       threshList: list of thresholds for object detection
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

argumentList = {'boxWidthList', 'filename', 'threshList'};
argumentDefault = {[9, 27, 45], [], [0.7, 0.8, 0.9 0.95 0.99]};
options = parseVarArg(argumentList, argumentDefault, varargin);

% Load saved results if they exist
if ~isempty(options.filename) & exist(options.filename)
    load(options.filename, 'imgseqprob', 'objCount', 'bbs')
else
    imgseqprob = zeros(size(imgseq));
end

T = size(param.centersList{1}, 2); % temporal resolution

centerListSq = zeros(length(param.centersList), 1);
for count = 1:length(param.centersList)
    centerListSq(count, 1) = sum(cell2mat(cellfun(@(x)(sum(x(:).^2)), param.centersList{count}(:), 'UniformOutput', false)));
end

for countFrame = 1:T
    img = imgseq(:, :, countFrame);
    imgSq(:, :, countFrame) = computeSquare(img, options.boxWidthList);
    imgSqInd(countFrame) = countFrame;
end

for countFrame = ((T-1)/2 + 1):size(imgseq, 3)-(T-1)/2
    fprintf('[%d]\n', countFrame)
    if max(max(imgseqprob(:, :, countFrame), [], 1), [], 2) > 0        
        continue;
    end
    
    if countFrame > (T-1)/2 + 1 % && countFrame + (T-1)/2 > imgSqInd(end)
        img = imgseq(:, :, countFrame + (T-1)/2);
        imgSq(:, :, 1) = []; imgSq(:, :, T) = computeSquare(img, options.boxWidthList);
        imgSqInd(1) = []; imgSqInd(T) = countFrame + (T-1)/2;
    %else
    %    for countT = 1:T
    %        img = imgseq(:, :, countFrame + countT - (T-1)/2 - 1);
    %        imgSq(:, :, countT) = computeSquare(img, options.boxWidthList);
    %        imgSqInd(countT) = countFrame + countT - (T-1)/2 - 1;
    %    end
    end
    
    imgIP = 0;
    for countT = 1:T
        img = imgseq(:, :, countFrame + countT - (T-1)/2 - 1);
        cnt = cellfun(@(x)(x(:, countT)), param.centersList, 'UniformOutput', false);        
        imgIP = imgIP + computeInnerProducts(img, cnt, options.boxWidthList);
    end
    
    distances = sqrt(bsxfun(@plus, bsxfun(@plus, - 2 * sum(imgIP, 4), reshape(centerListSq, 1, 1, length(centerListSq))), sum(imgSq, 3)));
    imgseqprob(:, :, countFrame) = 1 ./ (1 + exp(- sum(bsxfun(@times, exp(-distances.^2 / param.sigma^2), reshape(param.weights, 1, 1, length(param.weights))), 3) - param.bias));
        
    for thresh = options.threshList
        [objCount(countFrame, thresh == options.threshList), ...
            bbs{countFrame, thresh == options.threshList}] = ...
            bbNmsWrapper(imgseqprob(:, :, countFrame), 9, thresh);
    end
    
    if mod(countFrame, 10) == 0
        save(options.filename, 'imgseqprob', 'objCount', 'bbs', '-v7.3')
    end
end