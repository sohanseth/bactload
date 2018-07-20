function myboxplot(data, varargin)
% MYBLOXPLOT plots box plots
%   MYBLOXPLOT(DATA) plots box plots given a cell of arrays DATA. DATA can
%   also be a matrix. MYBLOXPLOT adjusts the colors of the lines used in box.
%
%   The function takes the following optional variables
%       linecolor: colors of lines in boxplot (default [0.5 0.5 0.5])
%       markercolor: colors of marker in boxplot (default [0.3 0.3 0.3])
%       marker: marker used for outliers (default 'none')
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

argumentList = {'markercolor', 'linecolor', 'marker'};
argumentDefault = {[0.5 0.5 0.5], [0.3 0.3 0.3], 'none'};
options = parseVarArg(argumentList, argumentDefault, varargin);

if iscell(data)
    data = data(:);
    for count = 1:numel(data)
        grp{count, 1} = count * ones(size(data{count}));
    end
    data = cell2mat(cellfun(@(x)(x(:)), data, 'UniformOutput', false));
    grp = cell2mat(cellfun(@(x)(x(:)), grp, 'UniformOutput', false));    
    boxplot(data, grp)
else
    boxplot(data)
end
h = get(gca, 'children');

% Change line colors
for count = length(h.Children):-1:1
    set(h.Children(count), 'markeredgecolor', options.markercolor, 'color', options.linecolor)
end

% Remove outliers
for count = length(h.Children) - 6 * size(data, 2):-1:1
    set(h.Children(count), 'markeredgecolor', options.markercolor, ...
        'markerfacecolor', options.markercolor, ...
        'color', options.linecolor, 'marker', options.marker)
end