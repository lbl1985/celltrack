classdef blobCellFrame
    %BLOBCELLFRAME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        frameBlobs
        nBlobs
    end
    
    methods
        function obj = blobCellFrame(incomeFrameBlobs)
            if nargin > 0
                obj.frameBlobs = incomeFrameBlobs;
                obj.nBlobs = length(incomeFrameBlobs);
            end
        end
    end
    
end

