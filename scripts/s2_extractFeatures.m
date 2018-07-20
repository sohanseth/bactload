% This script extracts spatio-temportal features (image patches) and 
% stores the result as a design matrix and response vector. It assumes that
% the image sequences and respective annotations are stored in
% ../data/imageList.mat and ../data/annotationList.mat respectively. The
% results are stored at ../data/imageList_multires_XY.mat the design matrix
% X, outcome Y, cross-validation splits CVIndices (a cell array of
% structures). It also contains boxInd and L which records the image id and
% (x,y) location of the image patch in imageList. An intermediate file is
% created as ../data/imageList_multires.mat which stores the extracted
% image patches in a cell array boxSeq and corresponding labels in boxSeqLabel. 

flagSave = true; % If true then .mat files are saved
flagTemporal = true; % If true then temporal pathces are extracted
imageListFile = '../data/imageList';

%% Feature extraction 
% Extract image patches around positive and negative and augmentation
if ~exist(sprintf('%s_multires.mat', imageListFile), 'file')
    boxWidthList = [9, 27, 45, 63];
    rng default
    if ~exist('imageList', 'var'); load(imageListFile); end
    if ~exist('annotationList', 'var'); load ../data/annotationList annotationList; end
    
    clear boxSeq boxSeqLabel boxLoc
    for count = 1:length(imageList)
        fprintf('%d\n', count)
        
        [X, Y] = meshgrid(1:15:size(imageList{count}, 1), 1:15:size(imageList{count}, 2));
        if ~isempty(annotationList{count})
            imgannot = round(annotationList{count}(:, [2 1]));
        else
            imgannot = [];
            % boxSeq{count} = []; boxSeqLabel{count} = []; boxLoc{count} = [];
            % continue;
        end
        if flagTemporal
            img = double(imageList{count});
        else
            img = double(imageList{count}(:, :, ceil(end/2)));
        end
        [boxSeq{count}, boxSeqLabel{count}, boxLoc{count}] = ...
            extractBoxesSTFast(img, imgannot, ...
            [[X(:), Y(:)]; imgannot], boxWidthList);
    end
    if flagSave
        save(sprintf('%s_multires', imageListFile), 'boxSeq', 'boxSeqLabel', 'boxLoc', 'boxWidthList', '-v7.3')
    end
    fprintf('Feature extraction done!\n');
else
    fprintf('Feature file exists!\n');
end

%%
% Augment images
if ~exist(sprintf('%s_multires_XY.mat', imageListFile), 'file')
    if ~exist('boxSeq', 'var')
        load(sprintf('%s_multires', imageListFile), 'boxSeq', 'boxSeqLabel', 'boxLoc')
    end
    for count = 1:length(boxSeq)
        if ~isempty(boxSeq{count})
            boxSeq{count} = [boxSeq{count}; ...
                cellfun(@(x)(x(end:-1:1, end:-1:1, 1:size(x,3))), boxSeq{count}, 'UniformOutput', false); ...
                cellfun(@(x)(x(end:-1:1, :, 1:size(x,3))), boxSeq{count}, 'UniformOutput', false); ...
                cellfun(@(x)(x(:, end:-1:1, 1:size(x,3))), boxSeq{count}, 'UniformOutput', false)];
            boxSeqLabel{count} = [boxSeqLabel{count}; boxSeqLabel{count}; boxSeqLabel{count}; boxSeqLabel{count}];
            boxLoc{count} = [boxLoc{count}; boxLoc{count}; boxLoc{count}; boxLoc{count}];
        end
    end
    fprintf('Augmentation done!\n');
    
    % Create data matrix
    load ../data/imageList patientList % for leave patient out CV
    X = []; L = []; clear boxInd
    for count = 1:length(boxSeq)
        X = [X; boxSeq{count}];
        L = [L; boxLoc{count}];
        boxInd{count} = count * ones(size(boxSeq{count}, 1), 1);
        boxSeq{count} = [];
    end
    boxInd = cell2mat(boxInd');
    
    X = cell2mat(cellfun(@(x)(x(:)'), X, 'UniformOutput', false));
    Y = cell2mat(boxSeqLabel'); Y = Y(:, 1); Y(Y > 1) = 1;
    
    % Cross validation
    rng default
    CVIndices = generateCVIndices(max(patientList), 5);
    for count = 1:5
        CVIndices{count}.train = any(bsxfun(@eq, patientList(boxInd, 1), find(CVIndices{count}.train)), 2);
        CVIndices{count}.test = any(bsxfun(@eq, patientList(boxInd, 1), find(CVIndices{count}.test)), 2);
    end
    
    clear boxSeq boxSeqLabel boxLoc
    if flagSave
        save(sprintf('%s_multires_XY', imageListFile), 'boxInd', 'X', 'Y', 'CVIndices', 'L', '-v7.3')
    end
end