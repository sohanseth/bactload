%% Compare with Kev's annotation
load ../data/cell/ip_combine.mat objCountList filesList
ind = cellfun(@isempty, objCountList)';
labelDet = [cellfun(@(x)(str2num(x(1:3))), filesList(~ind))', ...
    cellfun(@(x)(str2num(x(5))), filesList(~ind))', ...
    cellfun(@(x)(median(x(:,2))),objCountList(~ind))'];
load ../data/cell/KevAnnotation.mat
labelKev(isnan(labelKev(:, 3)), :) = [];
labelKev(labelKev(:, 3) == 3, 3) = 2; % set 2++ to 2
I = bsxfun(@eq, labelKev(:, 1), labelDet(:, 1)') .* bsxfun(@eq, labelKev(:, 2), labelDet(:, 2)');
[R, C] = find(I); 
labelKev = labelKev(R, :);
TMP = sortrows([labelDet(C, 3), labelKev(:, 3)], 2);
for count = 0:3
    T{count+1} = TMP(TMP(:, 2) == count, 1);
end
myfigure([4 2])
myboxplot(T)
set(gca, 'xticklabel', {'no cell', 'some cells', 'very cellular'})
ylabel('median cell count')
filename = sprintf('../figures/fig/compKevDet');
saveImage(filename, 'figHandle', gcf);