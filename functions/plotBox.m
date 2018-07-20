function h = plotBox(img, imgannot, imgannotlabel, varargin)
% PLOTBOX plots a box annotated image
%   PLOTBOX(IMGLIST, IMGANNOT, IMGANNOTLABEL) plots a (sequence) of K images
%   stored in a (*, *, K) dimensional array, and annotate the image(s) with
%   square boxes at locations stored in the 2D arrays IMGANNOT. Each location
%   in IMGANNOT has a label stored IMGANNOTLABEL, and the boxes are colored
%   based on their labels.
%   
%   H = PLOTBOX(IMGLIST, IMGANNOT, IMGANNOTLABEL) does the same and returns the handle.
%
%   This function is a wrapper for plotAnnot
%
%   PLOTBOX takes the following optional arguments
%       figSize: size of the figure in inches (default 3)
%       markerSize: size of the marker in units (default 4)
%       legendList: list of legends for each IMGANNOT cell (default NONE)
%       titleList: list of titles for each k-th image (default NONE)
%       figHandle: use given figure handle to plot (default NEW FIGURE)
%       boxWidthList: list of box widths (default 9)
%       colorList: list of colors for annotations
%       fontsize: fontsize (default 10)
%
% Author: Sohan Seth

countMaster = 1;
for count = unique(imgannotlabel)'
    tmp{countMaster} = imgannot(imgannotlabel == count, :);
    countMaster = countMaster + 1;
end
clear imgannot
imgannot = tmp;

colorList = [[50 250 50]; [250, 50, 50]; [50 50 250]]/255;
colormapGreen = [zeros(128, 1), (1:128)'/128, zeros(128, 1)];

varList = {'figSize', 'markerSize', 'legendList', 'titleList', 'figHandle', 'boxWidthList', 'colorList', 'fontsize'};
varDefault = {3, 4, {'neg', 'pos'}, [], false, 9, colorList, 10};
options = parseVarArg(varList, varDefault, varargin);

argList = reshape([fieldnames(options)'; struct2cell(options)'], 1, 2*length(fieldnames(options)));
h = plotAnnot(img, imgannot, argList{:}, 'annotateMiddle', false);

% function h = plotBox(img, imgannot, imgannotlabel, h)
% % This function plots an annotated image showing location of bacteria
% 
% if nargin == 3
%     h = figure;
% else
%     figure(h);
% end
% subplot('position', [0, 0, 1, 1]);
% imgannotlabel = imgannotlabel + 1; imgannotlabel(imgannotlabel > 3) = 3;
% 
% startup
% colorList = [[50 250 50]; [250, 50, 50]; [50 50 250]]/255;
% colormap(colormapGreen)
% for count = 1:size(img, 3)
%     h(count) = subplot(1, size(img, 3), count);
%     imagesc(img', [quantile(img(:), 0.001), quantile(img(:), 0.999)])
%     set(gca, 'xtick', [], 'ytick', []);hold on
%     for countBac = 1:size(imgannot, 1)
%         rectangle('position', [imgannot(countBac, 1), imgannot(countBac, 2), boxWidth, boxWidth], ...
%             'edgecolor', colorList(imgannotlabel(countBac), :))
%     end
%     hold off
% end
% linkaxes(h, 'xy')