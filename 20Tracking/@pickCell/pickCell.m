classdef pickCell < handle
    % pick the real cell among lots of blobCell candidates.
    %   Detailed explanation goes here
    
    properties        
        blobsGroupedByFrame
        blobsQueryLeft
        nFrame
        pickedCells
        pickedIdNeedTestInNextFrame
        trajArrInVideo = []
        trajArrCurrFrame = []   % Because trajectory class is handle. Don't need Id
        tmpTrajArrCurrFrame = []
        QueryTrajLength = 0
    end
    
    properties
        blobsInNextFrame
    end
    
    properties (SetAccess = public)
        frameId
        searchRadius = 10;
    end
    
    methods
        function obj = pickCell(blobsVideoGroupedByFrame)
            if nargin > 0
                obj.blobsGroupedByFrame = blobsVideoGroupedByFrame;
                obj.nFrame = length(obj.blobsGroupedByFrame);
            end
        end
        
        function pickCellPerFrame(obj)  
            try
                for t = 1 : obj.nFrame -1
                    obj.frameId = t;
                    pickedCellTemp = obj.assembleReadyToTestBlobs();   
                    obj.createTrajectory(pickedCellTemp);                    
                end
            catch ME
                display(['t = ' num2str(t)]);
                disp(ME.stack);
                display(ME.message);                
            end
            
        end
        
    end 
    
    
    
    methods % supporting functions 
        function pickedCellTemp = assembleReadyToTestBlobs(obj)
            % assemble picked cells
            pickedCellTemp = [];    %pickedCellTempLen = 0; 
            for i = 1 : length(obj.trajArrCurrFrame)
                pickedCellTemp = cat(1, pickedCellTemp, obj.trajArrCurrFrame(i).blobTrajectory(end));
            end
            
            if ~isempty(obj.blobsGroupedByFrame(obj.frameId))
                tmpBlobs = obj.blobsGroupedByFrame(obj.frameId).frameBlobs;                
                % assemble current frame blobs.       
                pickedCellTemp = cat(1, pickedCellTemp, tmpBlobs);
            end
        end
    end            
end

