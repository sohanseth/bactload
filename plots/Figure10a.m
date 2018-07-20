flagPlot = true; flagSave = true;
FILEPATH = '../data/bact/';

%% Compare different methods
threshList = [0.99:-0.05:0.79, 0.999, 0.9999, 0.99999];
[~, ind] = sort(threshList);

load(sprintf('%simageKev_singleres_LRR', FILEPATH), 'contingency')
A = squeeze(sum(contingency, 3)); 
precision_allframes = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(2, 1, :)));
recall_allframes = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(1, 2, :)));
precision_allframes(precision_allframes == 0) = nan;
recall_allframes(recall_allframes == 0) = nan;

load(sprintf('%simageKev_singleres_currentframe_LRR', FILEPATH), 'contingency')
A = squeeze(sum(contingency, 3)); 
precision_currentframes = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(2, 1, :)));
recall_currentframes = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(1, 2, :)));
recall_currentframes(recall_currentframes == 0) = nan;
recall_currentframes(recall_currentframes == 0) = nan;

load(sprintf('%simageKev_ip_contingency', FILEPATH), 'contingency')
A = squeeze(sum(contingency, 3)); 
precision_multires_kmeans = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(2, 1, :)));
recall_multires_kmeans = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(1, 2, :)));
precision_multires_kmeans(precision_multires_kmeans == 0) = nan;
recall_multires_kmeans(recall_multires_kmeans == 0) = nan;

load(sprintf('%simageKev_ip_singleres_contingency', FILEPATH), 'contingency')
A = squeeze(sum(contingency, 3)); 
precision_singleres_kmeans = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(2, 1, :)));
recall_singleres_kmeans = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(1, 2, :)));
precision_singleres_kmeans(precision_singleres_kmeans == 0) = nan;
recall_singleres_kmeans(recall_singleres_kmeans == 0) = nan;

load(sprintf('%simageKev_multires_LRR', FILEPATH), 'contingency')
A = squeeze(sum(contingency, 3)); 
precision_multires = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(2, 1, :)));
recall_multires = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(1, 2, :)));
precision_multires(precision_multires == 0) = nan;
recall_multires(recall_multires == 0) = nan;

load(sprintf('%sBacteriaCodeAhsan', FILEPATH), 'precision_unsup', 'recall_unsup')

h = myfigure([3 3]);
hold on

plot(recall_unsup, precision_unsup, '.-.')
plot(recall_currentframes(ind), precision_currentframes(ind), '--');
plot(recall_allframes(ind), precision_allframes(ind), '--'); 
plot(recall_multires(ind), precision_multires(ind), '--');
plot(recall_singleres_kmeans(ind), precision_singleres_kmeans(ind), '-');
plot(recall_multires_kmeans(ind), precision_multires_kmeans(ind), '-');

mylegend('unsupervised approach', ...
    'single res, current frame, LR', ...
    'single res, three frames, LR', ...
    'two res, three frames, LR', ...
    'single res, three frames, RBF', ...
    'three res, three frames, RBF');
set(gca, 'xlim', [0 1], 'ylim', [0 1]); box on
myxylabel('Recall', 'Precision', '')
filename = '../figures/fig/precRecMethods';
saveImage(filename, 'figHandle', h);