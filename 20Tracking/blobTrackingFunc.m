function blobTrackingFunc(fg)
% input fg should be uint8 

record = 0;
[~, ~, nFrame] = size(fg);
nSeg = zeros(nFrame, 1);
areaThreshold = 5;
DB = {};
ID = 1;


if record
    moviefile = [videoName{id}(1:end - 4) '_blobTracking.avi']; framerate = 5;
    aviobj = avifile(moviefile, 'fps', framerate', 'compression', 'none');
end

for t = 1 : nFrame
    Ifilt = fg(:, :, t);    
    rectShow = figure(1); imshow(Ifilt, 'border', 'tight');
    STATS = regionprops(Ifilt>0);
    nSeg(t) = length(STATS);
    
    % In order to get rid of mass bg subtraction problem in the first
    % several frames, need to do DB clean up after 20 frames
    if t == 1
        % Well, don't need t, and STATS at all. Just to fit in the
        % interface.
        DB = databaseFuncCell(t, DB, 'cleanUpBeginning', STATS);
    end
    
    if nSeg(t) ~= 0
        % timeslot is varable to same information at frame t.
        % with all fields in STATS plus trakcingID;
        %         timeslot = STATS;
        % if Area is less than areaThreshold Pixels, set the Area equals to
        % 0
        a = structField2Vector(STATS, 'Area');
        %         timeslot(a < areaThreshold).Area =  0;
        % Find the index for all blobs with area larger than the
        % areaThreshold
        %         a = structField2Vector(timeslot, 'Area');
        ind = find(a >= areaThreshold);
        for i = 1 : length(ind)
            tBlob = STATS(ind(i));
            if isempty(DB)
                DB = databaseFuncCell(t, DB, 'add', tBlob, ID);
                cellBoundingShow(tBlob, ID, rectShow);
                ID = ID + 1;
            else
                idQuery = databaseFuncCell(t, DB, 'search', tBlob);
                if idQuery ~= 0
                    DB = databaseFuncCell(t, DB, 'update', tBlob, idQuery);
                    cellBoundingShow(tBlob, idQuery, rectShow);
                else
                    DB = databaseFuncCell(t, DB, 'add', tBlob, ID);
                    cellBoundingShow(tBlob, ID, rectShow);
                    ID = ID + 1;
                end
            end
        end
    end
    
    if record
        frame = getframe(gcf);
        aviobj = addframe(aviobj, frame);
    end
    display(['Frame ' num2str(t)]);
end

if record
    aviobj = close(aviobj);
end