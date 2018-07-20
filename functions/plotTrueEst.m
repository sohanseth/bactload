function h = plotTrueEst(imgList, imgannot_true, imgannot_est, varargin)
% PLOTANNOT plots a dot annotated image showing true and estimated annotations
%   PLOTANNOT(IMGLIST, IMGANNOT) plots a (sequence) of K images stored in a
%   (*, *, K) dimensional array, and annotate the image(s) with dots at
%   locations stored in the 2D array IMGANNOT. If IMGANNOT is a cell array
%   of 2D arrays, then each cell is treated as independent annotations and
%   plotted with different colors.
%   
%   H = PLOTANNOT(IMGLIST, IMGANNOT) does the same and returns the handle.
%
%   PLOTANNOT takes the following optional arguments
%       figSize: size of the figure in inches (default 3)
%       markerSize: size of the marker in units (default 4)
%       legendList: list of legends for each IMGANNOT cell (default NONE)
%       titleList: list of titles for each k-th image (default NONE)
%       figHandle: use given figure handle to plot (default NEW FIGURE)
%       annotateMiddle: if true then only annotates the image in middle
%       boxWidthList:(list of) box widths, if given then box annotation is used
%       colorList: list of colors for annotations
%       fontsize: fontsize (default 10)
%       fill: if true then fill the annotations (default true)
%       diameter: diameter for determining TP, FP and FN
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

colormapGreen = [zeros(128, 1), (1:128)'/128, zeros(128, 1)];
colorList = [0.8941, 0.1020, 0.1098; 
    0.2157, 0.4941, 0.7216; 
    1.0000, 1.0000, 0.2000];

varList = {'diameter', 'fill', 'figSize', 'markerSize', 'legendList', 'titleList', 'figHandle', 'annotateMiddle', 'boxWidthList', 'colorList', 'fontsize'};
varDefault = {4, true, 3, 4, {'TP', 'FP', 'FN'}, [], [], true, [], colorList, 10};
options = parseVarArg(varList, varDefault, varargin);

matchIndices = pdist2(imgannot_est, imgannot_true, 'euclidean') < options.diameter; 
[~, matchIndicesSorted, noTruthIndices, noDetectionIndices, ...
    singleTruthSingleDetection, singleTruthMultipleDetections, singleDetectionMultipleTruths, ...
    multipleTruthsMultipleDetections] = computeContingency(matchIndices);

% False positives
imgannot{2} = imgannot_est(noTruthIndices, :); 
imgannot_est(noTruthIndices, :) = NaN;
% False negatives
imgannot{3} = imgannot_true(noDetectionIndices, :); 
imgannot_true(noDetectionIndices, :) = NaN;
% True positives
imgannot{1} = imgannot_est(singleTruthSingleDetection(:, 1), :); 
imgannot_est(singleTruthSingleDetection(:, 1), :) = NaN;
% imgannot{3} = imgannot_true(singleTruthSingleDetection(:, 2), :); 
% imgannot_true(singleTruthSingleDetection(:, 2), :) = NaN;

options = rmfield(options, 'diameter');
argList = reshape([fieldnames(options)'; struct2cell(options)'], 1, 2*length(fieldnames(options)));
plotAnnot(imgList, imgannot, argList{:})