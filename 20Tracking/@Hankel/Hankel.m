classdef Hankel
    %HANKEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        matrixForHankel
        hankelWindowSize
        hankelMatrix
    end
    
    properties
        U
        S
        V
        isDynamicsQualified = 0
    end
    
    methods
        function obj = Hankel(inputArray)
            obj.matrixForHankel = inputArray;
        end
        
        function setHankelWindowSize(obj, userSpecifiedHankelWindowSize)
            obj.hankelWindowSize = userSpecifiedHankelWindowSize;
        end
        
        function calculateHankelWindowSize(obj)
            obj.hankelWindowSize = ceil(size(obj.matrixForHankel, 2) / 3);
        end
        
        function hankelConstruction(obj)
            idx = hankel(1:obj.HankelWindowSize, ...
                obj.HankelWindowSize:size(obj.matrixForHankel, 2));
            k = obj.matrixForHankel(:, idx);
            obj.hankelMatrix = reshape(k, size(idx, 1) * size(k, 1), size(idx, 2));
        end
        
        function dynamicsAnalyse(obj)
            [obj.U obj.S obj.V] = svd(obj.hankelMatrix);
        end
        
        function rankOrder = dynamicsCriteria(obj)
            Sdiag = diag(obj.S);
            rankOrder = sum(Sdiag > mean(Sdiag) + std(Sdiag)/2);
        end
        
        function checkDynamics(obj)
            rankOrder = dynamicsCriteria(obj);
            if rankOrder == 1
                obj.isDynamicsQualified = 1;
            end
        end            
    end    
end

