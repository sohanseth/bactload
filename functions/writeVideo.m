function writeVideo(filename, imgseq, annotList)
% WRITEVIDEO writes a sequence of images and annotations ti a video file.
%   WRITEVIDEO(FILENAME, IMGSEQ, ANNOTLIST) writes a sequence of
%       images in the 3D matrix IMGSEQ and annotations in the cell array of
%       2D vectors ANNOTATIONLIST in a video file FILENAME.
% 
% See ../plots/plotCell.m
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

if strcmp(filename(end-3:end), '.mp4') || strcmp(filename(end-3:end), '.m4v') 
    outputVideo = VideoWriter(filename, 'MPEG-4'); 
else
    outputVideo = VideoWriter(filename); 
end
outputVideo.FrameRate = 12;
open(outputVideo)

h = myfigure([4 4]);
for countFrame = 2:size(annotList, 1) % size(imgseq, 3) - 1
    handlesList{countFrame} = ...
        plotAnnot(removeQuantiles(removeOutside(imgseq(:, :, countFrame))), annotList{countFrame}, 'figHandle', h);
    
    writeVideo(outputVideo, getframe(handlesList{countFrame}))
end
close(outputVideo);
close(h)