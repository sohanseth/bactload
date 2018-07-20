flagPlot = true; flagSave = true;
FILEPATH = '../data/cell/imageList';

%% Ground truth annotations vs. detection
if ~exist('imageList', 'var'); load(FILEPATH); end
load ../data/cell/annotationList
I = 100; h = myfigure([3 3] * 0.7);
% load(sprintf('%s_multires_kmeans_LRR_ip', FILEPATH), 'bbs')

load(sprintf('%s_multires_kmeans_LRR_ip.mat', FILEPATH), 'bbs')
if isempty(annotationList{I}); annotationList{I} = zeros([0, 2]); end
plotTrueEst(imageList{I}(:, :, 2), ...
    annotationList{I}(:, [2 1]), bbs{I, 1}, 'figHandle', h, 'markersize', 4, 'diameter', 10, 'fontsize', 8);
filename = sprintf('../figures/fig/imageList_ip_multires_fourres_%d', I);
saveImage(filename, 'figHandle', gcf);

load(sprintf('%s_multires_kmeans_LRR_ip.mat', FILEPATH), 'bbs')
if isempty(annotationList{I}); annotationList{I} = zeros([0, 2]); end
plotTrueEst(imageList{I}(:, :, 2), ...
    annotationList{I}(:, [2 1]), bbs{I, 1}, 'figHandle', h, 'markersize', 4, 'diameter', 10, 'fontsize', 8);
filename = sprintf('../figures/fig/imageList_ip_multires_threeres_%d', I);
saveImage(filename, 'figHandle', gcf, 'fontsize', 6);