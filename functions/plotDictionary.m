function h = plotDictionary(images, varargin)
% PLOTDICTIONARY plots a set of image patches as tiles
%   PLOTDICTIONARY(IMAGES) plots a NxM matrix of images stored in a
%   NxM dimensional cell array. If the cell array is 1xK dimension then the 
%   images are plotted in a MxM matrix where M is the smallest integer for
%   which M^2 > K. Images can also be stored in a (*,*,K) matrix.
%   
%   H = PLOTDICTIONARY(IMAGES) returns the figure handle.
%
%   PLOTDICTIONARY takes the following optional arguments
%       titleList: list of titles for each k-th image (default NONE)
%       figHandle: use given figure handle to plot (default NEW FIGURE)
%       figSize: size of the figure in inches (default 3)
%       normalize: if true then the images are normalized together (default false)
%       colormap: colormap for the images (default gray)
%       dimension: dimension of the matrix the images are plotted as
%           (see function description for default)
%
% Author: Sohan Seth

argumentList = {'normalize', 'dimension', 'colormap', 'figHandle', 'titleList', 'yLabelList'};
argumentDefault = {false, [], 'gray', [], [], []};
options = parseVarArg(argumentList, argumentDefault, varargin);

if ~iscell(images)
    tmp = images; clear images
    images = squeeze(mat2cell(tmp, size(tmp, 1), size(tmp, 2), ones(1,size(tmp, 3))));
end

if options.normalize
    maxValue = double(max(cell2mat(cellfun(@(x)(x(:)), images(:), 'uniformoutput', false))));
    minValue = double(min(cell2mat(cellfun(@(x)(x(:)), images(:), 'uniformoutput', false))));
else
    maxValue = 1; minValue = 0;
end

if isempty(options.dimension)
    if any(size(images) == 1)
        ROW = ceil(sqrt(length(images))); COL = ROW;
    else
        [ROW, COL] = size(images);
    end
else
    ROW = options.dimension(1);
    COL = options.dimension(2);
end

if isempty(options.figHandle)
    options.figHandle = myfigure([COL ROW]);
else
    figure(options.figHandle);
end

options.top = 0;
if ~isempty(options.titleList)
    options.top = 0.16 / options.figHandle.PaperPosition(4); % 0.3 / ROW;
end
options.left = 0;
if ~isempty(options.yLabelList)
    options.left = 0.16 / options.figHandle.PaperPosition(3); % 0.3 / COL;
end

images = images';
for countMaster = 1:numel(images)
    C = colormap(options.colormap);    
    mysubplot(ROW, COL, countMaster, 'top', options.top, 'left', options.left, 'row', 0.01, 'column', 0.01);
    
    if options.normalize        
        image((double(images{countMaster}) - minValue) / (maxValue - minValue) * size(C, 1));
    else
        imagesc(images{countMaster});
    end
    set(gca, 'xtick', [], 'ytick', [])
    
    labelList = {'', '', ''};    
    if ~isempty(options.titleList) && countMaster <= COL 
        labelList{3} = options.titleList{mod(countMaster, COL+1)};
    end
    if ~isempty(options.yLabelList) && mod(countMaster, COL) == 1
        labelList{2} = options.yLabelList{1 + floor(countMaster/ROW)};
    end
    myxylabel(labelList{:}, 'fontsize', 10)
end

if nargout == 2
    h = options.figHandle;
end