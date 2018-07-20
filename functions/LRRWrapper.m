function [YPred, param] = LRRWrapper(XTrain, YTrain, XTest, param)
% LRRWRAPPER performs l2 regularized logistic regression
% [YPRED, PARAM] = LRRWRAPPER(XTRAIN, YTRAIN, XTEST, PARAM) learns a l2
%   regularised linear classifier given design matrix XTRAIN (n x d),
%   response vector YTRAIN (n x 1), and test data XTEST (m x d). It returns 
%   the predicted probability vector YPRED (m x 1), and parameters w and b
%   in a structure PARAM. PARAM is an optional input argument which contains
%   the regularizer lambda that is otherwise set to 10^-2.
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

% addpath ~/Desktop/matlabToolbox/machineLearning-master/supervisedLearning/logisticRegression/

YTrain = YTrain(:);
if ~all(isnumeric(YTrain))
    error('expecting numeric values')
else
    if ~(unique(sort(YTrain)) == [0; 1])
        error('expecting 0-1 values')
    end
end

% add bias terms
XTrain = [ones(size(XTrain, 1), 1), XTrain];

initial_weight = randn(size(XTrain, 2), 1);

%warning('Initializing with mean of positive examples')
%initial_weight = mean(XTrain(YTrain == 1, :))';

if nargin == 4
    lambda = param.lambda;
else
    lambda = 10^-2; % Regularization parameter
end
options = optimset('GradObj', 'on', 'MaxIter', 100, 'Display', 'iter');
[b, ~, ~] = ...
	fminunc(@(t)(costFunctionReg(t, XTrain, YTrain, lambda)), initial_weight, options);

YPred = 1 ./ (1 + exp(- (XTest * b(2:end) + b(1)))); % Probability of true
param.w = b(2:end);
param.b = b(1);