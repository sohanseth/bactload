flagPlot = true; flagSave = true;
FILEPATH = '../data/bact/';

%% Examples of positive and negative RBF centers
boxWidthList = [9 27 45];
titleList = {'t -1', 't', 't +1'};
yLabelList = {'9\times 9', '27\times 27', '45\times 45'};
colormapGreen = [zeros(128, 1), (1:128)'/128, zeros(128, 1)];
countCV = 1;
load(sprintf('%simageKev_multires_kmeans_%d', FILEPATH, countCV))
if flagPlot
    h = myfigure([3 3] * 0.7);
    for count = 1%:size(centersPos{countCV}, 1)
        % centersPatch = vec2patch(squeeze(mat2cell(reshape(centersPos{countCV}(count, :), 9, 9, 9), 9, 9, ones(1, 9))));
        centersPatch = vec2patch(centersPos{countCV}(count, :), boxWidthList, true);
        plotDictionary(centersPatch, ...
            'figHandle', h, 'colormap', colormapGreen, 'normalize', true, ...
            'titleList', titleList, 'yLabelList', yLabelList)
        filename = sprintf('../figures/fig/kmeans_center_pos_%d.fig', count);
        saveImage(filename, 'figHandle', gcf);
        % pause(1)
    end
        
    for count = 1%:size(centersNeg{countCV}, 1)
        % centersPatch = vec2patch(squeeze(mat2cell(reshape(centersNeg{countCV}(count, :), 9, 9, 9), 9, 9, ones(1, 9))));
        centersPatch = vec2patch(centersNeg{countCV}(count, :), boxWidthList, true);
        plotDictionary(centersPatch, ...
            'figHandle', h, 'colormap', colormapGreen, 'normalize', true, ...
            'titleList', titleList, 'yLabelList', yLabelList)
        filename = sprintf('../figures/fig/kmeans_center_neg_%d.fig', count);
        saveImage(filename, 'figHandle', gcf);
        % pause(1)
    end
end