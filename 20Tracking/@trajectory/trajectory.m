classdef trajectory
    %I may need to duplicate the trajectory, therefore, make this class as
    %value type.
    %   Detailed explanation goes here
    
    properties
        id = 0
        lastFrameId = 0
        listLength = 0
        blobTrajecotry = []
    end
    
    methods
        function obj = trajectory(id, blobCell)
            if nargin ~= 0
                obj.id = id;
                obj.blobTrajecotry = blobCell;
                obj.lastFrameId = blobCell.appearInFrame;
                obj.listLength = 1;
            end
        end
    end
    
end

