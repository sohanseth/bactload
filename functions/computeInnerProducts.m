function innerProducts = computeInnerProducts(img, centerList, boxWidthList)
% INNERPRODUCTS = COMPUTEINNERPRODUCTS(IMG, CENTERLIST, BOXWIDTHLIST) computes 
%   the pairwise inner products between image patches with resolutions (but
%   downsampled to BOXWIDTHLIST(1)) listed in array BOXWIDTHLIST of the image 
%   IMG (3D matrix of size M x N x T) and a set of image patches in CENTERLIST, a 
%   list of 2D cell arrays (|BOXWIDTHLIST| x T) of 2D matrices of dimension
%   BOXWIDTHLIST(1) x BOXWIDTHLIST(1). Each image patch is epsilon normalized
%   by its intensity. The image patches from IMG are downsampled to match 
%   CENTERLIST. INNERPRODUCTS is a 2D matrix of dimension M x N.
% 
% See ../tests/testComputeDistances.m
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

if size(img, 3) ~= size(centerList{1}, 2)
    error('Image and center dimension mismatch\n')
end

filterSize = boxWidthList(1);
innerProducts = zeros(size(img, 1), size(img, 2), size(centerList, 1));
for countCenter = 1:length(centerList)
    center = centerList{countCenter};
    C = 0;
    for boxWidth = boxWidthList
        floorBoxwidthBy2 = floor(boxWidth/2);
        [smallInd, largeInd] = convertIndices(boxWidthList(1), boxWidth);
        for countT = 1:size(img, 3)
            clear F; F = zeros(boxWidth, boxWidth);
            F(largeInd) = center{boxWidth == boxWidthList, countT}(smallInd); F = F(end:-1:1, end:-1:1);
            D = ones(size(F));
            
            I = double(img(:, :, countT));
            Cn = conv2(F, I); Cd = conv2(D, I);
            
            Cn = Cn(floorBoxwidthBy2+1:end-floorBoxwidthBy2, floorBoxwidthBy2+1:end-floorBoxwidthBy2);
            Cd = Cd(floorBoxwidthBy2+1:end-floorBoxwidthBy2, floorBoxwidthBy2+1:end-floorBoxwidthBy2);
            normalization = 'epsilon';
            switch normalization
                case 'histogram'
                    C = C + Cn ./ Cd;
                case 'epsilon'
                    C = C + Cn ./ (Cd + boxWidth^2);
            end
        end
    end
    innerProducts(:, :, countCenter) = C;
end