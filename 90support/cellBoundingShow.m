function cellBoundingShow(tBlob, ID, fig)
ColorSet = varycolor(30);

figure(fig);
hold on;
rectangle('Position', tBlob.BoundingBox, 'EdgeColor', ColorSet(ID, :), 'LineWidth', 4);
text(double(tBlob.BoundingBox(1)), double(tBlob.BoundingBox(2)), ['ID ' num2str(ID)], 'Color', ColorSet(ID, :), 'FontSize', 15);
hold off;