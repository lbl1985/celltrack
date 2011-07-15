classdef videoClip
    %VIDEOCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        foreGround_MoG = 0;
        foreGround_RPCA = 0;  
        origVideo = 0;
        videoName;
        videoPath;        
    end
    
    methods 
%         function obj = VideoClip()

        function obj = read_Video(videoPath, videoName)
            load(fullfile(videoPath, videoName));
%             obj.origVideo = 
        end
            
        function obj = read_fg_MoG(videoPath, videoName)
            load(fullfile(videoPath, videoName));
            obj.foreGround_MoG = fg;
        end
        
        function obj = read_fg_RPCA(videoPath, videoName)
            load(fullfile(videoPath, videoName));
            obj.foreGround_RPCA = fg;
        end
        
        
%         function comparePlot(obj)
            
    end
    
    methods % supporting functions

    end
        
    
end

