classdef videoClip
    %VIDEOCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        foreGround_MoG = 0;
        foreGround_RPCA = 0;  
        origVideo = 0;
        
        ratio = 1;
        
        nFrame = 0; 
        videoName;
        videoPath;  
    end
    
    properties (SetAccess = public)

       resultVideoNameCompensation = '';
       resultVideoPathCompensation = '';        
    end
    
    methods 
        function obj = videoClip(videoPath, videoName)
            obj.videoPath = videoPath;
            obj.videoName = videoName;            
        end

        function obj = read_Video(obj)
            obj.origVideo = movie2var(fullfile(obj.videoPath, obj.videoName), [], obj.ratio);  
            if obj.nFrame ~= 0
                obj.nFrame = size(obj.origVideo, ndims(obj.origVideo));
            end
        end
            
        function obj = read_fg_MoG(videoPath, videoName)
            load(fullfile(videoPath, videoName));
            obj.foreGround_MoG = fg;
        end
        
        function obj = read_fg_RPCA(videoPath, videoName)
            load(fullfile(videoPath, videoName));
            obj.foreGround_RPCA = fg;
        end
        
        function comparePlot(obj)
            
            subplot(1, 3, 1);             
        end
            
    end
    
    methods % supporting functions
%         function obj = set.videoName(obj, inputName)
%             obj.videoName = inputName;
%         end
%         function obj = set.videoPath(obj, inputPath)
%             obj.videoPath = inputPath;
%         end
            
    end
        
    
end

