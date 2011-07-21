classdef blobCell
    %BLOBCELL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        blobID
        appearInFrame
        appearLocation
        appearBoundingBox
        appearSize 
    end
    
    methods
        function obj = blobCell(blobInfo)
            if nargin > 0
                obj.blobID = blobInfo.id;
                obj.appearInFrame = blobInfo.frameNum;
                obj.appearLocation = blobInfo.Centroid;
                obj.appearSize = blobInfo.Area;
                obj.appearBoundingBox = blobInfo.BoundingBox;
            end
        end        
    end
    
end

