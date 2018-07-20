function img = computeSquare(img, boxWidthList)
% IMG = COMPUTESQUARES(IMG, BOXWIDTHLIST) computes the squared sum of image
%   patches of with resolutions (but downsampled to BOXWIDTHLIST(1)) listed
%   in array BOXWIDTHLIST of the image IMG (3D matrix of size M x N x T). 
%   Each image patch is epsilon normalized by its intensity. The squared 
%   values are added over T. IMG (op) is a 2D matrix of dimension M x N.
% 
% See ../tests/testComputeDistances.m
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

T = size(img, 3); imgX = size(img, 1); imgY = size(img, 2);
if nargin < 2
    boxWidthList = [9, 27, 45];
end

downsampleList = ceil(boxWidthList / boxWidthList(1));
imageList = cell(length(downsampleList), 1); imageList{1} = img; clear img
for downsample = downsampleList(2:end)
    floorDownsampleBy2 = floor(downsample/2);
    for countT = 1:size(imageList{1}, 3)
        C = conv2(imageList{1}(:, :, countT), ones(downsample) / downsample^2);
        imageList{downsample == downsampleList}(:, :, countT) = ...
            C(floorDownsampleBy2+1:end-floorDownsampleBy2, floorDownsampleBy2+1:end-floorDownsampleBy2);
    end
end

imageListSq = cellfun(@(x)(x.^2), imageList, 'UniformOutput', false);

for boxWidth = boxWidthList
    floorBoxwidthBy2 = floor(boxWidth/2);
    
    downsample = downsampleList(boxWidth == boxWidthList);
    pmAroundCenter = (boxWidth - downsample) / 2;    
    pmRowInd{boxWidth == boxWidthList} = ...
        reshape((-pmAroundCenter:downsample:pmAroundCenter)' * ones(1,boxWidthList(1)), boxWidthList(1)^2, 1);
    pmColInd{boxWidth == boxWidthList} = ...
        reshape(ones(boxWidthList(1),1) * (-pmAroundCenter:downsample:pmAroundCenter), boxWidthList(1)^2, 1);
    
    filterCoeff = zeros(boxWidth);
    filterCoeff(sub2ind(size(filterCoeff), ...
        ceil(boxWidth/2) + pmRowInd{boxWidth == boxWidthList}, ...
        ceil(boxWidth/2) + pmColInd{boxWidth == boxWidthList})) = 1;
    
    for countT = 1:T        
        normalization = 'epsilon';
        switch normalization
            case 'histogram'
                C = conv2(imageListSq{downsample == downsampleList}(:, :, countT), filterCoeff) ...
                    ./ (conv2(imageList{downsample == downsampleList}(:, :, countT), filterCoeff).^2);
            case 'epsilon'
                C = conv2(imageListSq{downsample == downsampleList}(:, :, countT), filterCoeff) ...
                    ./ (boxWidthList(1)^2 + conv2(imageList{downsample == downsampleList}(:, :, countT), filterCoeff)).^2;
        end
        imageList{downsample == downsampleList}(:, :, countT) = ...
            C(floorBoxwidthBy2+1:end-floorBoxwidthBy2, floorBoxwidthBy2+1:end-floorBoxwidthBy2);
    end    
    imageList{downsample == downsampleList} = sum(imageList{downsample == downsampleList}, 3);
end
img = reshape(sum(cell2mat(cellfun(@(x)(x(:)'), imageList, 'UniformOutput', false)), 1)', imgX, imgY);