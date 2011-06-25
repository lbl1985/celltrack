function varargout = ideaShow_celltrack(varargin)
% The fist argument for varargin is always method.
method = varargin{1};
switch method
    case 'bkgd_with_dynamics'
        [fg srcdirImg filenamesImg fgVideo combineImage STATSBatch cellID] = varin2out(varargin{2:end});
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
            %     subplot(2, 3, 5); vec = vecBatch{t};
            %     plot(vec(:, 1), vec(:, 2), 'ro');    axis([1 size(fg(:, :, 1), 2) 1 size(fg(:, :, 1), 1)]);
            %     title('Region Centroids Locations');
            subplot(2, 3, 6);   imshow(fgVideo(:, :, t));
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
            pause(1/11);
        end
end