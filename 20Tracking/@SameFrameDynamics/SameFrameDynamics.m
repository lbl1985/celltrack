classdef SameFrameDynamics < Hankel
    %SAMEFRAMEDYNAMICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SameFrameDynamics(inputArray)
            obj = obj@Hankel(inputArray);
        end
        
        function mainCheckDynamics(obj)
            obj.calculateHankelWindowSize;
            obj.hankelConstruction;
            obj.dynamicsAnalyse;
            obj.checkDynamics; 
        end
    end
    
end

