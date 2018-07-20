flagPlot = true; flagSave = true;
FILEPATH = '../data/bact/';

%% Figure 5a
titleList = {'t -1', 't', 't +1'};
if flagPlot
    if ~exist('imageList', 'var'); load(sprintf('%simageKev', FILEPATH)); end
    if ~exist('boxSeqLabel', 'var') || ~exist('boxLoc', 'var')
        load(sprintf('%simageKev_multires', FILEPATH), 'boxSeqLabel', 'boxLoc')
    end
    boxWidthList = [9, 27, 45];
    h = myfigure(6 * [1, 1/3]);
    for K = 4
        indNeg = find(boxSeqLabel{K}(:, 1) == 0);
        indPos = find(boxSeqLabel{K}(:, 1) == 1);        
        ind = [indNeg(10); indPos(1)];
        plotBox(removeQuantiles(imageList{K}), boxLoc{K}(ind, :), boxSeqLabel{K}(ind, 1), ...
            'titleList', titleList, 'figHandle', h, 'boxWidthList', boxWidthList);
        pause(1);
    end
    filename = '../figures/fig/example_st_multires.fig';
    if flagSave; saveImage(filename, 'figHandle', h); end
end

%% Figure 5b and 5c
yLabelList = {'9\times 9', '27\times 27', '45\times 45'};
if flagPlot
    for frameType = {'neg', 'pos'}
        tmp = {};
        switch frameType{1}
            case 'pos'
                FRAMEID = ind(2);
            case 'neg'
                FRAMEID = ind(1);
        end
        if ~exist('boxSeq', 'var'); load(sprintf('%simageKev_multires', FILEPATH), 'boxSeq'); end
        if ~exist('annotationList', 'var'); load(sprintf('%sannotationKev', FILEPATH)); end
        colormapGreen = [zeros(128, 1), (1:128)'/128, zeros(128, 1)];
        h = myfigure([3 3] * 0.7);
        for count = 4%:144
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