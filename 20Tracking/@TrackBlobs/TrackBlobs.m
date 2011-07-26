classdef TrackBlobs < handle
    %TRACKBLOBS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fg  
        fgAfterClosing
        nSeg = []        
        ID = 1;        
    end
    
    properties
        DB = {};
        DBbyFrame
    end
        
    
    properties (SetAccess = public)
        record = 0;
        timeSearchScope = 15;
        searchRadius = 10;
        areaThreshold = 5;
        videoName = [];
    end
    
    methods
        function obj = TrackBlobs(inputForeGround)
            obj.fg = videoVar(inputForeGround);   
            obj.nSeg = zeros(obj.fg.nFrame, 1);
        end    
        % function blobTrackingFunc
        % function DBSortByFrame
        % function OpenClosingProcess
        % function playTrackingBlobs
        % function saveTrackingBlobs
    end
end

