function cellBoundingShow(tBlob, ID, fig, varargin)
% function cellBoundingShow(tBlob, ID, fig)
if nargin > 3
    columnOffSet = varargin{1};
end

ColorSet = varycolor(200);


figure(fig);
hold on;
% columnOffSet = 
% rectangle('Position', tBlob.BoundingBox, 'EdgeColor', ColorSet(ID, :), 'LineWidth', 4);
% text(double(tBlob.BoundingBox(1)), double(tBlob.BoundingBox(2)), ['ID ' num2str(ID)], 'Color', ColorSet(ID, :), 'FontSize', 15);
if nargin > 3
    rectangle('Position', [tBlob.BoundingBox(1) + columnOffSet tBlob.BoundingBox(2:end)], ...
        'EdgeColor', ColorSet(ID, :), 'LineWidth', 4);
    text(double(tBlob.BoundingBox(1) + columnOffSet), double(tBlob.BoundingBox(2)), ['ID ' num2str(ID)], 'Color', ColorSet(ID, :), 'FontSize', 15);
end


hold off;