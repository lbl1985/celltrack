classdef trajectory < handle
    %I may need to duplicate the trajectory, therefore, make this class as
    %value type.
    %   Detailed explanation goes here
    
    properties
        id = 0
        lastFrameId = 0
        listLength = 0
        blobTrajectory
    end
    
    methods
        function obj = trajectory(varargin)
            if nargin ~= 0
               if nargin == 2
                   [ID inputObject] = varin2out(varargin);
                    obj.id = ID;                
                    obj.blobTrajectory = inputObject;
                    obj.lastFrameId = inputObject.appearInFrame;
                    obj.listLength = 1;
               elseif nargin == 1
                   inputObject = varargin{1};
                   obj.id = inputObject.id;
                   obj.lastFrameId = inputObject.lastFrameId;
                   obj.listLength = inputObject.listLength;
                   obj.blobTrajectory = inputObject.blobTrajectory;
               end
                   
            end
        end
        
        function obj = add(obj, blobCell)
            obj.listLength = obj.listLength + 1;
            obj.blobTrajectory(obj.listLength) = blobCell;
            obj.lastFrameId = blobCell.appearInFrame;            
        end
        
        function obj = duplicate(anotherTrajectory)
            obj  = anotherTrajectory;
        end
    end
    
end

