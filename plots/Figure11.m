flagPlot = true; flagSave = true;
FILEPATH = '../data/bact/';

%% Ground truth annotations vs. detection
if ~exist('imageList', 'var'); load(sprintf('%simageKev', FILEPATH)); end
load(sprintf('%sannotationKev', FILEPATH))
I = 134; h = myfigure([3 3] * 0.7);

load(sprintf('%simageKev_singleres_currentframe_LRR', FILEPATH), 'bbs', 'contingency')
plotTrueEst(removeQuantiles(imageList{I}(:, :, 2)), ...
    annotationList{I}(:, [2 1]), bbs{I, 2}, 'figHandle', h, 'markersize', 4, 'fontsize', 8);
filename = sprintf('../figures/fig/imageKev_ip_singleres_currentframe_%d', I);
saveImage(filename, 'figHandle', h, 'fontsize', 6);
fprintf('single res, current frame, LR: %d\n', contingency(2, 2, I, 2))

load(sprintf('%simageKev_singleres_LRR', FILEPATH), 'bbs', 'contingency')
plotTrueEst(removeQuantiles(imageList{I}(:, :, 2)), ...
    annotationList{I}(:, [2 1]), bbs{I, 2}, 'figHandle', h, 'markersize', 4, 'fontsize', 8);
filename = sprintf('../figures/fig/imageKev_ip_singleres_%d', I);
saveImage(filename, 'figHandle', h, 'fontsize', 6);
fprintf('single res, current frame, LR: %d\n', contingency(2, 2, I, 2))

load(sprintf('%simageKev_ip_singleres_contingency', FILEPATH), 'bbs', 'contingency')
plotTrueEst(removeQuantiles(imageList{I}(:, :, 2)), ...
    annotationList{I}(:, [2 1]), bbs{I, 2}, 'figHandle', h, 'markersize', 4, 'fontsize', 8);
filename = sprintf('../figures/fig/imageKev_ip_singleres_kmeans_%d', I);
saveImage(filename, 'figHandle', h, 'fontsize', 6);
fprintf('single res, multiple frame, RBF: %d\n', contingency(2, 2, I, 1))

load(sprintf('%simageKev_ip_contingency', FILEPATH), 'bbs', 'contingency')
plotTrueEst(removeQuantiles(imageList{I}(:, :, 2)), ...
    annotationList{I}(:, [2 1]), bbs{I, 2}, 'figHandle', h, 'markersize', 4, 'fontsize', 8);
filename = sprintf('../figures/fig/imageKev_ip_multires_kmeans_%d', I);
saveImage(filename, 'figHandle', h, 'fontsize', 6);
fprintf('multiple res, multiple frame, RBF: %d\n', contingency(2, 2, I, 2))