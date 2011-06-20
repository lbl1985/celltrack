% datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\database\celltracking';
vcm;
exp_mode = 'vivo';
record = 1;

switch exp_mode
    case 'fathom'
        videoName = {'3tubes_010flow_g10.avi', '3tubes_020flow_g20.avi', ...
            '3tubes_020flow_g20_focusbottom.avi', '18mm_2x_e3_015speed_focusbottom2.avi', ...
            '18mm_2x_e3_015speed_focustop.avi', '18mm_2x_e3_020speed.avi', ...
            '18mm_2x_e4_015speed.avi', '18mm_2x_e4_020speed.avi', 'cells_g15_5x_test1.avi', 'cells_g15_5x_test3.avi'};
        % Reading from video
        % datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\videos\Before';
        % fileName = fullfile(datapath, [videoName{id}(1:end - 4) '_FT1.avi'] );
        % vobj = VideoReader(fileName);
        % frameHeight = vobj.Height;
        % frameWidth = vobj.Width;
        % nFrame = vobj.NumberOfFrames;
        
        % Reading from .mat file
        datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\fathom\data';
        n = length(videoName);
    case 'vivo'
        sourceDataPath = 'C:\Users\lbl1985\Documents\MATLAB\work\database\celltracking\vivo';
        sourceDataPath = folderUniverse(sourceDataPath, 'PC');
        
        [sourceDataPath videoName n] = rfdatabase(sourceDataPath, [], '.avi');
        
        matDataPath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\data';
        
end

% Switch id controller to here. For batch processing.
for id =28 : n
    
    
    fileName = fullfile(matDataPath, [videoName{id}(1:end - 4) '_bgSub.mat'] );
    load(fileName);
    [frameHeight frameWidth nFrame] = size(fg);
    
    nSeg = zeros(nFrame, 1);
    PixelThreshold = 3000;
    areaThreshold = 100;
    DB = {};
    ID = 1;
    
    
    if record
        moviefile = [videoName{id}(1:end - 4) '_blobTracking.avi']; framerate = 5;
        aviobj = avifile(moviefile, 'fps', framerate', 'compression', 'none');
    end
    
    for t = 1 : nFrame
        % for t = 58
        figure(1);
        % Read from Video
        % I = read(vobj, t); I = rgb2gray(I);
        % Read from .mat file
        I = fg(:, :, t); I = uint8(I);
        
        imshow(I, 'border', 'tight');
        Ifilt = medfilt2(I); Ifilt = medfilt2(Ifilt);
        rectShow = figure(2); imshow(Ifilt, 'border', 'tight');
        STATS = regionprops(Ifilt>0);
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
        
        
        %     if nSeg(t) ~= 0
        %         a = structField2Vector(STATS, 'Area');
        %         if nSeg(t) < 10 && sum(a) < PixelThreshold;
        %             display(['Frame ' num2str(t)]);
        %             ColorSet = varycolor(nSeg(t));
        %             for i = 1 : length(STATS)
        %                 figure(2); hold on;
        %                 rectangle('Position', STATS(i).BoundingBox, 'EdgeColor', ColorSet(i, :), 'LineWidth', 4);
        %                 hold off;
        %             end
        %         end
        %     end
        if record
            frame = getframe(gcf);
            aviobj = addframe(aviobj, frame);
        end
    end
    
    if record
        aviobj = close(aviobj);
    end
    
    display(['Finish ID ' num2str(id)]);
end

% figure(3); plot(1:nFrame, nSeg);