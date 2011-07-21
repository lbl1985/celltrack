classdef pickCell
    % pick the real cell among lots of blobCell candidates.
    %   Detailed explanation goes here
    
    properties        
        blobsGroupedByFrame
        nFrame
        pickedCells
        pickedIdNeedTestInNextFrame
        trajArrInVideo
        trajArrCurrFrame
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
                    % empty this list everytime after I used it.
                    if ~isempty(obj.blobsGroupedByFrame(t + 1).frameBlobs)
                        indFrame = zeros(length(obj.blobsGroupedByFrame(t+1).frameBlobs), pickedCellTempLen);                    
                        for i = 1 : pickedCellTempLen
                            indFrame(:, i) = obj.blobsGroupedByFrame(t + 1).queryDistanceTest...
                                (pickedCellTemp(i));
                        end
                    end

                end
            catch ME
                display(['t = ' num2str(t)]);
                display(ME.message);
            end
            
        end
        
    end   
    
    methods % supporting functions
        function [pickedCellTemp pickedCellTempLen] = assembleReadyToTestBlobs(obj)
            % assemble picked cells
            pickedCellTemp = [];    pickedCellTempLen = 0;  indFrame = [];
            if ~isempty(obj.trajArrCurrFrame)
                pickedCellTemp = obj.getTestTraj();
            end
            
            if ~isempty(obj.blobsGroupedByFrame(obj.frameId))
                tmpBlobs = obj.blobsGroupedByFrame(obj.frameId).frameBlobs;
                nBlobs = length(tmpBlobs);
                % assemble current frame blobs.            
                pickedCellTemp = cat(1, pickedCellTemp, tmpBlobs);
            end
            
            if ~isempty(pickedCellTemp)
                pickedCellTempLen = length(pickedCellTemp);
                indFrame = zeros(nBlobs, pickedCellTempLen);
            end
        end
        
        % convert data from class blobCell to cellDecided
%         function frameBlobDecided = copyFromBlobCellFrameToCellDecided(frameBlobs)
%             nBlobs = length(frameBlobs);
%             frameBlobDecided = repmat(cellDecided(), nBlobs, 1);
%             for i = 1 : nBlobs
%                 frameBlobDecided.copyFromSuperClass(frameBlobs(i));
%             end
%         end
%         Calling Function 
%                 pickedCellTemp = cat(1, pickedCellTemp, ...
%                     obj.copyFromBlobCellFrameToCellDecided(obj.blobsGroupedByFrame(obj.frameId)));

    end            
end

