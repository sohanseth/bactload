rng default

% Create a sequence of K images of dimensions I and J each. I = J for convenience.
I = 32; J = 32; K = 5;
img = rand(I, J, K);

% Create a list of annotations for where an object is in the middle frame of the sequence of images. 
% The image has M objects randomly placed on the I x I grid.
M = 5;
imgannot = randi(I, M, 2);

% imgannot may contain null array when no annotation is available
% imgannot = [];

% list of widths of image patches to be extracted
boxWidthList = [3, 9];

% location of boxes to be extracted
boxLoc = [imgannot; [10, 10]];
[boxSeq, boxSeqLabel, boxLoc] = extractBoxesSTFast(img, imgannot, boxLoc, boxWidthList);

size(boxSeq), size(boxLoc)
% boxSeq is a cell array of dimension T x 2 given two box width sizes, boxLoc holds the location of boxes extracted and hence T x 2
% T is number of number of patches extracted. There are 5 patches since the patch around annotation [2, 19] is out of bound (2 < 3)
size(boxSeq{1, 1})
size(boxSeq{1, 2})
% each cell of boxSeq contains a 3 x 3 x K dimensional matrix since patches are downsampled to the lowest box width
size(boxSeqLabel)
% boxSeqLabel is T x 2, each column belongs to one box width size, and contains the number of objects in the corresponding patch