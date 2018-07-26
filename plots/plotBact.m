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
for countPatient = 6:12%1:12;
    if countPatient == 10
        continue
    end
    for countPrePost = 1:2
        if countPatient < 7
            file = matfile(sprintf('%sBAC2PatientFrame.mat', FILEPATH));
        else
            file = matfile(sprintf('%sBAC2PatientFrame_2.mat', FILEPATH));
        end
        tmp = file.videoList(countPatient, countPrePost); imgseq = tmp{1}; clear tmp;
        imgseq = removeOutside(removeQuantiles(imgseq));
        
        if exist(sprintf('%sip_%d_%d.mat', ANNOTATIONPATH, countPatient, countPrePost))
            load(sprintf('%sip_%d_%d', ANNOTATIONPATH, countPatient, countPrePost), 'bbs')
            if length(bbs) == size(imgseq, 3) - 1 % last frame not annotated due to temporal resolution
                warning('file exists.\n')
                continue;
            end
        end
        
        [imgseqprob, bbs, bactCount] = annotateVideo2(double(imgseq), param, 'threshList', threshList, 'filename', './tmp.mat');
        save(sprintf('%sip_%d_%d', ANNOTATIONPATH, countPatient, countPrePost), 'imgseqprob', 'bbs', 'bactCount', 'threshList', '-v7.3');
        
        writeVideo(sprintf('%sip_%d_%d.avi', ANNOTATIONPATH, countPatient, countPrePost), imgseq, bbs(:, 0.99 == threshList))
        
        !rm ./tmp.mat
    end
end

%% updated BAC2PatientFrame_bactCount
for countPatient = 1:6
    for countPrePost = 1:2
        load(sprintf('%sip_%d_%d', ANNOTATIONPATH, countPatient, countPrePost), 'bactCount');
        bactCountList{countPatient, countPrePost} = bactCount(:, 5);
    end
end
save(sprintf('%sBAC2PatientFrame_bactCount', ANNOTATIONPATH), 'bactCountList');