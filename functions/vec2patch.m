function patch = vec2patch(vec, boxWidthList, unfold)
% VEC2PATCH transforms a vector to an spatio temporal image patch
% PATCH = VEC2PATCH(VEC, BOXWIDTHLIST) returns a cell array of |BOXWIDTHLIST|
%   3D matrix of dimensions BOXWIDTHLIST(1) x BOXWIDTHLIST(1) x T given a 
%   row vector VEC of dimension (BOXWIDTHLIST(1)^2 x T).
%
% PATCH = VEC2PATCH(VEC, BOXWIDTHLIST, 1) returns a cell array of 
%   |BOXWIDTHLIST| x T of 2D matrix BOXWIDTHLIST(1) x BOXWIDTHLIST(1) given
%   a  row vector VEC of dimension (BOXWIDTHLIST(1)^2 x T).
%
% See ../tests/testVec2Patch.m
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

DIM = boxWidthList(1);
R = length(boxWidthList); % spatial resolution
T = size(vec, 2) / DIM^2 / R; % temporal resolution

patch = reshape(squeeze(mat2cell(reshape(vec, DIM, DIM, R * T), DIM, DIM, ones(1, R * T))), T, R);
if nargin == 3 && unfold == true
    patch = patch'; % columns are time and rows are resolutions
    return
else
    patch = cellfun(@(x)(cat(3, x{:})), (mat2cell(patch, T, ones(1, R))), 'UniformOutput', false);
end

% mat2cell(vec, ones(1, size(vec, 1)), size(vec, 2))
% reshape(squeeze(mat2cell(reshape(centers(countCent, :), 9, 9, 9), 9, 9, ones(1, 9))), 3, 3)';
% TMP = vec(1:10,:); N = 10;
% reshape(squeeze(mat2cell(reshape(TMP', DIM, DIM, R * T, N), DIM, DIM, ones(1, T * R))), R, T)';