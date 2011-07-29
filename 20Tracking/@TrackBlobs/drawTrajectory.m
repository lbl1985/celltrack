function drawTrajectory(obj, id, t, figHandle)
    ColorSet = varycolor(200);
    figure(figHandle);  hold on;
    tmpdb = obj.DB{id};
    index = tmpdb.timeIDX <= t;
    plot(tmpdb.Centroid(index, 1), tmpdb.Centroid(index, 2), '-', 'Color', ...
        ColorSet(id, :), 'LineWidth', 3);
    hold off;
end
    


