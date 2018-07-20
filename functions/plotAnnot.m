function h = plotAnnot(imgList, imgannot, varargin)
% PLOTANNOT plots a dot/box annotated image
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
%
% Author: Sohan Seth

colormapGreen = [zeros(128, 1), (1:128)'/128, zeros(128, 1)];
colorList = [0.8941, 0.1020, 0.1098; 
    0.2157, 0.4941, 0.7216; 
    0.3020, 0.6863, 0.2902];

varList = {'fill', 'figSize', 'markerSize', 'legendList', 'titleList', 'figHandle', 'annotateMiddle', 'boxWidthList', 'colorList', 'fontsize'};
varDefault = {true, 3, 4, [], [], [], true, [], colorList, 10};
options = parseVarArg(varList, varDefault, varargin);

if ~iscell(imgannot)
    tmp = imgannot; clear imgannot;
    imgannot{1} = tmp;
end

if isempty(options.figHandle) | options.figHandle == 0
    options.figHandle = myfigure([options.figSize * size(imgList, 3), options.figSize]);
else
    figure(options.figHandle);
end

options.top = 0;
if ~isempty(options.titleList)
    options.top = 0.16 / options.figHandle.PaperPosition(4); % 0.08;
end
options.left = 0;

if options.annotateMiddle
    annotateInd = ceil(size(imgList, 3) / 2);
else
    annotateInd = 1:size(imgList, 3);
end

figHandle = zeros(size(imgList, 3), 1);
for countImage = 1:size(imgList, 3)
    figHandle(countImage) = mysubplot(1, size(imgList, 3), countImage, ...
        'top', options.top, 'column', 0.001);
    
    colormap(colormapGreen);
    img = imgList(:, :, countImage);        
    imagesc(img');
    set(gca, 'xtick', [], 'ytick', []); hold on;
    
    labelList = {'', '', ''};    
    if ~isempty(options.titleList)
        labelList{3} = options.titleList{countImage};
    end
    myxylabel(labelList{:}, 'fontsize', options.fontsize)
    
    for countAnnot = 1:length(imgannot)        
        if any(countImage == annotateInd) & ~isempty(imgannot{countAnnot})
            if isempty(options.boxWidthList)
                if options.fill
                    legendHandle(countAnnot) = plot(imgannot{countAnnot}(:, 1), imgannot{countAnnot}(:, 2), ...
                        'o', 'color', options.colorList(countAnnot, :), 'markerSize', options.markerSize, ...
                        'markerfacecolor', options.colorList(countAnnot, :));
                else
                    legendHandle(countAnnot) = plot(imgannot{countAnnot}(:, 1), imgannot{countAnnot}(:, 2), ...
                        'o', 'color', options.colorList(countAnnot, :), 'markerSize', options.markerSize);
                end
            else
                for boxWidth = flipud(options.boxWidthList)
                    for countAnnotIn = 1:size(imgannot{countAnnot}, 1)
                        rectangle('position', [imgannot{countAnnot}(countAnnotIn, 1) - floor(boxWidth/2), imgannot{countAnnot}(countAnnotIn, 2) - floor(boxWidth/2), boxWidth, boxWidth], ...
                            'edgecolor', options.colorList(countAnnot, :));
                    end
                end
                legendHandle(countAnnot) = plot(0, 0, ...
                    's', 'color', options.colorList(countAnnot, :), 'markerSize', options.markerSize);
            end
        end
    end
    hold off
end

linkaxes(figHandle);
if ~isempty(imgannot{1})
    ind = ~ishandle(legendHandle);
    legendHandle(ind) = []; options.legendList(ind) = [];
    if ~isempty(options.legendList)
        mylegend(legendHandle, options.legendList, 'color', 'none', ...
            'edgecolor', 'none', 'textcolor', [1 1 1], 'position', [0.01 0 0.05 / size(imgList, 3) 0.05 * length(legendHandle)]);
    end
end

if nargout == 1
    h = options.figHandle;
end