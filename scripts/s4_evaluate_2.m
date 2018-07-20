% This script combines different cross validation files if they are run
% separately. It assumes that the individual files are stored as 
% ../data/imageList_multires_kmeans_LRR_ip_#.mat and store the combined file
% as ../data/imageList_multires_kmeans_LRR_ip.mat

flagSave = true;
imageListFile = '../data/imageList';
imgseqprob_tmp = {};
bbs_tmp = {};
bactCount_tmp = [];
contingency_tmp = [];
for countCV = 1:5
    load(sprintf('%s_multires_kmeans_LRR_ip_%d', imageListFile, countCV), 'imgseqprob', 'bbs', 'bactCount', 'contingency')
    ind = cellfun(@(x)(~isempty(x)), imgseqprob);
    imgseqprob_tmp(ind) = imgseqprob(ind);
    bbs_tmp(ind, :) = bbs(ind, :); 
    bactCount_tmp(ind) = bactCount(ind);
    contingency_tmp(:, :, ind, :) = contingency(:, :, ind, :);
end
imgseqprob = imgseqprob_tmp;
bbs = bbs_tmp;
bactCount = bactCount_tmp;
contingency = contingency_tmp;
if flagSave
    save(sprintf('%s_multires_kmeans_LRR_ip', imageListFile), 'imgseqprob', 'bbs', 'bactCount', 'contingency', '-v7.3')
end