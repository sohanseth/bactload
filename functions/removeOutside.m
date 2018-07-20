function imgseq = removeOutside(imgseq)
% REMOVEOUTSIDE detects the region outside a circlular image IMGSEQ, and 
%   replaces the arbitrary values within this region with nan. IMGSEQ is
%   a square matrix representing a circular image where values outside the
%   circle has been set to an arbitrary value.
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

imgseq = double(imgseq);
for countFrame = 1:size(imgseq, 3)
    tmp = double(imgseq(:, :, countFrame));
        
    for count = 1:size(tmp, 2)
        if length(unique(tmp(:, count))) == 1
            tmp(:, count) = nan;
        else
            loc = find(diff(tmp(:, count)) ~= 0);
            tmp(1:loc(1), count) = nan;
            tmp(loc(end)+1:end, count) = nan;
        end
    end
    
    imgseq(:, :, countFrame) = tmp;
end