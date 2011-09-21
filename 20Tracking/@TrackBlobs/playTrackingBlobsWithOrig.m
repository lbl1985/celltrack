function playTrackingBlobsWithOrig(obj, origVideo)
%PLAYTRACKINGBLOBS Summary of this function goes here
%   Detailed explanation goes here
% database = videoBlobDatabase(obj.DB, obj.fg.nFrame);
% database.databaseSortByFrame;
rectShow = figure;
assert(isequal(size(origVideo), size(obj.fg.Data)), 'origVideo should be the same size with fg video.');

for t = 1 : obj.fg.nFrame
    I = uint8(obj.fg.Data(:, :, t));
    I(I>0.01) = 255;
    I(I<=0.01) = 0;
    combinedI = [origVideo(:, :, t) ones(size(origVideo, 1), 10) I];
    columnOffSet = size(origVideo, 2) + 10;
%     I = I > 0.01;
    imshow(combinedI, 'border', 'tight');
    for j = 1 : length(obj.DBbyFrame{t})
        tBlob = obj.DBbyFrame{t}(j);        
        cellBoundingShow(tBlob, tBlob.ID, rectShow, columnOffSet);
        obj.drawTrajectoryWithOrig(tBlob.ID, t, rectShow);
    end
%     if t == 147 || t == 150 || t == 153 || t == 156
%         saveas(rectShow, ['f' num2str(t) '.jpg']);
%     end
    writenum2(t);
    pause(1/22);
end