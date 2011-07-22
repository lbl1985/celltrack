classdef blobCellFrame
    %Group all blobs in one frame as on object in this class
    %   Detailed explanation goes here
    
    properties
        frameBlobs
        nBlobs
    end
    
    properties (SetAccess = public)
        searchRadius = 10;
    end
    
    methods
        function obj = blobCellFrame(incomeFrameBlobs)
            if nargin > 0
                obj.frameBlobs = incomeFrameBlobs;
                obj.nBlobs = length(incomeFrameBlobs);
            end
        end
        
        function isQulified = queryDistanceTest(obj, requirerCellDecided)            
            aimPosition = structField2Vector(obj.frameBlobs, 'appearLocation');
            shooterPosition = repmat(requirerCellDecided.appearLocation, size(aimPosition, 1), 1);
            
            distance = obj.vectorDistance(aimPosition - shooterPosition);
            isQulified = distance < obj.searchRadius;
        end                
    end
    
    methods % supporting functions
        function distance = vectorDistance(obj, rowvec)
        % calculate Euclidean distance for each row.
            nrow = size(rowvec, 1);
            distance = zeros(nrow, 1);
            for i = 1 : nrow
                distance(i) = norm(rowvec(i, :));
            end
        end
    end    
end

