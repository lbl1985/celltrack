classdef cellDecided < blobCell
    %CELLDECIDED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = cellDecided(blobInfo)
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

