classdef pickCell < handle
    % pick the real cell among lots of blobCell candidates.
    %   Detailed explanation goes here
    
    properties        
        blobsGroupedByFrame
        blobsQueryLeft
        nFrame
        pickedCells
        pickedIdNeedTestInNextFrame
        trajArrInVideo = []
        trajArrCurrFrame = []   % Because trajectory class is handle. Don't need Id
        tmpTrajArrCurrFrame = []
        QueryTrajLength = 0
    end
    
    properties (SetAccess = public)
        frameId
        searchRadius = 10;
    end
    
    methods
        function obj = pickCell(blobsVideoGroupedByFrame)
            if nargin > 0
                obj.blobsGroupedByFrame = blobsVideoGroupedByFrame;
                obj.nFrame = length(obj.blobsGroupedByFrame);
            end
        end
        
        function pickCellPerFrame(obj)  
            try
                for t = 1 : obj.nFrame -1
                    obj.frameId = t;
                    [pickedCellTemp pickedCellTempLen] = obj.assembleReadyToTestBlobs();
                    display(['t = ' num2str(t) '; pickedCellTempLen = ' num2str(pickedCellTempLen)]);
                    % empty this list everytime after I used it.
                    if ~isempty(obj.blobsGroupedByFrame(t + 1).frameBlobs) && pickedCellTempLen ~= 0
                        indFrame = zeros(length(obj.blobsGroupedByFrame(t+1).frameBlobs), pickedCellTempLen);                    
                        for i = 1 : pickedCellTempLen
                            indFrame(:, i) = obj.blobsGroupedByFrame(t + 1).queryDistanceTest...
                                (pickedCellTemp(i));
                            qualifyId = find(indFrame(:, i));
                            % traj is on top of blobs
                            if i <= obj.QueryTrajLength 
                                obj.trajUpdateTraj();
                                for j = 1 : length(qualifyId)
                                    obj.trajArrCurrFrame(i).add(obj.blobsGroupedByFrame(t + 1).frameBlobs(qualifyId(j)));
                                    tmpId = length(obj.tmpTrajArrCurrFrame) + 1;
                                    if isempty(obj.tmpTrajArrCurrFrame)
                                        obj.tmpTrajArrCurrFrame = obj.trajArrCurrFrame(i);
                                    else
                                        obj.tmpTrajArrCurrFrame(tmpId) = obj.trajArrCurrFrame(i);
                                    end
                                end
                            else
                                for j = 1 : length(qualifyId)  
                                    id = length(obj.trajArrInVideo) + 1; 
                                    if isempty(obj.trajArrInVideo) 
                                        obj.trajArrInVideo = trajectory(id, obj.blobsGroupedByFrame(t + 1).frameBlobs(qualifyId(j)));
                                    else
                                        obj.trajArrInVideo(id) = trajectory(id, obj.blobsGroupedByFrame(t + 1).frameBlobs(qualifyId(j)));
                                    end
                                    tmpId = length(obj.tmpTrajArrCurrFrame) + 1;
                                    if isempty(obj.tmpTrajArrCurrFrame)
                                        obj.tmpTrajArrCurrFrame = obj.trajArrInVideo(id);
                                    else
                                        obj.tmpTrajArrCurrFrame(tmpId) = obj.trajArrInVideo(id);
                                    end
                                end
                            end  
                            obj.trajArrCurrFrame = obj.tmpTrajArrCurrFrame;
                            obj.QueryTrajLength = length(obj.trajArrCurrFrame);
                            obj.tmpTrajArrCurrFrame = [];
                        end
                    end
                end
            catch ME
                display(['t = ' num2str(t)]);
                disp(ME.stack);
                display(ME.message);                
            end
            
        end
        
    end   
    
    methods % supporting functions  
        function trajUpdateTraj()
        end
        function tmpId = updateTmpTrajArrCurrFrameTraj(obj)
            if isempty(obj.tmpTrajArrCurrFrame), tmpId = 1;
            else tmpId = length(obj.tmpTrajArrCurrFrame) + 1; end            
        end
%         function tmpId = updateTmpTrajArrCurrFrameBlob(obj, blobId)
            
        function [pickedCellTemp pickedCellTempLen] = assembleReadyToTestBlobs(obj)
            % assemble picked cells
            pickedCellTemp = [];    %pickedCellTempLen = 0; 
            for i = 1 : length(obj.trajArrCurrFrame)
                pickedCellTemp = cat(1, pickedCellTemp, obj.trajArrCurrFrame(i).blobTrajectory(end));
            end
            
            if ~isempty(obj.blobsGroupedByFrame(obj.frameId))
                tmpBlobs = obj.blobsGroupedByFrame(obj.frameId).frameBlobs;                
                % assemble current frame blobs.       
%                 id = length(pickedCellTemp)  + (1 : length(tmpBlobs));
                pickedCellTemp = cat(1, pickedCellTemp, tmpBlobs);
            end
            
%             if ~isempty(pickedCellTemp)
                pickedCellTempLen = length(pickedCellTemp);                
%             end
        end
    end            
end

