classdef cellCountDebugClip < cellCountClip
    %CELLCOUNTDEBUGCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = cellCountDebugClip(videoPath, videoName)
            obj = obj@cellCountClip(videoPath, videoName);
        end
        
        function copy
    end
    
end

