classdef cellCountGroundTruth < handle
    %CELLCOUNTGROUNDTRUTH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        videoPath
        videoName
        firstAppearLocation
        firstAppearFrame
        lastAppearFrame
    end
    
    properties(SetAccess = public)
        resultDataPathCompensation = '../../Results/vivo/groundTruth/';
    end
    
    methods
        function obj = cellCountGroundTruth(incomeVideoPath, incomeVideoName)
            if nargin > 0
                obj.videoPath = incomeVideoPath;
                obj.videoName = incomeVideoName;
            end
        end
        
        function obj = addEntry(obj, cellInfo)
            obj.firstAppearLocation = cat(1, obj.firstAppearLocation, cellInfo.fl);
            obj.firstAppearFrame = cat(1, obj.firstAppearFrame, cellInfo.ff);
            obj.lastAppearFrame = cat(1, obj.lastAppearFrame, cellInfo.lf);
        end
        
        % This function is not really functional
        function obj = saveGroundTruth(obj)
            save(fullfile(videoPath, resultDataPathCompensation, ['groundTruth_' videoName(1:end - 5) '.mat']), 'obj');
        end
                
    end
    
end

