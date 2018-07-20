function distances = computeDistances(img, centerList, boxWidthList)
% DISTANCES = COMPUTEDISTANCES(IMG, CENTERLIST, BOXWIDTHLIST) computes the
%   pairwise distances between image patches with resolutions (but downsampled
%   to BOXWIDTHLIST(1)) listed in array BOXWIDTHLIST of the image IMG (3D 
%   matrix of size M x N x T) and a set of image patches in CENTERLIST, a 
%   list of 2D cell arrays (|BOXWIDTHLIST| x T) of 2D matrices of dimension
%   BOXWIDTHLIST(1) x BOXWIDTHLIST(1). Each image patch is epsilon normalized
%   by its intensity. The image patches from IMG are downsampled to match 
%   CENTERLIST. DISTANCES is a 2D matrix of dimension M x N.
% 
% See ../tests/testComputeDistances.m
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

innerProducts = computeInnerProducts(img, centerList, boxWidthList);
imgSq = computeSquare(img, boxWidthList);
for count = 1:length(centerList)
    centerListSq(count, 1) = sum(cell2mat(cellfun(@(x)(sum(x(:).^2)), centerList{count}(:), 'UniformOutput', false)));
end
distances =  sqrt(bsxfun(@plus, bsxfun(@plus, - 2 * innerProducts, reshape(centerListSq, 1, 1, length(centerListSq))), imgSq));
