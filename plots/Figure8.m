flagPlot = true; flagSave = true;
FILEPATH = '../data/cell/imageList';

%% Figure 8: positive and negative RBF centers
yLabelList = {'9\times 9', '27\times 27', '45\times 45', '63\times 63'};
titleList = {'t -1', 't', 't +1'};

countCV = 1;
load(sprintf('%s_multires', FILEPATH), 'boxWidthList')
load(sprintf('%s_multires_kmeans_%d', FILEPATH, countCV))
if flagPlot
    h = myfigure([3 4] * 0.7);
    for count = 1%:size(centersPos{countCV}, 1)
        centersPatch = vec2patch(centersPos{countCV}(count, :), boxWidthList, true);
        plotDictionary(centersPatch, ...
            'figHandle', h, 'colormap', colormapGreen, 'normalize', true, ...
            'titleList', titleList, 'yLabelList', yLabelList)
        filename = sprintf('../figures/fig/kmeans_center_pos_%d.fig', count);
        if flagSave; saveImage(filename, 'figHandle', gcf); end
        pause(1)
    end
        
    for count = 1%:size(centersNeg{countCV}, 1)
        centersPatch = vec2patch(centersNeg{countCV}(count, :), boxWidthList, true);
        plotDictionary(centersPatch, ...
            'figHandle', h, 'colormap', colormapGreen, 'normalize', true, ...
            'titleList', titleList, 'yLabelList', yLabelList)
        filename = sprintf('../figures/fig/kmeans_center_neg_%d.fig', count);
        if flagSave; saveImage(filename, 'figHandle', gcf); end
        pause(1)
    end
end