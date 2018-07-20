% The script runs the classifier on test videos, and find annotations. It
% assumes that the classifier is stored as
% ../data/imageList_multires_kmeans_#.mat and ../data/imageList_multires_kmeans_LRR_#.mat
% and the list of test videos are given in filesList and the files are available 
% at DATAPATH. The annotations are stored as a cell array bbsList and the 
% respective object counts are stored as a cell array objCountList in 
% ../data/ip_combine.mat. Temporary results are stored at OUTPUTPATH.

FILEPATH = '../data/';
threshList = [0.7 0.8 0.9 0.95 0.99 0.999 0.9999 0.99999 0.999999 0.9999999 0.99999999];
countCV = 1;
load(sprintf('%simageList_multires', FILEPATH), 'boxWidthList')
load(sprintf('%simageList_multires_kmeans_%d', FILEPATH, countCV), 'centersPos', 'centersNeg')
load(sprintf('%simageList_multires_kmeans_LRR_%d', FILEPATH, countCV), 'hyp', 'sigma')

centers = [centersPos{countCV}; centersNeg{countCV}];
for countCent = 1:size(centers, 1)
    centersList{countCent} = vec2patch(centers(countCent, :), boxWidthList, true);
end

%% Annotate test FCFM videos
filesList{1} = '1'; % List of video files
DATAPATH = '../data/';
OUTPUTPATH = '../data/';
for countPatient = 1
    load(sprintf('%s%s', DATAPATH, filesList{countPatient}));
    imgseq = removeOutside(removeQuantiles(imgseq));
    
    outputfilename = sprintf('%sip_%s', OUTPUTPATH, filesList{countPatient});
    param.centersList = centersList;
    param.sigma = sigma;
    param.weights = hyp{countCV}.w;
    param.bias = hyp{countCV}.b;
    [imgseqprob, bbs, bactCount] = annotateVideo2(double(imgseq), param, 'threshList', threshList, 'filename', outputfilename);
end
save ../data/ip_combine objCountList filesList bbsList threshList