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
                obj.nFrame = length(blobVideoGroupedByFrame);
            end
        end
        
        function pickCellPerFrame(obj)                
            for t = 1 : obj.nFrame
                [pickedCellTemp pickedCellTempLen indFrame] = assembleReadyToTestBlobs();
                % empty this list everytime after I used it.
%                 obj.pickedIdNeedTestInNextFrame = [];
                
                for i = 1 : pickedCellTempLen
                    indFrame(:, i) = obj.blobsGroupedByFrame(t).queryDistanceTest...
                        (pickedCellTemp(i));
                end
                
            end
            
        end
        
    end   
    
    methods % supporting functions
        function [pickedCellTemp pickedCellTempLen indFrame] = assembleReadyToTestBlobs(obj)
            % assemble picked cells
            if ~isempty(obj.trajArrCurrFrame)
                pickedCellTemp = obj.getTestTraj();
            end
            
            nBlobs = length(obj.blobsGroupedByFrame(obj.frameId));
            % assemble current frame blobs.
            if nBlobs ~= 0;
                pickedCellTemp = cat(1, pickedCellTemp, obj.blobsGroupedByFrame(obj.frameId));
            end
            pickedCellTempLen = length(pickedCellTemp);
            indFrame = zeros(nBlobs, pickedCellTempLen);
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

