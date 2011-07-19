classdef detectBlob < handle
    %CELLCOUNTDEBUGCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        inputVideoData
        nFrame
        blobCellVideo
        blobCellFrameVideo
        centroidTrajectory
        centroidTrajectoryIncrease
    end
    
    properties (SetAccess = public)
        frameId
        
    end
    
    methods
        function obj = detectBlob(videoData)
            if nargin > 0
                obj.inputVideoData = videoData;
                obj.nFrame = size(videoData, ndims(videoData));
                obj.blobCellFrameVideo = repmat(blobCellFrame, obj.nFrame, 1);
            end
        end
        
        % TODO: This function might be removed in the future.
        function blobDetectionVideo(obj)
            for t = 1 : obj.nFrame
                obj.frameId = t;
                frameBlobs = obj.blobDetectionFrame();
                obj.blobCellFrameVideo(t) = blobCellFrame(frameBlobs);
                obj.blobCellVideo = cat(1, obj.blobCellVideo, frameBlobs);
                obj.plotCentroids(frameBlobs);
                
            end  
            obj.centroidTrajectoryIncreaseCreate();
        end
        
        % TODO: the functionaliyt of this function might be improved 
        % by adding blobCellFrameVideo and blobCellVideo cat functionality
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
    end
    
    methods % supporting function
        function eachFrame = extractFrame(obj)
            eachFrame = obj.inputVideoData(:, :, obj.frameId);
            eachFrame = uint8(eachFrame);
        end
        
        function cellDecidedTemp = copyFrameBlobs(frameBlobs)
            nBlobs = length(frameBlobs);
            cellDecidedTemp = repmat(cellDecided(), nBlobs, 1);
            for i = 1 : nBlobs
                cellDecidedTemp(i) = cellDecidedTemp(i).copyFromSuperClass(frameBlobs(i));
            end
        end
        
        function plotCentroids(obj, frameBlobs)
            siz = (size(obj.inputVideoData));   pointSize = 1;
            centroidTrajectoryTemp = uint8(zeros(siz(1), siz(2)));
            nBlobs = length(frameBlobs);
            
            for i = 1 : nBlobs
                paintingLocation = floor(frameBlobs(i).appearLocation);
                paintingLocationX = ((max(1, paintingLocation(1) - pointSize)) : min((paintingLocation(1) + pointSize), siz(1)));
                paintingLocationY = ((max(1, paintingLocation(2) - pointSize)) : min((paintingLocation(2) + pointSize), siz(2)));
                centroidTrajectoryTemp(paintingLocationY, paintingLocationX) = 255;
                %                 centroidTrajectoryTemp(paintingLocation) = 255;
            end
            obj.centroidTrajectory = cat(3, obj.centroidTrajectory, centroidTrajectoryTemp);            
        end
        
        function centroidTrajectoryIncreaseCreate(obj)            
            obj.centroidTrajectoryIncrease = obj.centroidTrajectory;
            for t = 1 : obj.nFrame
                obj.centroidTrajectoryIncrease(:, :, t) = sum(obj.centroidTrajectoryIncrease(:, :, 1 : t), 3);
            end
        end
                
        
        function saveVideoCombinedImage(obj, fileName)
            combinedImage = sum(obj.centroidTrajectory, 3);
%             imshow(combinedImage);
            imwrite(combinedImage, fileName);
        end
    end
end