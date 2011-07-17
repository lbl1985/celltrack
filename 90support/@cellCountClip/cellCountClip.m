classdef cellCountClip < videoClip
    %CELLCOUNTCLIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fg_rpca_threshold;
        fg_rpca_median;
    end
    
    properties (SetAccess = public)
        resultVideoPathCompensation = '../../Results/vivo/batchRun_object/';
    end
    
    methods
        function obj = cellCountClip(videoPath, videoName)
            obj = obj@videoClip(videoPath, videoName);
        end
        
        function binaryRpca(obj)
            if ~isempty(obj.foreGround_RPCA)
                obj.fg_rpca_threshold = obj.foreGround_RPCA;
            end
            for t = 1 : obj.nFrame
                obj.fg_rpca_threshold(:, :, t) = obj.fg_rpca_threshold(:, :, t) > 0.01;
            end
        end
        
        function medianFilter(obj)
            if ~isempty(obj.foreGround_RPCA)
                obj.fg_rpca_median = obj.foreGround_RPCA;
            end
            for t = 1 : obj.nFrame
                obj.fg_rpca_median(:, :, t) = medfilt2(obj.fg_rpca_median(:, :, t), [4 4]);
            end
        end                
    end  
    
    methods % supporting functions
        function obj = saveData(obj)
            videoID = obj.videoName(1:end-4);
            command = ['v' videoID ' = obj; save(fullfile(obj.videoPath, '...
                'obj.resultVideoPathCompensation, ''video_' videoID '.mat''), ''v' videoID ''')'];
            eval(command);
        end
    end            
end

