classdef pickCell
    % pick the real cell among lots of blobCell candidates.
    %   Detailed explanation goes here
    
    properties        
        blobsGroupedByFrame
        nFrame
        pickedCells
        pickedIdNeedTestInNextFrame
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
                [pickedCellTemp pickedCellTempLen] = assembleReadyToTestBlobs();
                % empty this list everytime after I used it.
                obj.pickedIdNeedTestInNextFrame = [];
                for i = 1 : pickedCellTempLen
                    obj.blobsGroupedByFrame(t).queryDistanceTest(pickedCellTemp(i));
                end
                
            end
            
        end
        
    end   
    
    methods % supporting functions
        function [pickedCellTemp pickedCellTempLen] = assembleReadyToTestBlobs(obj)
            % assemble picked cells
            if ~isempty(obj.pickedIdNeedTestInNextFrame)
                pickedCellTemp = obj.pickedCells(obj.pickedIdNeedTestInNextFrame);
            end
            
            % assemble current frame blobs.
            if ~isempty(obj.blobsGroupedByFrame(obj.frameId))
                pickedCellTemp = cat(1, pickedCellTemp, ...
                    obj.copyFromBlobCellFrameToCellDecided(obj.blobsGroupedByFrame(obj.frameId)));
            end
            pickedCellTempLen = length(pickedCellTemp);
        end
        
        % convert data from class blobCell to cellDecided
        function frameBlobDecided = copyFromBlobCellFrameToCellDecided(frameBlobs)
            nBlobs = length(frameBlobs);
            frameBlobDecided = repmat(cellDecided(), nBlobs, 1);
            for i = 1 : nBlobs
                frameBlobDecided.copyFromSuperClass(frameBlobs(i));
            end
        end
    end            
end

