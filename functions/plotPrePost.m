function plotPrePost(data, varargin)
% PLOTPREPOST plots box plots for experiments with two conditions
%   PLOTPREPOST(DATA) plots boxplots given a Kx2 dimensional cell array
%   where each column denotes one condition.
%
%   The function takes the following variable arguments
%       condLabel: labels for 2 conditions (default {'pre', 'post'})
%       yLabel: y-axis label (default '')
%       divExp: number of cases and controls (default [])
%       expLabel: labels for 2 experimental divisions (default {'controls', 'cases'})
%       
% Author: Sohan Seth, sseth@ind.ed.ac.uk

argumentList = {'condLabel', 'yLabel', 'divExp', 'expLabel'};
argumentDefault = {{'pre', 'post'}, '', [], {'controls', 'cases'}};
options = parseVarArg(argumentList, argumentDefault, varargin);

myboxplot(data');
set(gca, 'xtick', 1:numel(data), 'ylim', [0 max(cell2mat(data(:)))], ...
    'xticklabel', repmat(options.condLabel, 1, size(data, 1)))
myxylabel('', options.yLabel, '')
box on

% Draw separators
YLIM = get(gca, 'YLIM');
for count = 1:2:numel(data)
    line([count - 0.5, count - 0.5], 1.1*YLIM, 'color', 'k', 'linestyle', ':')
end

if ~isempty(options.divExp)
    noControl = options.divExp(1);
    noCase = options.divExp(2);
    % Draw separators between case and control
    line((0.5 + 2 * noControl) * [1 1], 1.1*YLIM, 'color', 'k', 'linestyle', '--')
    % Put texts    
    text(0.5 + noControl, YLIM(2), sprintf('%d %s', noControl, options.expLabel{1}), ...
        'horizontalalignment', 'center', 'fontsize', 8, 'backgroundcolor', [1 1 1])
    text(0.5 + noCase + 2 * noControl, YLIM(2), sprintf('%d %s', noCase, options.expLabel{2}), ...
        'horizontalalignment', 'center', 'fontsize', 8, 'backgroundcolor', [1 1 1])
    set(gca, 'ylim', [YLIM(1), YLIM(2)*1.1])
    YLIM = get(gca, 'YLIM');
end