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
        
        
    end
end



% function obj = copyCellCountClip(obj, incomeObject)
% obj.resultVideoPathCompensation = incomeObject.resultVideoPathCompensation;
% obj.foreGround_MoG = incomeObject.resultVideoPathCompensation;
% obj.foreGround_RPCA = incomeObject.foreGround_RPCA;
% obj.origVideo = incomeObject.origVideo;
% obj.ratio = incomeObject.ratio;
% obj.nFrame = incomeObject.nFrame;
% obj.videoName = incomeObject.videoName;
% obj.videoPath = fullfile('~', incomeObject.videoPath(18:end));
% obj.T = incomeObject.T;
% obj.fTb = incomeObject.fTb;
% obj.nd = incomeObject.nd;
% obj.playType = incomeObject.playType;
% end