function drawTrajectoryWithOrig(obj, id, t, figHandle)
    ColorSet = varycolor(200);
    figure(figHandle);  hold on;
    tmpdb = obj.DB{id};
    index = tmpdb.timeIDX <= t;
    
    columnOffSet = obj.fg.siz(2) + 10;
    columnOffSet = ones(sum(index), 1) * columnOffSet;
%     plot([tmpdb.Centroid(index, 1); tmpdb.Centroid(index, 1)+ columnOffSet], ...
%         repmat(tmpdb.Centroid(index, 2), 2, 1), ...
%         '-', 'Color', ColorSet(id, :), 'LineWidth', 3);
%     plot(tmpdb.Centroid(index, 1), tmpdb.Centroid(index, 2), '-', 'Color', ...
%         ColorSet(id, :), 'LineWidth', 3);
    plot(tmpdb.Centroid(index, 1) + columnOffSet, tmpdb.Centroid(index, 2) , '-', 'Color', ...
        ColorSet(id, :), 'LineWidth', 3);
    hold off;
end