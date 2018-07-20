%%
FILEPATH = '/run/media/sseth/SeagateExt/Cleveland/Cleveland_3_1/imageList';
load(sprintf('%s_multires_kmeans_LRR_ip', FILEPATH), 'contingency')
A = squeeze(sum(contingency, 3)); 
precision_threeres_currentframe = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(2, 1, :)));
recall_threeres_currentframe = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(1, 2, :)));
precision_threeres_currentframe(precision_threeres_currentframe == 0) = nan;
recall_threeres_currentframe(recall_threeres_currentframe == 0) = nan;

FILEPATH = '/run/media/sseth/SeagateExt/Cleveland/Cleveland_4_1/imageList';
load(sprintf('%s_multires_kmeans_LRR_ip', FILEPATH), 'contingency')
A = squeeze(sum(contingency, 3)); 
precision_fourres_currentframe = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(2, 1, :)));
recall_fourres_currentframe = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(1, 2, :)));
precision_fourres_currentframe(precision_fourres_currentframe == 0) = nan;
recall_fourres_currentframe(recall_fourres_currentframe == 0) = nan;

FILEPATH = '/run/media/sseth/SeagateExt/Cleveland/Cleveland_4/imageList';
load(sprintf('%s_multires_kmeans_LRR_ip', FILEPATH), 'contingency')
A = squeeze(sum(contingency, 3));
precision_fourres = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(2, 1, :)));
recall_fourres = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(1, 2, :)));
precision_fourres(precision_fourres == 0) = nan;
recall_fourres(recall_fourres == 0) = nan;

FILEPATH = '/run/media/sseth/SeagateExt/Cleveland/Cleveland_3/imageList';
load(sprintf('%s_kmeans_LRR_ip', FILEPATH), 'contingency')
A = squeeze(sum(contingency, 3)); 
precision_threeres = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(2, 1, :)));
recall_threeres = squeeze(A(2, 2, :) ./ (A(2, 2, :) + A(1, 2, :)));
precision_threeres(precision_threeres == 0) = nan;
recall_threeres(recall_threeres == 0) = nan;

myfigure([3 3])
hold on
plot(recall_threeres_currentframe, fixPrecision(precision_threeres_currentframe), '--'); 
plot(recall_fourres_currentframe, fixPrecision(precision_fourres_currentframe), '--'); 
plot(recall_threeres, fixPrecision(precision_threeres), '-'); 
plot(recall_fourres, fixPrecision(precision_fourres), '-');
hold off

mylegend('three res, single frame, RBF', ...
    'four res, single frame, RBF', ...
    'three res, three frames, RBF', ...
    'four res, three frames, RBF');
set(gca, 'xlim', [0 1], 'ylim', [0 1]); box on
myxylabel('Recall', 'Precision', '')
filename = '../figures/fig/precRecMethods';
saveImage(filename, 'figHandle', gcf);