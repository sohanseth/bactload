function CVIndices = generateCVIndices(n, fold, seed)
% GENERATECVINDICES splits indices in training and testing
%   CVINDICES = GENERATECVINDICES(N, FOLD) splits N samples in FOLD fold 
%   and return binary indices of training and testing for each fold in the
%   cell of structures CVINDICES. CVINDICES{i}.TRAIN contains the training
%   indices and CVINDICES{i}.TEST contains the respective testing indices.
%
%   CVINDICES = GENERATECVINDICES(N, fold, SEED) does the same job and
%   additionally set the random seed to SEED
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

if nargin == 2
    rng default
else
    rng(seed)
end

tmp = mod(randperm(n), fold) + 1;
CVIndices = cell(fold, 1);
for count = 1:fold
    CVIndices{count}.train = (tmp ~= count);
    CVIndices{count}.test = (tmp == count);
end