flagPlot = true; flagSave = true;
FILEPATH = '../data/bact/';

%%
h = myfigure(7 * [1, 1/3]);
if ~exist('imageList', 'var'); load(sprintf('%simageKev', FILEPATH)); end
if ~exist('annotationList', 'var'); load(sprintf('%sannotationKev', FILEPATH)); end
titleList = {'t -1', 't', 't +1'};
for K = 4%1:44
    plotAnnot(removeQuantiles(imageList{K}), annotationList{K}(:, [2 1]), ...
            'titleList', titleList, 'figHandle', h, 'fill', false);
end
filename = '../figure/fig/ahsan_annotation_st.fig';
saveImage(filename, 'figHandle', gcf);