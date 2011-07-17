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
        
        function binaryRpca(obj)
            if ~empty(obj.foreGround_RPCA)
                obj.fg_rpca_threshold = obj.foreGroundRPCA;
            end
            for t = 1 : obj.nFrame
                obj.fg_rpca_threshold(:, :, t) = obj.fg_rpca_threshold(:, :, t) > 1;
            end
        end
    end    
end

