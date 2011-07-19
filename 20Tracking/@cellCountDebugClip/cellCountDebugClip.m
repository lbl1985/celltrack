classdef cellCountDebugClip < cellCountClip
    %CELLCOUNTDEBUGCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        inputVideoData
    end
    
    methods
        function obj = cellCountDebugClip(videoPath, videoName)
            obj = obj@cellCountClip(videoPath, videoName);
        end
        
        function blobTracking(obj, videoData)
            obj.inputVideoData = videoData;
        end
        
        function blobTrackingCore(obj)
            nSeg = zeros(obj.nFrame, 1);
            for t = 1 : obj.nFrame
                % for t = 58
                figure(1);
                % Read from Video
                % I = read(vobj, t); I = rgb2gray(I);
                % Read from .mat file
                I = obj.inputVideoData(:, :, t); I = uint8(I);
                
                imshow(I, 'border', 'tight');
                rectShow = figure(2); imshow(Ifilt, 'border', 'tight');
                STATS = regionprops(I>0);
                nSeg(t) = length(STATS);
                
                % In order to get rid of mass bg subtraction problem in the first
                % several frames, need to do DB clean up after 20 frames
                if t == 20
                    % Well, don't need t, and STATS at all. Just to fit in the
                    % interface.
                    DB = databaseFuncCell(t, DB, 'cleanUpBeginning', STATS);
                end
                
                if nSeg(t) ~= 0
                    % timsslot is varable to same information at frame t.
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
            end            
        end
    end
end