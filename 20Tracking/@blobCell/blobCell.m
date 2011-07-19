classdef blobCell < handle
    %BLOBCELL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        appearInFrame
        appearLocation
        appearSize
    end
    
    methods
        function obj = blobCell(blobInfo)
            obj.appearInFrame = blobInfo.frameNum;
            obj.appearLocation = blobInfo.Centroid;
            obj.appearSize = blobInfo.Area;
        end        
    end
    
end

