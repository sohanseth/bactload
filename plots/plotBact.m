%% Generate annotated videos
ANNOTATIONPATH = '/run/media/sseth/SeagateExt/BAC2VideosAnnotated/';
FILEPATH = '/run/media/sseth/SeagateExt/proteus/WP4 - Signal Processing and Data Inference/trunk/Bacteria/data/';

load(sprintf('%s/imageKev_multires_kmeans_1.mat', FILEPATH));
load(sprintf('%s/imageKev_multires_kmeans_LRR1.mat', FILEPATH));

threshList = [0.7 0.8 0.9 0.95 0.99 0.999 0.9999 0.99999 0.999999 0.9999999 0.99999999];
boxWidthList = [9, 27, 45];
centers = [centersPos{1}; centersNeg{1}];
for countCent = 1:size(centers, 1)
    centersList{countCent} = vec2patch(centers(countCent, :), boxWidthList, true);
end
param.centersList = centersList;
param.sigma = sigma;
param.weights = hyp{1}.w;
param.bias = hyp{1}.b;

%%
for countPatient = 1:12; 
    for countPrePost = 1:2;
        if countPatient < 7
            file = matfile(sprintf('%sBAC2PatientFrame.mat', FILEPATH));
        else
            file = matfile(sprintf('%sBAC2PatientFrame_2.mat', FILEPATH));
        end
        tmp = file.videoList(countPatient, countPrePost); imgseq = tmp{1}; clear tmp;
        [imgseqprob, bbs, bactCount] = annotateVideo2(double(imgseq), param, 'threshList', threshList, 'filename', './tmp.mat');
        save(sprintf('../data/ip_%d_%d', FILEPATH, countPatient, countPrePost), 'objCountList', 'filesList', 'bbsList', 'threshList')
        
        writeVideo([ANNOTATIONPATH, file{1}(1:end-4), '.avi'], imgseq, bbsList)
    end
end