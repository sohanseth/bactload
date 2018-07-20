flagPlot = true; flagSave = true;
FILEPATH = '../data/cell/imageList';

%% Example image frames
load(FILEPATH)
h = myfigure([2, 2]);
for c = [44, 93, 100, 112]
    plotAnnot(imageList{c}(:, :, 2), [], 'figHandle', h);
    filename = sprintf('../figures/fig/imageList_%d', c);
    saveImage(filename, 'figHandle', h)
end