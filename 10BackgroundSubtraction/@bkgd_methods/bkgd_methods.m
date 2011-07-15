classdef bkgd_methods < handle
    %BKGD_MOG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        startFrame;
        endFrame;
        inputVideo;
        fg;
    end
    
    methods(Static)
        function varargout = mog(varargin)
            % input variable and output varialbe situation
            if (nargout == 1 && nargin == 4)
                [obj.inputVideo fAlphaT fTb nd] = varin2out(varargin);
                [frameHeight, frameWidth, obj.endFrame obj.startFrame] = ...
                    videoDimension(obj.inputVideo);
                obj.fg = zeros(frameHeight, frameWidth, obj.endFrame - obj.startFrame + 1);
                lastLoopFrameNum = (obj.endFrame - obj.startFrame + 1) * (nd -1) / nd;
                
                mog_core(fAlphaT, fTb, lastLoopFrameNum);
                
                varargout{1} = obj.fg;
            end        
        end
        
        function mog_core(obj, fAlphaT, fTb, lastLoopFrameNum)
            for t=obj.startFrame:obj.endFrame
                % get the nextframe
                img = obj.inputVideo(:, :, t);
                if t==obj.startFrame
                    % initialize background subtraction
                    h=mexCvBSLib(img);%Initialize
                    mexCvBSLib(img,h,[fAlphaT fTb 0 0.5]);%set parameters
                end
                fgMask=mexCvBSLib(img,h);
                
                figure(1);  subplot(1,2,1);     imshow(img);
                fgMask = medfilt2(fgMask, [5 5]);
                subplot(1,2,2);imshow(fgMask);  title(sprintf('Frame:%d',t));
                
                % only record the last loop   % fgMask should be bool
                if t > lastLoopFrameNum                   
                    obj.fg(:, :, t - obj.startFrame + 1) = fgMask;
                end
            end
        end
    end
    
    methods (Static) % Supporting functions
        function [frameHeight frameWidth nFramesTotal startFrame] = videoDimension(inputVideo)
            siz = size(inputVideo);
            frameHeight = siz(1); frameWidth = siz(2);                
            nFramesTotal = size(inputVideo, ndims(inputVideo));
            startFrame = 1;
        end
    end
    
        
    
end

