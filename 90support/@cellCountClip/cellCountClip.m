classdef cellCountClip < videoClip
    %CELLCOUNTCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fg_rpca_threshold;
    end
    
    methods
        function obj = cellCountClip(videoPath, videoName)
            obj = obj@videoClip(videoPath, videoName);
        end
    end
    
end

