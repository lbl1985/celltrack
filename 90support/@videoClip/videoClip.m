classdef videoClip < handle
    %VIDEOCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        foreGround_MoG;
        foreGround_RPCA;  
        origVideo;
        
        ratio = 0.5;
        
        nFrame = 0; 
        videoName;
        videoPath;  
    end
    
    properties (SetAccess = public)
      T = 300;              fTb = 3 * 3;   
      nd = 4;        
      
      playType = 'rpca';
    end
    
    properties (Dependent = true, SetAccess = private)
%         fAlphaT
    end
    
    methods 
        function obj = videoClip(videoPath, videoName)
            obj.videoPath = videoPath;
            obj.videoName = videoName;            
        end

        function obj = read_Video(obj)
            obj.origVideo = movie2var(fullfile(obj.videoPath, obj.videoName), [], obj.ratio);  
            if obj.nFrame == 0
                obj.nFrame = size(obj.origVideo, ndims(obj.origVideo));
            end
        end
            
        function obj = bkgd_subtraction_MoG(obj)
            [mogVideo fAlphaT] = mogPrepareFunc(obj);
            bkgd = bkgd_methods();
            obj.foreGround_MoG = bkgd.mog(mogVideo, fAlphaT, obj.fTb, obj.nd);               
        end
        
        function obj = bkgd_subtraction_rpca(obj)
            bkgd = bkgd_methods();
            obj.foreGround_RPCA = bkgd.rpca(obj.origVideo);
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
    
    methods % supporting functions -- preparation
        function [mogVideo fAlphaT] = mogPrepareFunc(obj)
            if(obj.T ~= 0)
                fAlphaT = 1/ obj.T;
            else
                error('T should be 0');
            end
            mogVideo = [];
            if(ndims(obj.origVideo) == 3)
                % MoG require RGB data
                for t = 1 : obj.nFrame
                    mogVideo = cat(4, mogVideo, repmat(obj.origVideo(:, :, t), [1 1 3]));
                end                
            end
            
            repmat_para = [1 1 1 obj.nd];            
            mogVideo = repmat(mogVideo, repmat_para);
        end
        
        function typeSource = visPrepareFunc(obj)
            if strcmp(obj.playType, 'rpca') == 1
                typeSource = obj.foreGround_RPCA;
            else
                if strcmp(obj.playType, 'mog') == 1
                    typeSource = obj.foreGround_MoG;
                else
                    command = ['typeSource = obj.' obj.playType ';'];
                    eval(command);
                end
            end
        end
    end
    
    methods % supporting functions -- visualization
        function compareBkgdMethods(obj, mog, rpca)
            for t = 1 : obj.nFrame
                subplot(1, 3, 1);   imshow(obj.origVideo(:, :, t)); title(['orig Frame ' num2str(t)]);
                subplot(1, 3, 2);   imshow(mog(:, :, t)); title('mog');
                subplot(1, 3, 3);   imshow(rpca(:, :, t)); title('rpca');
                pause(1/22);
            end
        end
        
        function obj = coverNoiseCloud(obj)
            for t = 1 : obj.nFrame
                obj.foreGround_RPCA(135:156, 154 : 171, t) = 0;
            end
        end
        
        function playM_asVideo(obj)
            typeSource = visPrepareFunc(obj);
            for t = 1 : obj.nFrame
                imshow(typeSource(:, :, t));    title(['Frame ' num2str(t)]);
                pause(1/22);
            end
        end
        
        function saveM_asVideo(filename)
            typeSource = visPrepareFunc();
            videoSave1 = videoSaver(filename, 11);
            videoSave1.save(typeSource);
        end
        
        
    end
end

