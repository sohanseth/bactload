flagPlot = true; flagSave = true;
FILEPATH = '../data/bact/';

%%
load(sprintf('%sBAC2PatientFrame_bactCount.mat', FILEPATH))
bactCountList = bactCountList([1,3,4,2,5,6], :);
myfigure([6 2]);
plotPrePost(cellfun(@(x)(x(:, 1)), bactCountList, 'UniformOutput', false), 'divExp', [3 3], ...
    'yLabel', 'Count over all frames')
filename = '../figures/fig/patientPrePostSubstance';
saveImage(filename, 'figHandle', gcf, 'fontsize', 8);

load(sprintf('%sBAC2PatientFrame_2_bactCount.mat', FILEPATH))
bactCountList = bactCountList([8,9,12,7,11], :);
myfigure([5 2]);
plotPrePost(cellfun(@(x)(x(:, 1)), bactCountList, 'UniformOutput', false), 'divExp', [3 2], ...
    'yLabel', 'Count over all frames')
filename = '../figures/fig/patientPrePostSubstance_2';
saveImage(filename, 'figHandle', gcf, 'fontsize', 8);