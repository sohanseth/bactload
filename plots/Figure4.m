flagPlot = true; flagSave = true;
FILEPATH = '../data/cell/';

h = myfigure(8 * [1 1/3]);
titleList = {'t -1', 't', 't +1'};
load(sprintf('%sannotationList', FILEPATH))
sum(cellfun(@(x)(~isempty(x)), annotationList))
if ~exist('imageList', 'var'); load(sprintf('%simageList.mat', FILEPATH)); end
I = 100;
plotAnnot(imageList{I}, annotationList{I}(:, [2, 1]), 'titleList', titleList, 'figHandle', h)
filename = '../figures/fig/sohan_annotation_st';
saveImage(filename, 'figHandle', gcf);