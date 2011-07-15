classdef videoClip < handle
    %VIDEOCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        foreGround_MoG;
        foreGround_RPCA;  
        origVideo;
        
        ratio = 0.5;
        
        nFrame; 
        videoName;
        videoPath;  
    end
    
    properties (SetAccess = public)
      
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
        
        function read_fg_RPCA(obj)
            resultVideoPathCompensation = '../../Results/vivo/batchRun_SIAM/';
            resultVideoNameCompensation = '_SIAM_bgSub.mat';
            loadingPath = fullfile(obj.videoPath, resultVideoPathCompensation);
            loadingName = [obj.videoName(1 : end - 4), resultVideoNameCompensation];
            load(fullfile(loadingPath, loadingName));
            obj.foreGround_RPCA = uint8(fg);
        end 
    end
    
    methods % supporting functions
            
    end
        
    
end

