function img = removeQuantiles(img)
% REMOVEQUANTILES replaces values smaller (larger) than lower (upper)
%  quantiles with the respective quantiles given an image IMG. The lowest
%  value of the image is set to 0.
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

lowerQuantile = zeros(1, size(img, 3));
upperQuantile = zeros(1, size(img, 3));
for countFrame = 1:size(img, 3)
    I = img(:, :, countFrame);
    lowerQuantile(countFrame) = quantile(I(:), 0.01);
    upperQuantile(countFrame) = quantile(I(:), 0.99);
    I(I <= lowerQuantile(countFrame)) = lowerQuantile(countFrame);
    I(I >= upperQuantile(countFrame)) = upperQuantile(countFrame);
    img(:, :, countFrame) = I - min(I(:));
end