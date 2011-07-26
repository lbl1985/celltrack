function  blobTrackingFunc(obj)
%BLOBTRACKINGFUNC Summary of this function goes here
%   Detailed explanation goes here

for t = 1 : obj.fg.nFrame
    Ifilt = obj.fgAfterClosing.Data(:, :, t);
%     Ifilt = obj.fg.Data(:, :, t);    
    STATS = regionprops(Ifilt>0);
    obj.nSeg(t) = length(STATS);
    
    % In order to get rid of mass bg subtraction problem in the first
    % several frames, need to do DB clean up after 20 frames
    if t == 1
        % Well, don't need t, and STATS at all. Just to fit in the
        % interface.
        obj.DB = databaseFuncCell(t, obj.DB, 'cleanUpBeginning', STATS);
    end
    
    if obj.nSeg(t) ~= 0
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
        ind = find(a >= obj.areaThreshold);
        for i = 1 : length(ind)
            tBlob = STATS(ind(i));
            if isempty(obj.DB)
                obj.DB = databaseFuncCell(t, obj.DB, 'add', tBlob, obj.ID);
                obj.ID = obj.ID + 1;
            else
                idQuery = databaseFuncCell(t, obj.DB, 'search', tBlob);
                if idQuery ~= 0
                    obj.DB = databaseFuncCell(t, obj.DB, 'update', tBlob, idQuery);
                else
                    obj.DB = databaseFuncCell(t, obj.DB, 'add', tBlob, obj.ID);
                    obj.ID = obj.ID + 1;
                end
            end
        end
    end
    display(['Frame ' num2str(t)]);
end
end

