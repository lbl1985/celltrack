classdef TrackBlobs < handle
    %TRACKBLOBS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fg  
        fgAfterClosing
        nSeg = []

        DB = {};
        ID = 1;        
    end
    
    properties (SetAccess = public)
        record = 0;
        areaThreshold = 5;
        videoName = [];
    end
    
    methods
        function obj = TrackBlobs(inputForeGround)
            obj.fg = videoVar(inputForeGround);   
            obj.nSeg = zeros(obj.fg.nFrame, 1);
        end        
        
%         function OpenClosingProcessFunc(obj)
%             tmp = OpenClosingProcess(obj.fg.Data);
%             obj.fgAfterClosing = videoVar(tmp);
%         end
        
    end
end

