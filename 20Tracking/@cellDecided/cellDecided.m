classdef cellDecided < blobCell
    %CELLDECIDED Summary of this class goes here
    %   Detailed explanation goes here
    % This class may be discarded in the future to be displaced by
    % trajectory class.
    
    properties
        cellId
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
        
        function obj = copyFromSuperClass(obj, incomeObj)
            obj = incomeObj;
        end
    end
    
end

