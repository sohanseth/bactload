%% Generate annotated videos
flagVideo = true;
if ~exist('bbsList', 'var'); load ../data/cell/ip_combine.mat; end
VIDEOPATH = '/run/media/sseth/SeagateExt/Cleveland/matlabFiles/';
ANNOTATIONPATH = '/run/media/sseth/SeagateExt/Cleveland/matlabFilesAnnotated/';
for file = filesList
    count = find(strcmp(file, filesList));
    load(sprintf('%s%s', VIDEOPATH, file{1}))
    imgseq = removeOutside(removeQuantiles(imgseq));
    writeVideo([ANNOTATIONPATH, file{1}(1:end-4), '.avi'], imgseq, bbsList{count}(:, 3))
end