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
      T = 300;              fTb = 3 * 3;   
      nd = 4;               
    end
    
    properties (Dependent = true, SetAccess = private)
        fAlphaT
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
            
        function obj = bkgd_subtraction_MoG(obj)
            mogVideo = mogPrepareFunc(obj);
            obj.foreGround_MoG = bkgd_methods.mog(mogVideo, 1/obj.T, obj.fTb, obj.nd);            
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
        function mogVideo = mogPrepareFunc(obj)
            if(obj.T ~= 0)
                obj.fAlphaT = 1/ obj.T;
            end
            if(ndims(obj.origVideo) == 3)
                repmat_para = [ 1 1 obj.nd];
            else
                repmat_para = [1 1 1 obj.nd];
            end
            mogVideo = repmat(obj.origVideo, repmat_para);
        end
            
        
    end
        
    
end

