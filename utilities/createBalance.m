function [X, Y] = createBalance(X, Y, POS)
% CREATEBALANCE subsamples one class to balance two classes
%   [X, Y] = CREATEBALANCE(X, Y) takes a data matrix X and a binary response
%   vector Y as input. It assumes that there are more negative sampels 
%   Y = 0 than positive samples Y = 1. It subsamples the negative samples
%   such that there are equal number of positive and negative samples.
%
%   [X, Y] = CREATEBALANCE(X, Y, TRUE) does the same but subsamples the 
%   positive samples. By dafault [X, Y] = CREATEBALANCE(X, Y, FALSE) is called.
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

if nargin == 2
    POS = false;
end

rng default
posSamples = X(Y == 1, :);
posLabels = Y(Y == 1, :);
negSamples = X(Y == 0, :);
negLabels = Y(Y == 0, :);

if POS == false
    fprintf('subsample negative set\n')
    negIndex = randi(size(negSamples, 1), length(posLabels), 1);
    posIndex = 1:length(posLabels);
end
if POS == true
    fprintf('subsample positive set\n')
    negIndex = 1:length(negLabels);
    posIndex = randi(size(posSamples, 1), length(negLabels), 1);
end

% subsample
X = [posSamples(posIndex, :); negSamples(negIndex, :)];
Y = [posLabels(posIndex, :); negLabels(negIndex, :)];