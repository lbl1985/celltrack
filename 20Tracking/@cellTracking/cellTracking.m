classdef cellTracking < handle
    %CELLCOUNTDEBUGCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        inputVideoData
        nFrame
        blobCellVideo
        blobCellFrameVideo
    end
    
    properties (SetAccess = public)
        frameId
    end
    
    methods
        function obj = cellTracking(videoData)
            if nargin > 0
                obj.inputVideoData = videoData;
                obj.nFrame = size(videoData, ndims(videoData));
                obj.blobCellFrameVideo = repmat(blobCellFrame, obj.nFrame, 1);
            end
        end
        
        function blobDetectionVideo(obj)
            for t = 1 : obj.nFrame
                obj.frameId = t;
                frameBlobs = obj.blobDetectionFrame();
                obj.blobCellFrameVideo(t) = blobCellFrame(frameBlobs);
                obj.blobCellVideo = cat(1, obj.blobCellVideo, frameBlobs);
            end                 
        end
        
        function frameBlobs = blobDetectionFrame(obj) 
            eachFrame = obj.extractFrame();
            STATS = regionprops(eachFrame>0);
            
            if ~isempty(STATS)
                frameBlobs = obj.extractBlobCellsFrame(STATS);
            else
                frameBlobs = [];
            end
               
        end
        
        function frameBlobs = extractBlobCellsFrame(obj, STATS)
            nSTATS = length(STATS);
            frameBlobs = blobCell();
            frameBlobs = repmat(frameBlobs, nSTATS, 1);
            for i = 1 : nSTATS
                eachSTATS = STATS(i);
                blobInfo = obj.extractBlobInfo(eachSTATS, i);
                frameBlobs(i) = blobCell(blobInfo);
            end
        end
                
        
        function blobInfo = extractBlobInfo(obj, eachSTATS, currentFrameId)
            blobInfo.id = length(obj.blobCellVideo)+1 + (currentFrameId -1);
            blobInfo.frameNum = obj.frameId;
            blobInfo.Area = eachSTATS.Area;
            blobInfo.BoundingBox  = eachSTATS.BoundingBox;
            blobInfo.Centroid = eachSTATS.Centroid;            
        end
        
%         function blobTrackingCore(obj)
%            
%         end
    end
    
    methods % supporting function
        function eachFrame = extractFrame(obj)
            eachFrame = obj.inputVideoData(:, :, obj.frameId);
            eachFrame = uint8(eachFrame);
        end
    end
end