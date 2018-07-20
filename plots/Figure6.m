flagPlot = true; flagSave = true;
FILEPATH = '../data/cell/imageList';

%% Figure 6a: annotation
yLabelList = {'9\times 9', '27\times 27', '45\times 45', '63\times 63'};
titleList = {'t -1', 't', 't +1'};
load(sprintf('%s_multires', FILEPATH), 'boxWidthList')

if flagPlot
    if ~exist('imageList', 'var'); load(sprintf('%s', FILEPATH)); end
    if ~exist('boxSeqLabel', 'var') || ~exist('boxLoc', 'var')
        load(sprintf('%s_multires', FILEPATH), 'boxSeqLabel', 'boxLoc')
    end
    h = myfigure(6 * [1, 1/3]);
    for K = 100
        indNeg = find(boxSeqLabel{K}(:, 1) == 0);
        indPos = find(boxSeqLabel{K}(:, 1) == 1);        
        ind = [indNeg(700); indPos(6)];
        plotBox(imageList{K}, boxLoc{K}(ind, :), boxSeqLabel{K}(ind, 1), ...
            'titleList', titleList, 'figHandle', h, 'boxWidthList', boxWidthList);
        pause(1);
    end
    filename = '../figures/fig/example_st_multires.fig';
    if flagSave; saveImage(filename, 'figHandle', h); end
end

%% Figure 6b and 6c: positive and negative image patch
if flagPlot
    for frameType = {'neg', 'pos'}
        tmp = {};
        % frameType = 'neg';
        switch frameType{1}
            case 'pos'
                FRAMEID = ind(2);
            case 'neg'
                FRAMEID = ind(1);
        end
        if ~exist('boxSeq', 'var'); load(sprintf('%s_multires', FILEPATH), 'boxSeq'); end
        if ~exist('annotationList', 'var'); load ../data/cell/annotationList; end
        h = myfigure([3 4] * 0.7);
        colormapGreen = [zeros(128, 1), (1:128)'/128, zeros(128, 1)];
        for count = 100
            if ~isempty(annotationList{count})
                for countFrame = FRAMEID % 1:length(boxSeq{count})
                    for boxWidth = boxWidthList
                        for t = 1:3
                            tmp{boxWidth == boxWidthList, t} = ...
                                boxSeq{count}{countFrame, boxWidth == boxWidthList}(:, :, t)';
                            % text(1, 1, num2str(boxSeqLabel{count}(countFrame, boxWidth == boxWidthList)), 'color', [1 1 1]);
                        end
                    end
                    plotDictionary(tmp, 'normalize', true, 'colormap', colormapGreen, ...
                        'titleList', titleList, 'yLabelList', yLabelList, 'figHandle', h);
                end
            end
        end
        switch frameType{1}
            case 'pos'
                filename = '../figures/fig/example_st_multires_pos.fig';
            case 'neg'
                filename = '../figures/fig/example_st_multires_neg.fig';
        end
        if flagSave; saveImage(filename, 'figHandle', h); end
    end
end