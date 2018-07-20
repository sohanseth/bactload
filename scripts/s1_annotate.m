% This script opens an interactive annotation session to annotate objects
% manually. It assumes that the images are stored at ../data/imageList.mat. 
% This file contains a cell array of 3D matrices imageList where each 3D
% matrix is a sequence of images. The manual annotations are stored at 
% ../data/annotationList.mat which contains a cell array of 2D matrices
% that contains the locations of the objects.

close all
if ~exist('imageList')
    load ../data/imageList imageList
end
annotationFile = '../data/annotationList.mat';
annotate(imageList, annotationFile)