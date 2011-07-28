classdef DiffFrameDynamics < SameFrameDynamics
    %DIFFFRAMEDYNAMICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = DiffFrameDynamics(inputArray)
            obj = obj@SameFrameDynamics(inputArray);
        end
        
        function rankOrder = dynamicsCriteria(obj)
            Sdiag = diag(obj.S);
            rankOrder = sum(Sdiag > Sdiag(1) * 0.05);
        end
    end
    
end

