classdef trajectory < dlnode
    %TRAJECTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id
        blobTrajecotry
    end
    
    methods
        function n = trajectory(id, blobCell)
            if nargin == 0
                id = 0;
                blobCell = [];
            end
        end
    end
    
end

