function [smallInd, largeInd] = convertIndices(downSize, upSize)
% [SMALLIND, LARGEIND] = CONVERTINDICES(DOWNSIZE, UPSIZE) matches indices 
%   between a downsampled matrix (DOWNSIZE x DOWNSIZE) and an upsample matrix
%   (UPSIZE x UPSIZE) for one to many mapping.
%
% See ../tests/testConvertIndices.m
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

downSample = upSize/downSize;
tmp = 1:downSample:upSize;
boxLocRow = reshape(tmp(:) * ones(1, length(tmp)), length(tmp)^2, 1);
boxLocCol = reshape(ones(length(tmp), 1) * tmp, length(tmp)^2, 1);
boxIndRow = reshape((0:downSample-1)' * ones(1, downSample), downSample^2, 1);
boxIndCol = reshape(ones(downSample, 1) * (0:downSample-1), downSample^2, 1);

indX = bsxfun(@plus, boxLocRow, boxIndRow');
indY = bsxfun(@plus, boxLocCol, boxIndCol');

tmp = 1:downSize;
boxLocRowSub = reshape(tmp(:) * ones(1, length(tmp)), length(tmp)^2, 1);
boxLocColSub = reshape(ones(length(tmp), 1) * tmp, length(tmp)^2, 1);

smallInd = sub2ind(downSize * [1, 1], boxLocRowSub, boxLocColSub) * ones(1, downSample.^2);
largeInd = sub2ind(upSize * [1, 1], indX, indY);