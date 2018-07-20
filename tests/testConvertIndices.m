S = reshape(1:9, 3, 3);
[SI, LI] = convertIndices(3, 9);

for R = 1:size(SI, 1)
    L(LI(R, :)) = S(SI(R, :));
end