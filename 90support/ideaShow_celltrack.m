function varargout = ideaShow_celltrack(varargin)
% The fist argument for varargin is always method.
method = varargin{1};
switch method
    case 'bkgd_with_dynamics'
        [isRecord moviefile] = varin2out({varargin{2:3}});
        if isRecord
%             moviefile = fullfile(resVivoDataPath, [videoName{id}(1:end - 4) videoPostName]); 
            framerate = 5; aviobj = avifile(moviefile, 'fps', framerate', 'compression', 'none');
        end
        [fg srcdirImg filenamesImg fgVideo openClosingVideo combineImage STATSBatch cellID] = varin2out({varargin{4:end}});
        nframes = size(fg, ndims(fg));
        fig = figure(1);
        for t = 1 : nframes
            subplot(2, 3, 1);   imshow(uint8(imread([srcdirImg filenamesImg{t}])));
            title(['Origin Frame ' num2str(t)]);
            subplot(2, 3, 2); imshow(fg(:, :, t));
            title('bkgd Sub Res');
            subplot(2, 3, 3); imshow(fgVideo(:, :, t));
            title('Median Filter Res');
            subplot(2, 3, 4); imshow(combineImage(:, :, t));
            title('Combine Images');
            subplot(2, 3, 5); imshow(openClosingVideo(:, :, t));
            title('openClosing Images');
            %     subplot(2, 3, 5); vec = vecBatch{t};
            %     plot(vec(:, 1), vec(:, 2), 'ro');    axis([1 size(fg(:, :, 1), 2) 1 size(fg(:, :, 1), 1)]);
            %     title('Region Centroids Locations');
            subplot(2, 3, 6);   imshow(openClosingVideo(:, :, t));
            if cellID(t) > 0
                STATS = STATSBatch{t};
                hold on;
                for i = 1 : length(STATS)
                    tBlob = STATS(i);
                    cellBoundingShow(tBlob, cellID(t), fig);
                end
                title(['Cell ID ' num2str(cellID(t))]);
                hold off
            else
                title('NO cell detected');
            end
            if isRecord
                frame = getframe(gcf);
                aviobj = addframe(aviobj, frame);
            end
            pause(1/11);
        end
        if isRecord
            aviobj = close(aviobj);
        end
end