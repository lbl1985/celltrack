classdef cellCountDebugClip < cellCountClip
    %CELLCOUNTDEBUGCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        videoPathMac
    end
    
    methods
        function obj = cellCountDebugClip(videoPath, videoName)
            obj = obj@cellCountClip(videoPath, videoName);
        end
        
        function obj = copyCellCountClip(obj, incomeObject)
            obj = incomeObject;
        end
    end
    
    methods % supporting functions
        function obj = adjustVideoPath(obj)
            if ismac
                obj.videoPathMac = fullfile('~', obj.videoPath(18:end));
            end
        end
    end
end

