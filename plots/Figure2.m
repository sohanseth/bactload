flagPlot = true; flagSave = true;
FILEPATH = '../data/bact/';

%% Example image frames
load(sprintf('%simageKev.mat', FILEPATH))
h = myfigure([2, 2]);
for c = [13, 36, 57, 63]
    plotAnnot(removeQuantiles(imageList{c}(:, :, 2)), [], 'figHandle', h);
    filename = sprintf('../figures/fig/imageKev_%d', c);
    saveImage(filename, 'figHandle', h)
end