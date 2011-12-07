function saveTrackingBlobsWithOrig( obj, origVideo )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

rectShow = figure;

saver1 = videoSaver(obj.videoName, 11);
saver1.fig = rectShow;

    for t = 1 : obj.fg.nFrame
        I = uint8(obj.fg.Data(:, :, t));
        I(I>0.01) = 255;
        I(I<=0.01) = 0;
        combinedI = [origVideo(:, :, t) ones(size(origVideo, 1), 10) I];
        columnOffSet = size(origVideo, 2) + 10;
        imshow(combinedI, 'border', 'tight');
        for j = 1 : length(obj.DBbyFrame{t})
            tBlob = obj.DBbyFrame{t}(j);        
            cellBoundingShow(tBlob, tBlob.ID, rectShow, columnOffSet);
            obj.drawTrajectoryWithOrig(tBlob.ID, t, rectShow);
        end
        writenum2(t);
        pause(1/22);
        saver1.saveCore();
    end
    saver1.saveClose;
end