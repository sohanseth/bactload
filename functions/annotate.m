function annotate(imageList, annotationFile)
% ANNOTATE is an interactive tool to annotate objects in an image
% ANNOTATE(IMAGELIST, ANNOTATIONFILE) opens an interactive window to 
%   annotate images stored in cell array or 3D matrices IMAGELIST and
%   stores the annotations in a cell array of 2D (x,y) locations matrices
%   in the annotation file ANNOTATIONFILE. The third dimension in the image
%   is time, i.e, (t-1, t, t+1). Default annotation file is ./annotationList
%
% Author: Sohan Seth (sseth@inf.ed.ac.uk)

if nargin == 1
    annotationFile = 'annotationList';
end

colormapGreen = [zeros(128, 1), (1:128)'/128, zeros(128, 1)];

if exist(annotationFile)
    load(annotationFile);
else
    annotationList = []; countImage = 1;
end

if isempty(annotationList)
    annotationList = cell(size(imageList));
end

[YLim, XLim] = size(imageList{1}(:, :, 1));
myfigure([XLim + 0 YLim + 0] / 80)

while(1)
    whichFrame = 2;
    while(1)
        img = imageList{countImage}(:, :, whichFrame);
        % img = removeQuantiles(removeOutside(imageList{countImage}(:, :, whichFrame)));
        
        switch whichFrame
            case {1, 3}
                clf;
                imagesc(img)
                colormap(colormapGreen)
                set(gca, 'xlim', [-0, XLim + 0], 'ylim', [-0, YLim], 'xtick', [], 'ytick', [], 'ydir', 'normal')
            case 2
                imagesc(img)
                colormap(colormapGreen)
                set(gca, 'xlim', [-0, XLim + 0], 'ylim', [-0, YLim], 'xtick', [], 'ytick', [], 'ydir', 'normal')
                hold on
                for count = 1:size(annotationList{countImage}, 1)
                    plot(annotationList{countImage}(count, 1), ...
                        annotationList{countImage}(count, 2), 'ro', ...
                        'markersize', 5);
                end
                hold off
        end
        title(sprintf('Frame %d/3. ANNOTATE FRAME 2.', whichFrame))
        
        text(XLim / 2, -40, ...
            sprintf('Image %3d/%3d. Annotated %2d so far. \nTo annotate an object, click on it. To remove an annotation click on it again.\nTo toggle between frames use left-right arrow keys.\nTo move to next image, press n. To move to previous image, press p. To exit press x.', ...
            countImage, length(imageList), sum(cellfun(@isempty, annotationList) ~= 1)), ...
            'horizontalalignment', 'center')
        box on
        
        [x, y, button] = ginput(1);
        % if button ~= 1; fprintf('button recorded %c\n', button); end
        
        % remove annotation if within 3 pixels of previous annotations
        if ~isempty(annotationList{countImage})
            ind = all(abs(bsxfun(@minus, annotationList{countImage}, [x, y])) < 3, 2);
            if any(ind)
                annotationList{countImage}(ind, :) = [];
                save(annotationFile, 'annotationList', 'countImage')
                continue
            end
        end
        
        % left arrow
        if button == 28
            if whichFrame == 1
                warning('first frame'); beep;
            else
                whichFramePrev = whichFrame;
                whichFrame = whichFrame - 1;
            end
        end
        
        % right arrow
        if button == 29
            if whichFrame == size(imageList{countImage}, 3)
                warning('last frame'); beep;
            else
                whichFramePrev = whichFrame;
                whichFrame = whichFrame + 1;
            end
        end
        
        % key 'n'
        if button == 110
            countImage = countImage + 1;
            if countImage == length(imageList) + 1
                warning('last image'); beep
                countImage = countImage - 1;                
            end
            save(annotationFile, 'annotationList', 'countImage')
            whichFrame = 2;
            break
        end
        
        % key 'p'
        if button == 112
            countImage = countImage - 1;
            if countImage == 0
                warning('first image'); beep
                countImage = countImage + 1;                
            end
            save(annotationFile, 'annotationList', 'countImage')
            whichFrame = 2;
        end
        
        % key 'x'
        if button == 120
            close all
            return
        end
        
        % key 's'
        if button == 115
            filename = sprintf('../figure/fig/annotateBacteria_%d', whichFrame);
            saveas(gcf, filename); saveImage(filename)
        end
        
        % click
        if button == 1
            if (x < XLim) & (x > 0) & (y < YLim) & (y > 0)
                if whichFrame ~= 2
                    warning('wrong frame'); beep
                else
                    annotationList{countImage} = [annotationList{countImage}; ([x, y])]; % round
                    save(annotationFile, 'annotationList', 'countImage')
                end                
            end
        end
        
    end
end
close all