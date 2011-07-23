function playTrackingBlobs(obj)
%PLAYTRACKINGBLOBS Summary of this function goes here
%   Detailed explanation goes here
database = videoBlobDatabase(obj.DB, obj.fg.nFrame);
database.databaseSortByFrame;
rectShow = figure;
for t = 1 : obj.fg.nFrame
    I = uint8(obj.fg.Data(:, :, t));
    imshow(I, 'border', 'tight');
    for j = 1 : length(database.DBbyFrame{t})
        tBlob = database.DBbyFrame{t}(j);        
        cellBoundingShow(tBlob, tBlob.ID, rectShow);
    end
    disp(['Frame ' num2str(t)]);
    pause(1/22);
end

