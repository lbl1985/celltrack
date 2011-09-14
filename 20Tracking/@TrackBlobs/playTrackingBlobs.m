function playTrackingBlobs(obj)
%PLAYTRACKINGBLOBS Summary of this function goes here
%   Detailed explanation goes here
% database = videoBlobDatabase(obj.DB, obj.fg.nFrame);
% database.databaseSortByFrame;
rectShow = figure;
for t = 1 : obj.fg.nFrame
    I = uint8(obj.fg.Data(:, :, t));
    I = I > 0.01;
    imshow(I, 'border', 'tight');
    for j = 1 : length(obj.DBbyFrame{t})
        tBlob = obj.DBbyFrame{t}(j);        
        cellBoundingShow(tBlob, tBlob.ID, rectShow);
        obj.drawTrajectory(tBlob.ID, t, rectShow);
    end
    writenum2(t);
    pause(1/22);
end

