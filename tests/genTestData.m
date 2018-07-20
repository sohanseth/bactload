clear all
load ../data/TTTTTT/annotationSohan.mat annotationList
annotationList = annotationList(1:20);
save ../data/annotationList annotationList

clear all
load ../data/TTTTTT/imageList.mat imageList
imageList = imageList(1:20);

load ../data/TTTTTT/imageList.mat frameListUnwrap
patientList = frameListUnwrap(1:20, 1);
save ../data/imageList imageList patientList

clear all
imgseq = rand(500, 500, 10);
save ../data/1.mat imgseq